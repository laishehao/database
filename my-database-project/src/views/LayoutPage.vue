<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-07 20:23:58
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-17 01:07:58
 * @FilePath: \my-database-project\src\components\LayoutPage.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
<template>
  <div class="app-wrapper">
    <el-container style="height: 100vh">
      <!-- 侧边栏 -->
      <el-aside
        :width="isCollapse ? '64px' : '220px'"
        class="sidebar-container"
      >
        <SideMenu :is-collapse="isCollapse" />
      </el-aside>

      <!-- 主内容区 -->
      <el-container>
        <el-header class="app-header-container">
          <AppHeader
            :is-collapse="isCollapse"
            :page-title="$route.name"
            @toggle-collapse="isCollapse = !isCollapse"
          />
        </el-header>

        <el-main style="background-color: #f0f2f5; padding: 20px">
          <transition name="el-fade-in-linear" mode="out-in">
            <router-view></router-view>
          </transition>
        </el-main>
      </el-container>
    </el-container>

    <div class="sakana-box"></div>
  </div>
</template>

<script>
import SideMenu from "../components/SideMenu.vue";
import AppHeader from "../components/AppHeader.vue";
import Sakana from "sakana";

export default {
  name: "LayoutPage",
  components: {
    SideMenu,
    AppHeader,
  },
  data() {
    return {
      isCollapse: false,
    };
  },
  mounted() {
    this.$nextTick(() => {
      this.initSakana();
    });
  },
  methods: {
    initSakana() {
      try {
        const container = document.getElementsByClassName("sakana-box");
        if (container) container.innerHTML = "";

        Sakana.init({
          el: ".sakana-box", // 启动元素 node 或 选择器
          scale: 0.5, // 缩放倍数
          canSwitchCharacter: true, // 允许换角色
        });
      } catch (error) {
        console.error("Sakana 组件初始化失败:", error);
      }
    },
  },
};
</script>

<style scoped>
.sidebar-container {
  background-color: #304156;
  transition: width 0.28s;
  overflow-x: hidden;
  position: relative;
  z-index: 10; /* 确保侧边栏在底层 */
}

.app-header-container {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 20px;
  position: relative;
  z-index: 9;
}

.sakana-box {
  width: 500px;
  height: 500px;
  position: fixed;
  bottom: 0;
  left: -130px;
  z-index: 20;
}
</style>