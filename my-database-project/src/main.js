import Vue from 'vue'
import App from './App.vue'
import router from './router'
import _ from 'lodash'

import '@/plugins/element'
import '@/plugins/http'

Vue.config.productionTip = false
Vue.prototype.$EventBus = new Vue()
Vue.prototype._ = _

new Vue({
  render: h => h(App),
  router
}).$mount('#app')
