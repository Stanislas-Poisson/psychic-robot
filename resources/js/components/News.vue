<template>
    <section>
        <div class="container">
            <slot v-if="loaded">
                <div id="results">
                    <div class="card" v-for="(item, index) in news" :key="item.id">
                        <img :src="item.local_image" />
                        <div class="content">
                            <h3>{{ item.title }}</h3>
                            <div>{{ item.description }}</div>
                        </div>
                        <aside>
                            <router-link :to="{ name: 'news.show', params: { id: item.id } }">Lire l'article</router-link>
                        </aside>
                    </div>
                </div>
            </slot>

            <slot v-else>
                <p class="txt-center">
                    Veuillez patientez, chargement en cours : <span class="bold">{{ nbr.loaded }}/{{ nbr.total }}</span>
                </p>
            </slot>
        </div>
    </section>
</template>

<script>
export default {
    data() {
        return {
            api_uri: process.env.MIX_APP_API_WEB_URL,

            loaded: false,
            nbr: {
                loaded: 0,
                total: 0,
            },
            ready: {
                news: false,
            },

            news: {},
        }
    },

    watch: {
        ready: {
            deep: true,
            handler: 'isFullLoaded',
        },
    },

    methods: {
        storeNews(news) {
            this.news = news
            this.ready.news = true
        },

        isFullLoaded() {
            this.nbr.loaded = Object.values(this.ready).reduce((a, item) => a + item, 0)

            if (this.nbr.loaded === this.nbr.total) {
                this.loaded = true
            } else {
                this.loaded = false
            }
        },
    },
    created: async function () {
        this.nbr.total = Object.keys(this.ready).length

        await axios.get(this.api_uri + 'news').then(response => this.storeNews(response.data))
    },
}
</script>
