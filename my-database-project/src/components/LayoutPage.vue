<!--
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 20:23:58
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-12 13:18:35
 * @FilePath: \my-database-project\src\components\LayoutPage.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
<template>
  <div class="app-wrapper">
    <el-container style="height: 100vh;">
      
      <el-aside :width="isCollapse ? '64px' : '220px'" class="sidebar-container">
        <SideMenu :is-collapse="isCollapse" />
      </el-aside>

      <el-container>
        <el-header class="app-header-container">
          <AppHeader 
            :is-collapse="isCollapse" 
            :page-title="$route.name" 
            @toggle-collapse="isCollapse = !isCollapse"
          />
        </el-header>

        <el-main style="background-color: #f0f2f5; padding: 20px;">
          <transition name="el-fade-in-linear" mode="out-in">
            <router-view></router-view>
          </transition>
        </el-main>
      </el-container>

    </el-container>
  </div>
</template>

<script>
import SideMenu from './SideMenu.vue';
import AppHeader from './AppHeader.vue';

export default {
  name: 'LayoutPage',
  components: {
    SideMenu,
    AppHeader
  },
  data() {
    return {
      isCollapse: false
    };
  }
};
</script>

<style scoped>
.sidebar-container {
  background-color: #304156;
  transition: width 0.28s;
  overflow-x: hidden;
}
.app-header-container {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);
  padding: 0 20px;
}
</style>