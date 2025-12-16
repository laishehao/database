/*
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-07 19:37:47
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 13:56:52
 * @FilePath: \my-database-project\src\main.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import _ from 'lodash'

import '@/plugins/element'
import '@/plugins/http'

Vue.config.productionTip = false
Vue.prototype.$EventBus = new Vue()
Vue.prototype._ = _

new Vue({
  render: h => h(App),
  router,
  store
}).$mount('#app')
