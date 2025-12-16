<template>
  <div class="sidebar-wrapper">
    <div class="logo-area" :class="{ collapsed: isCollapse }">
      <img src="https://element.eleme.io/favicon.ico" alt="logo" />
      <span v-show="!isCollapse">教务系统</span>
    </div>

    <el-menu
      :default-active="$route.path"
      router
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
      :collapse="isCollapse"
      class="el-menu-vertical"
      style="border-right: none"
    >
      <!-- 1. 首页：所有人可见 -->
      <el-menu-item index="/index">
        <i class="el-icon-s-home"></i>
        <span slot="title">首页</span>
      </el-menu-item>

      <!-- 2. 作业：登录后可见 (学生显示查看，老师显示管理) -->
      <el-menu-item index="/homework" v-if="isLoggedIn">
        <i class="el-icon-notebook-1"></i>
        <span slot="title">{{ userRole === 'student' ? '查看作业' : '作业管理' }}</span>
      </el-menu-item>

      <!-- 3. 学生管理：仅老师可见 -->
      <el-menu-item index="/student" v-if="userRole === 'teacher'">
        <i class="el-icon-user"></i>
        <span slot="title">学生管理</span>
      </el-menu-item>

      <!-- 4. 课程管理：仅老师可见 -->
      <el-menu-item index="/course" v-if="userRole === 'teacher'">
        <i class="el-icon-reading"></i>
        <span slot="title">课程管理</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script>
// 1. 引入 Vuex 辅助函数
import { mapGetters } from 'vuex';

export default {
  name: "SideMenu",
  props: {
    isCollapse: {
      type: Boolean,
      default: false,
    },
  },
  // 2. 移除 data 中的 userInfo，改为 computed 获取 Vuex 状态
  computed: {
    // 使用 mapGetters 直接映射 store/index.js 中的 getters
    // 这样当 store 数据变化时，这里的 userRole 和 isLoggedIn 会自动更新
    ...mapGetters(['userRole', 'isLoggedIn'])
  },
  // 3. 移除了 created/mounted 中的事件监听逻辑，Vuex 会自动处理响应式
};
</script>

<style scoped>
/* 样式保持不变 */
.sidebar-wrapper {
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #304156;
  transition: width 0.28s;
}

.logo-area {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2b2f3a;
  color: white;
  font-weight: bold;
  font-size: 16px;
  overflow: hidden;
  flex-shrink: 0;
}

.logo-area img {
  width: 30px;
  margin-right: 10px;
}

.logo-area.collapsed img {
  margin-right: 0;
}

.el-menu-vertical {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.el-menu-vertical::-webkit-scrollbar {
  width: 0;
}

.el-menu-vertical:not(.el-menu--collapse) {
  width: 220px;
}
</style>