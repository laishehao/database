/*
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-16 00:47:26
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 16:18:08
 * @Description: Vuex Store 配置
 */
import Vue from 'vue'
import Vuex from 'vuex'
import store from 'store'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: store.get('userInfo') || null,
    checkHomework: store.get('checkHomework') || null,
    token: store.get('token') || null
  },
  getters: {
    userInfo(state) {
      return state.userInfo
    },
    //是否登录
    isLoggedIn(state) {
      return !!state.userInfo
    },
    //获取角色
    userRole(state) {
      return state.userInfo ? state.userInfo.role : 'student'
    }
  },
  mutations: {
    // 设置个人信息userInfo
    SET_USERINFO(state, userInfo) {
      state.userInfo = userInfo
      store.set('userInfo', userInfo)

      // 如果 userInfo 中包含 token，同步更新 token 状态
      if (userInfo && userInfo.token) {
        state.token = userInfo.token
        store.set('token', userInfo.token)
      }
    },
    //清除userInfo
    CLEAR_USERINFO(state) {
      state.userInfo = null
      store.remove('userInfo')
    },
    CLEAR_CHECKHOMEWORK(state) {
      state.checkHomework = null
      store.remove('checkHomework')
    },
    CLEAR_TOKEN(state) {
      state.token = null
      store.remove('token')
    }
  },
  actions: {
    // 登录 Action
    // 在组件里调用: this.$store.dispatch('login', userInfo)
    async login({ commit }, userInfo) {
      // 直接提交数据给 mutation
      commit('SET_USERINFO', userInfo)
    },
    // 退出 Action
    // 在组件里调用: this.$store.dispatch('logout')
    async logout({ commit }) {
      commit('CLEAR_USERINFO')
      commit('CLEAR_CHECKHOMEWORK')
      commit('CLEAR_TOKEN')
    }
  }
})