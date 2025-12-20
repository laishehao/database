<template>
  <div class="header-wrapper">
    <!-- 折叠按钮 -->
    <div class="toggle-btn" @click="$emit('toggle-collapse')">
      <i :class="isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold'"></i>
    </div>

    <!-- 面包屑 -->
    <el-breadcrumb separator="/" style="margin-left: 20px;" class="custom-breadcrumb">
      <el-breadcrumb-item>首页</el-breadcrumb-item>
      <el-breadcrumb-item>{{ pageTitle }}</el-breadcrumb-item>
    </el-breadcrumb>

    <div class="header-right">
      <!-- 已登录 -->
      <template v-if="userInfo">
        <div class="user-avatar-box">
          <el-avatar size="small" :src="userInfo.avatar || require('@/assets/img/z4kr.png')"></el-avatar>
          <!-- 下拉菜单 -->
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link" style="cursor: pointer; margin-left: 8px;">
              {{ userInfo.name || userInfo.username || 'User' }} <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <!-- 修改点：添加自定义类名 pink-dropdown-menu -->
            <el-dropdown-menu slot="dropdown" class="pink-dropdown-menu">
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </template>
      <!-- 未登录 -->
      <div v-else class="auth-buttons">
        <el-button type="text" @click="openAuth('login')">登录</el-button>
        <el-divider direction="vertical"></el-divider>
        <el-button type="primary" size="mini" round @click="openAuth('register')">注册账号</el-button>
      </div>
    </div>

    <!-- 注册/登录窗口 -->
    <AuthModal 
      :visible.sync="authVisible" 
      :initial-mode="authMode"
      @success="handleAuthSuccess"
    ></AuthModal>
  </div>
</template>

<script>
import AuthModal from '@/components/modals/AuthModal.vue'; 
import { mapGetters } from 'vuex'

const pathConfig = {
  'home': '主页',
  'student': '学生列表',
  'course': '课程列表',
  'homework': '作业列表',
  'profile': '个人中心',
  'homeworkDetail': '作业详情'
}

export default {
  name: 'AppHeader',
  components: { AuthModal },
  props: {
    isCollapse: Boolean,
    pagePath: String
  },
  data() {
    return {
      authVisible: false,
      authMode: 'login'
    };
  },
  computed: {
    // 面包屑的标题
    pageTitle() {
      return pathConfig[this.pagePath] || '当前页面'
    },
    ...mapGetters(['userInfo'])
  },
  methods: {
    handleCommand(command) {
      if (command === 'logout') {
        this.handleLogout();
      } 
      else if (command === 'profile') {
        if(this.$route.path !== '/profile'){
          this.$router.push('/profile')
        }
      }
    },
    handleLogout() {
      this.$confirm('确认退出登录吗?', '提示', { 
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning' 
      }).then(() => {
        this.$store.dispatch('logout')
        this.$message.success('退出成功');
        
        if (this.$route.path !== '/index') {
            this.$router.push('/index');
        }
      }).catch((err) => {
        if (err !== 'cancel') console.error(err)
      });
    },
    openAuth(mode) {
      this.authMode = mode;
      this.authVisible = true;
    },

    // 登录/注册成功回调
    handleAuthSuccess(user) {
      console.log('用户已登录:', `user-${user.phone}`);
    }
  }
};
</script>

<style>
/* --- 全局样式覆盖 (用于处理 append-to-body 的下拉菜单) --- */
.pink-dropdown-menu .el-dropdown-menu__item:not(.is-disabled):hover,
.pink-dropdown-menu .el-dropdown-menu__item:focus {
  background-color: #ffe6f0 !important; /* 浅粉色背景 */
  color: #ff69b4 !important; /* 粉色文字 */
}
</style>

<style scoped>
/* --- 局部组件样式 --- */
/* 1. 引入在线字体：站酷快乐体 (ZCOOL KuaiLe) */
@import url('https://fonts.font.im/css2?family=ZCOOL+KuaiLe&display=swap');

/* --- 局部组件样式 --- */
.header-wrapper {
  height: 100%;
  display: flex;
  align-items: center;
  padding: 0 20px;
  /* 基础背景色：白色 */
  background-color: #ffffff;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%23ffe6f0' fill-opacity='1' d='M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,112C672,96,768,96,864,112C960,128,1056,160,1152,160C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z'%3E%3C/path%3E%3C/svg%3E");
  background-position: center bottom;

  /* 阴影颜色也微调为粉色系 */
  box-shadow: 0 2px 10px rgba(255, 105, 180, 0.15); 
}

/* 2. 定义面包屑的可爱字体样式 */
.custom-breadcrumb ::v-deep .el-breadcrumb__inner {
  font-family: 'ZCOOL KuaiLe', cursive, sans-serif; /* 应用新字体 */
  font-size: 18px; /* 这种字体通常需要大一点才清晰 */
  font-weight: normal; /* 快乐体自带粗细，通常不需要加粗 */
  color: #888; /* 默认颜色稍微浅一点 */
}

/* 3. 最后一项(当前页)的高亮样式 */
.custom-breadcrumb ::v-deep .el-breadcrumb__item:last-child .el-breadcrumb__inner {
  color: #ff69b4; /* 深粉色 */
  font-weight: normal; /* 保持字体特性 */
  text-shadow: 1px 1px 0px #fff; /* 增加一点描边感让文字更清楚 */
}

.toggle-btn { 
  font-size: 24px; 
  cursor: pointer; 
  margin-right: 10px; 
  color: #606266;
  transition: color 0.3s;
}

.toggle-btn:hover { 
  color: #ff69b4; /* 悬停变为粉色 */
}

/* 修改点：给 header-right 区域也加上可爱字体 */
.header-right { 
  margin-left: auto; 
  font-family: 'ZCOOL KuaiLe', cursive, sans-serif; 
}

.el-dropdown {
  font-size: 20px;
}

.user-avatar-box { 
  display: flex; 
  align-items: center; 
}

.auth-buttons { 
  display: flex; 
  align-items: center; 
}


/* 下拉菜单文字 */
.el-dropdown-link {
  transition: color 0.3s;
  font-weight: 500;
  color: #606266;
}
.el-dropdown-link:hover {
  color: #ff69b4; /* 悬停变为粉色 */
}

/* --- 按钮样式覆盖 (粉色主题) --- */

/* Primary 按钮 (注册账号) */
::v-deep .el-button--primary {
  background-color: #ff69b4;
  border-color: #ff69b4;
}
::v-deep .el-button--primary:hover,
::v-deep .el-button--primary:focus {
  background-color: #ff85c2; /* 稍浅的粉色 */
  border-color: #ff85c2;
}

/* Text 按钮 (登录) */
::v-deep .el-button--text {
  color: #606266;
}
::v-deep .el-button--text:hover {
  color: #ff69b4;
}
</style>