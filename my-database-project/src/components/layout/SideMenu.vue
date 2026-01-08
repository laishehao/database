<template>
  <div class="sidebar-wrapper">
    <!-- Logo 区域：背景改为淡粉色 -->
    <div class="logo-area" :class="{ collapsed: isCollapse }">
      <img :src="require('@/assets/img/logo.png')" alt="logo" />
      <span v-show="!isCollapse">教务系统</span>
    </div>

    <!-- 绑定collapse就能控制菜单的伸缩 -->
    <el-menu
      :default-active="$route.path"
      router      
      background-color="transparent"
      text-color="#606266"
      active-text-color="#ff69b4"
      :collapse="isCollapse"
      class="el-menu-vertical"
      style="border-right: none"
    >
      <!-- 1. 首页：所有人可见 -->
      <el-menu-item index="/index">
        <i class="el-icon-s-home"></i>
        <span slot="title">首页</span>
      </el-menu-item>

      <!-- 2. 作业：登录后可见 -->
      <el-menu-item index="/homework" v-if="isLoggedIn">
        <i class="el-icon-notebook-1"></i>
        <span slot="title">{{ userRole === 'student' ? '作业查看' : '作业管理' }}</span>
      </el-menu-item>

      <!-- 3. 学生管理：仅老师可见 -->
      <!-- <el-menu-item index="/student" v-if="userRole === 'teacher'">
        <i class="el-icon-user"></i>
        <span slot="title">学生管理</span>
      </el-menu-item> -->

      <!-- 4. 课程管理：仅老师可见 -->
      <el-menu-item index="/course" v-if="userRole === 'teacher'">
        <i class="el-icon-reading"></i>
        <span slot="title">课程管理</span>
      </el-menu-item>

    </el-menu>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  name: "SideMenu",
  props: {
    //伸展/收缩侧边菜单
    isCollapse: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    // 当 store 数据变化时，这里的 userRole 和 isLoggedIn 会自动更新
    ...mapGetters(['userRole', 'isLoggedIn'])
  },
};
</script>

<style scoped>
.sidebar-wrapper {
  display: flex;
  flex-direction: column;
  height: 100%;
  
  /* 修改点：添加背景图和同色调蒙版 */
  /* 蒙版颜色采用淡粉色 #fff0f5 的 RGBA 值 (255, 240, 245)，透明度 0.9 以确保文字清晰 */
  background-image: linear-gradient(rgba(255, 240, 245, 0.9), rgba(255, 240, 245, 0.9)), url('~@/assets/img/sideMenu/side_bg.png');
  background-size: cover;
  background-position: center center; /* 垂直水平居中 */
  background-repeat: no-repeat;
  
  transition: width 0.28s;
  /* 添加右侧阴影，增加立体感 */
  box-shadow: 2px 0 6px rgba(0, 21, 41, 0.05);
  z-index: 10;
}

.logo-area {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  /* Logo 区域保持半透明背景，或者稍微深一点的粉色以区分 */
  background-color: rgba(255, 238, 245, 0.95); 
  color: #ff69b4; /* 深粉色文字 */
  font-weight: bold;
  font-size: 16px;
  overflow: hidden;
  flex-shrink: 0;
  border-bottom: 1px solid rgba(252, 228, 236, 0.8); /* 边框也调为半透明粉色系 */
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

/* 隐藏滚动条 */
.el-menu-vertical::-webkit-scrollbar {
  width: 0;
}

.el-menu-vertical:not(.el-menu--collapse) {
  width: 220px;
}

/* --- 自定义菜单项交互样式 --- */

/* 鼠标悬停时的背景色 - 加深一点粉色 */
::v-deep .el-menu-item:hover {
  background-color: rgba(255, 230, 240, 0.8) !important; /* 使用 RGBA 保持通透感 */
  color: #ff69b4 !important;
}

/* 选中项的样式 */
::v-deep .el-menu-item.is-active {
  background-color: rgba(255, 222, 235, 0.9) !important; /* 选中时背景更明显 */
  border-right: 3px solid #ff69b4; /* 右侧粉色高亮条 */
  font-weight: 600;
}

/* 修正图标颜色 (未选中时淡灰，选中时粉色) */
::v-deep .el-menu-item i {
  color: #909399;
}
::v-deep .el-menu-item.is-active i,
::v-deep .el-menu-item:hover i {
  color: #ff69b4;
}
</style>