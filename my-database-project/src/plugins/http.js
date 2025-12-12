/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-11 00:04:49
 * @LastEditors: Garyonit 3253975221@qq.com
 * @LastEditTime: 2025-12-11 00:21:15
 * @FilePath: \my-database-project\src\plugins\http.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import Vue from 'vue'
import http from '@/api/http'

//标准的 Vue 插件 方式，将一个 API 客户端 注入到 Vue 的所有组件中
const install = function (Vue) {
  if (install.installed) return
  install.installed = true
  Object.defineProperties(Vue.prototype, {
    $api: {
      get () {
        return http
      },
      enumerable: false, // 不可枚举
      configurable: false // 不可重写
    }
  })
}

//通过this.$api访问被封装的http模块
Vue.use(install)