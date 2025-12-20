/*
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-16 00:47:26
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-19 00:44:23
 * @Description: Vuex Store 配置
 */
import Vue from 'vue'
import Vuex from 'vuex'
import store from 'store'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    // 建议默认值为 null，方便做布尔值判断
    userInfo: store.get('userInfo') || null,
    // 确保默认是数组，方便使用 push
    checkHomework: store.get('checkHomework') || [],
    token: store.get('token') || null
  },
  getters: {
    userInfo(state) {
      return state.userInfo
    },
    // 是否登录
    isLoggedIn(state) {
      return !!state.userInfo
    },
    // 获取角色
    userRole(state) {
      return state.userInfo ? state.userInfo.role : 'student'
    },
    // 获取已完成作业列表
    checkHomework(state) {
      return state.checkHomework
    }
  },
  mutations: {
    SET_USERINFO(state, userInfo) {
      state.userInfo = userInfo
      store.set('userInfo', userInfo)

      // 同步更新 token
      if (userInfo && userInfo.token) {
        state.token = userInfo.token
        store.set('token', userInfo.token)
      }
    },
    SET_CHECKHOMEWORK(state, homeworkList) {
      state.checkHomework = homeworkList
      store.set('checkHomework', homeworkList)
    },
    ADD_CHECKHOMEWORK(state, id) {
      // 确保 id 不存在才添加
      if (!state.checkHomework.includes(id)) {
        state.checkHomework.push(id)
        store.set('checkHomework', state.checkHomework)
      }
    },
    REMOVE_CHECKHOMEWORK(state, id) {
      const index = state.checkHomework.indexOf(id)
      if (index !== -1) {
        state.checkHomework.splice(index, 1)
        store.set('checkHomework', state.checkHomework)
      }
    },
    CLEAR_USERINFO(state) {
      state.userInfo = null
      store.remove('userInfo')
    },
    CLEAR_CHECKHOMEWORK(state) {
      state.checkHomework = [] // 恢复为空数组
      store.remove('checkHomework')
    },
    CLEAR_TOKEN(state) {
      state.token = null
      store.remove('token')
    }
  },
  actions: {
    // 登录
    async login({ commit }, userInfo) {
      commit('SET_USERINFO', userInfo)
    },
    // 退出
    async logout({ commit }) {
      commit('CLEAR_USERINFO')
      commit('CLEAR_CHECKHOMEWORK')
      commit('CLEAR_TOKEN')
    },
    // 新增：完成作业
    completeHomework({ commit }, id) {
      commit('ADD_CHECKHOMEWORK', id)
    },
    // 新增：撤销完成作业 
    undoHomework({ commit }, id) {
      commit('REMOVE_CHECKHOMEWORK', id)
    }
  }
})