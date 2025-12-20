<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 01:04:18
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 20:53:05
 * @Description: 作业包装组件
-->
<template>
  <component :is="activeComponent" />
</template>

<script>
import HomeworkList from './HomeworkList.vue';
import HomeworkCheckList from './HomeworkCheckList.vue';
import { mapGetters } from 'vuex'; 

export default {
  name: 'HomeworkWrapper',
  components: {
    HomeworkList,
    HomeworkCheckList
  },
  computed: {
    ...mapGetters(['userRole']),
    //根据userInfo判断该渲染哪个组件
    activeComponent() {
      return this.userRole === 'teacher' ? 'HomeworkList' : 'HomeworkCheckList';
    }
  }
};
</script>