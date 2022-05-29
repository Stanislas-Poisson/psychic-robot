<template>
    <section>
        <div class="container">
            <slot v-if="loaded">
                <article>
                    <img :src="itemNew.image" />
                    <div class="content">
                        <h2>{{ itemNew.title }}</h2>
                        <div>{{ itemNew.text }}</div>
                    </div>
                </article>
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
                itemNew: false,
            },

            itemNew: {},
        }
    },

    watch: {
        ready: {
            deep: true,
            handler: 'isFullLoaded',
        },
    },

    methods: {
        storeItemNew(itemNew) {
            this.itemNew = itemNew
            this.ready.itemNew = true
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

        await axios.get(this.api_uri + 'new/' + this.$route.params.id).then(response => this.storeItemNew(response.data))
    },
}
</script>
