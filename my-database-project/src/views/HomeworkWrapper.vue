<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 01:04:18
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 20:53:05
 * @Description: 自动根据角色分发的作业容器
-->
<template>
  <component :is="activeComponent" />
</template>

<script>
import HomeworkList from './HomeworkList.vue';
import HomeworkCheckList from './HomeworkCheckList.vue';
import { mapGetters } from 'vuex'; // 1. 引入 Vuex 辅助函数

export default {
  name: 'HomeworkWrapper',
  components: {
    HomeworkList,
    HomeworkCheckList
  },
  computed: {
    // 当 store 中的 userInfo 变化时，userRole 会自动更新
    ...mapGetters(['userRole']),

    activeComponent() {
      // 直接根据响应式的 userRole 判断
      return this.userRole === 'teacher' ? 'HomeworkList' : 'HomeworkCheckList';
    }
  }
  // 移除了 data, created, methods 等手动监听代码，Vuex 会全自动处理
};
</script>