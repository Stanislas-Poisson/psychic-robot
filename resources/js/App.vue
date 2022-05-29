<template>
    <div>
        <header>
            <div class="container">
                <router-link :to="{ name: 'news' }">Psychic Robot</router-link>
            </div>
        </header>
        <router-view></router-view>
    </div>
</template>

<script>
export default {
    data() {
        return {}
    },
}
</script>
