.DEFAULT_GOAL = help
.PHONY: help ssh design restart stop start fix renew-app renew-rights ci check-files tests cs phpstan unit behat behat-goutte behat-javascript behat-wip behat-list queue-listen clean dist-clean db-reset docker-prune

include .env

COMPOSE = docker-compose
RUN = $(COMPOSE) run --rm app
EXEC = docker exec -u www -t dk_psychic_robot_app
INTERACTIVE_EXEC = docker exec -ti dk_psychic_robot_app
COMPOSE_HTTP_TIMEOUT = 300

help:	## Show this help
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

ssh:	## Acces to the dk_psychic_robot_app
	@$(INTERACTIVE_EXEC) bash

design:	## Compiled the front inside of the dk_psychic_robot_app
	@$(INTERACTIVE_EXEC) bash -c "yarn watch-poll"

design-stats:	## Compiled the front inside of the dk_psychic_robot_app with the stats
	@$(INTERACTIVE_EXEC) bash -c "yarn watch-poll-stats"

restart: stop start	## Execute stop and start

stop:	## Stop and clear the project
	if [ -f .env.bak ]; then cp .env.bak .env && rm -f .env.bak; fi
	(docker ps -aq | xargs docker stop) || true
	(docker ps -aq | xargs docker rm) || true
	(docker volume ls -q | xargs docker volume rm) || true
	(docker network ls -q | xargs docker network rm) || true

start: stop	## Start the project
	$(COMPOSE) pull --ignore-pull-failures
	$(COMPOSE) build --force-rm --pull --no-cache
	$(COMPOSE) up -d --remove-orphans

	if [ ! -f .env ]; then cp .env.example .env; fi
	$(RUN) chown -R 1000:www /var/www
	$(RUN) chmod -R 0777 /var/www/storage /var/www/bootstrap

	$(RUN) composer install --no-progress --profile --no-interaction --prefer-dist --optimize-autoloader

	$(RUN) php artisan migrate --force --seed

	$(RUN) yarn install --ignore-engines --frozen-lockfile
	$(RUN) npx browserslist@latest --update-db
	$(RUN) yarn development

	if [ ! -L public/storage ]; then $(RUN) php artisan storage:link; fi
	$(RUN) chown -R 1000:www /var/www
	$(RUN) chmod -R 0777 /var/www/storage /var/www/bootstrap/cache
	$(RUN) rm -Rf storage/logs/*

	$(COMPOSE) up -d app
	$(COMPOSE) up -d

ide-helper:	## Create or renew the file used by ide
	$(RUN) php artisan ide-helper:generate
	$(RUN) php artisan ide-helper:meta

fix: fix-php fix-prettier	## Remove the .php_cs.cache, run the PHP-CS-Fixer and Prettier to fix the files

fix-php:	## Remove the .php_cs.cache, run the PHP-CS-Fixer to fix the files
	$(RUN) rm -f .php_cs.cache || true
	$(RUN) php-cs-fixer fix --config=.php-cs-fixer.php --using-cache=no

fix-prettier:	## Run the Prettier to fix the files
	$(RUN) prettier --write "resources/**/*.+(js|json|scss|sass|css|vue)" "composer.json" "package.json" "webpack.mix.js"

renew-app:	## Renew the app
	$(RUN) composer run-script renew-app

renew-rights:	## Renew the rights for the projects
	$(RUN) chown -R 1000:www ./ && chmod -R 0777 ./storage ./bootstrap/cache && rm -Rf ./storage/logs/*

ci: check-files tests	## Run the check-files and tests pipelines

check-files: cs phpstan	## Run the PHP-CS-Fixer and Prettier with PHPstan pipelines

tests: unit	## Run the PHPUnit pipelines

cs:	## Run the PHP-CS-Fixer and Prettier pipeline
	$(RUN) rm -f .php_cs.cache || true
	$(RUN) php-cs-fixer fix --config=.php-cs-fixer.php --using-cache=no --dry-run --diff
	$(RUN) prettier --check "resources/**/*.+(js|json|scss|sass|css|vue)" "composer.json" "package.json" "webpack.mix.js"

phpstan:	## Run the PHPstan pipeline
	$(RUN) vendor/bin/phpstan analyse --memory-limit=2G

unit:	## Run the PHPUnit pipeline
	$(RUN) cp .env .env.bak
	$(RUN) cp .env.test .env
	$(RUN) composer run-script renew-app
	$(RUN) vendor/bin/phpunit --stderr --colors=never
	$(RUN) cp .env.bak .env
	$(RUN) rm -f .env.bak
	$(RUN) composer run-script renew-app

queue-listen:	## Show the queue listen by artisan through docker
	$(RUN) php artisan queue:listen

clean:	## Clean the Laravel cache, view, config, route and delete some directories
	$(RUN) rm -Rf public/build/* public/css/* public/js/* storage/debugbar
	$(RUN) composer run-script renew-app
	$(RUN) php artisan debugbar:clear
	$(RUN) php artisan event:clear

dist-clean: clean	## In addition to "clean" delete the node_modules and vendor directories
	$(RUN) rm -Rf node_modules vendor

db-reset:	## Rebuild, migrate and seed the database
	$(RUN) php artisan migrate:fresh --force --seed

docker-prune:	## Prune the system
	docker system prune -af
