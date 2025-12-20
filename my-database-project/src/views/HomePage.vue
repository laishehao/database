<template>
  <div class="app-wrapper">
    <el-container style="height: 100vh">
      <!-- 侧边栏 -->
      <el-aside
        :width="isCollapse ? '64px' : '220px'"
        class="sidebar-container">
        <SideMenu :is-collapse="isCollapse" />
      </el-aside>

      <!-- 主内容区 -->
      <el-container>
        <el-header class="app-header-container">
          <AppHeader
            :is-collapse="isCollapse"
            :page-path="$route.name"
            @toggle-collapse="isCollapse = !isCollapse"
          />
        </el-header>

        <el-main class="main-content">
          <transition name="el-fade-in-linear" mode="out-in">
            <router-view></router-view>
          </transition>
        </el-main>
      </el-container>
    </el-container>

    <!-- 🐟 Sakana 组件 (左下角) -->
    <div id="sakana-container" class="sakana-box" v-show="!isCollapse"></div>

    <!-- 🎵 新增：音乐悬浮球组件 (右下角) -->
    <MusicPlayer />

  </div>
</template>

<script>
import SideMenu from '@/components/layout/SideMenu.vue';
import AppHeader from '@/components/layout/AppHeader.vue';
import MusicPlayer from '@/components/features/MusicPlayer.vue';

import Sakana from 'sakana';

export default {
  name: 'HomePage',
  components: {
    SideMenu,
    AppHeader,
    // 2. 注册组件
    MusicPlayer
  },
  data() {
    return {
      isCollapse: false
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
        const container = document.getElementById('sakana-container');
        if (container) container.innerHTML = '';

        Sakana.init({
          el: '#sakana-container', 
          scale: 0.5,
          canSwitchCharacter: true,
        });
      } catch (error) {
        console.error('Sakana 组件初始化失败:', error);
      }
    }
  }
};
</script>

<style scoped>
.sidebar-container {
  background-color: #304156;
  transition: width 0.28s;
  overflow-x: hidden;
  position: relative;
  z-index: 10;
}

.app-header-container {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 20px;
  position: relative;
  z-index: 9;
}

.main-content {
  padding: 20px;
  background-image: linear-gradient(rgba(255, 240, 245, 0.9), rgba(255, 240, 245, 0.9)), url('~@/assets/img/profile/bg.png');
  background-size: cover; /* 建议改为 cover 以适应不同屏幕 */
  background-position: center;
  background-attachment: fixed;
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