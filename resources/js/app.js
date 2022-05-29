/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap')

import Vue from 'vue'

Vue.config.devtools = 'production' !== process.env.MIX_APP_ENV

import VueRouter from 'vue-router'
Vue.use(VueRouter)

const router = new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/',
            name: 'news',
            component: require('./components/News.vue').default,
        },

        {
            path: '/new/:id',
            name: 'news.show',
            component: require('./components/New.vue').default,
        },

        {
            path: '*',
            redirect: '/',
        },
    ],
})

new Vue({
    el: '#app',
    router,
    render: h => h(require('./App.vue').default),
})
