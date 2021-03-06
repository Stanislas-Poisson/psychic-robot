# Psychic Robot

| Branche | Status |
| ------- | ------ |
| Master | [![pipeline status](https://gitlab.com/Stanislas-Poisson/psychic-robot/badges/master/pipeline.svg)](https://gitlab.com/Stanislas-Poisson/psychic-robot/commits/master) |
| Develop | [![pipeline status](https://gitlab.com/Stanislas-Poisson/psychic-robot/badges/develop/pipeline.svg)](https://gitlab.com/Stanislas-Poisson/psychic-robot/commits/develop) |

This is a [Laravel 8.x](https://laravel.com/docs/8.x) app.

## Requirements

- Docker
- Docker-compose
- Make
- PHP >= 7.4.12
  - OpenSSL PHP Extension
  - PDO PHP Extension
  - Mbstring PHP Extension
  - Tokenizer PHP Extension
  - XML PHP Extension
  - Ctype PHP Extension
  - JSON PHP Extension
  - BCMath PHP Extension
  - PCNTL PHP Extension
- Node.js 14.X
  - yarn
- A MySQL 5.7 database and a user with the `SUPER` priviledge on it

## How to run

### Using the provided Docker-based Makefile

- install Docker and Docker Compose
- login to the registry `docker login registry.gitlab.com` with your login and password or auth token (with a `read_registry` at least)
- `cp .env.example .env`
- if needed customize `.env`  - _the content was already set for the docker dev usage_
- `make start`

Run `make help` to see the list of possible commands.

### Front development environment

Then:
- `make ssh`
- `yarn watch-poll`

### Manually

- `cp .env.example .env` and customize `.env`
- `composer install --no-progress --profile --no-interaction --prefer-dist --optimize-autoloader`
- `yarn install --ignore-engines --frozen-lockfile`
- `npx browserslist@latest --update-db`
- `yarn run development`
- `php artisan migrate:fresh --force --seed`
- `php artisan storage:link`
- `php artisan mediastack:get`

Then, use [Homestead](https://laravel.com/docs/master/homestead), `php artisan serve` or whatever to serve the app.

## Coding Style and Tests

You have to use coding rules on this projet, please use these commands to check or fix your code:

### Using the provided Docker-based Makefile
#### Check
- `make ci` Run the checks-files and tests pipelines
- `make checks-files` Run the PHP-CS-Fixer and Prettier with PHPstan pipelines
- `make tests` Run the PHPUnit pipelines
- `make cs` Run the PHP-CS-Fixer and Prettier pipeline
- `make phpstan` Run the PHPstan pipeline
- `make unit` Run the PHPUnit pipeline

#### Fix
- `make fix` to apply the rules to your code

## Update dependencies
### Using the provided Docker-based Makefile
- `make ssh`
- `composer update --no-progress --profile --no-interaction --prefer-dist --optimize-autoloader` to update the composer dependencies based on the composer.json
- `yarn upgrade-interactive --latest` to update the node modules dependencies based on the package.json
Please keep in mind that these updates may break the build, so update them carefully and feel free to restart the front build at each update.

## How to use

Just go on the app and use it.

## About the project
Ce projet utilise l'API de MediaStack avec un filtre sur la source du Point et la langue Fr.
MediaStack pourvoit un retour structur?? mais sans le text complet, d'ou l'usage de Goutte qui permet d'aller r??cup??rer directement le contenu de la cible.
Pour un affichage plus optimis??, lors de l'enregistrement sont stocker une version modifier par la librairie Imagine de l'image d'illustration.

### Blocage
N'ayant pas trouver d'API public aupr??s des diff??rents ??ditoriaux, je me suis tourner apr??s recherche vers MediaStack qui fournit un ensemble de m??dias suffisament conc??quent pour le projet en cours.

### TODO
Am??liorer le parsing via Goutte afin d'??liminer les ??l??ments superflue et ne garder que le contenu m??me.
Am??liorer aussi le rendu visuel en enregistrant les retours ?? la ligne du texte distant et potentiellement le formattage appliquer (soit directement en html soit via une transposition type Markdown ou BBcode)
