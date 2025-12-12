<!--
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 20:24:26
 * @LastEditors: Garyonit 3253975221@qq.com
 * @LastEditTime: 2025-12-07 20:57:42
 * @FilePath: \my-database-project\src\components\SideMenu.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
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
      <el-menu-item index='/index'>
        <i class="el-icon-s-home"></i>
        <span slot="title">首页</span>
      </el-menu-item>
      <el-menu-item index="/homework">
        <i class="el-icon-notebook-1"></i>
        <span slot="title">作业管理</span>
      </el-menu-item>
      <el-menu-item index="/student">
        <i class="el-icon-user"></i>
        <span slot="title">学生管理</span>
      </el-menu-item>
      <el-menu-item index="/course">
        <i class="el-icon-reading"></i>
        <span slot="title">课程管理</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script>
export default {
  name: "SideMenu",
  props: {
    isCollapse: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<style scoped>
/* 样式保持不变 */
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
}
.logo-area img {
  width: 30px;
  margin-right: 10px;
}
.logo-area.collapsed img {
  margin-right: 0;
}
.el-menu-vertical:not(.el-menu--collapse) {
  width: 220px;
  min-height: 400px;
}
</style>