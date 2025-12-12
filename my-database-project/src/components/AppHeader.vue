<template>
  <div class="header-wrapper">
    <div class="toggle-btn" @click="$emit('toggle-collapse')">
      <i :class="isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold'"></i>
    </div>

    <el-breadcrumb separator="/" style="margin-left: 20px;">
      <el-breadcrumb-item>首页</el-breadcrumb-item>
      <el-breadcrumb-item>{{ pageTitle }}</el-breadcrumb-item>
    </el-breadcrumb>

    <div class="header-right">
      
      <template v-if="userInfo">
        <div class="user-avatar-box">
          <el-avatar size="small" :src="userInfo.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"></el-avatar>
          
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link" style="cursor: pointer; margin-left: 8px;">
              {{ userInfo.name || userInfo.username || 'User' }} <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </template>

      <div v-else class="auth-buttons">
        <el-button type="text" @click="openAuth('login')">登录</el-button>
        <el-divider direction="vertical"></el-divider>
        <el-button type="primary" size="mini" round @click="openAuth('register')">注册账号</el-button>
      </div>

    </div>

    <auth-modal 
      :visible.sync="authVisible" 
      :initial-mode="authMode"
      @success="handleAuthSuccess"
    ></auth-modal>

  </div>
</template>

<script>
import AuthModal from '@/components/AuthModal.vue'; 

export default {
  name: 'AppHeader',
  components: { AuthModal }, // 注册组件
  props: {
    isCollapse: Boolean,
    pageTitle: String
  },
  data() {
    return {
      userInfo: null,
      authVisible: false, // 控制弹窗
      authMode: 'login'   // 初始模式
    };
  },
  methods: {
    handleCommand(command) {
      if (command === 'logout') {
        this.handleLogout();
      } else if (command === 'profile') {
        this.$router.push('/profile');
      }
    },
    handleLogout() {
      this.$confirm('确认退出登录吗?', '提示', { type: 'warning' }).then(() => {
        this.userInfo = null;
        localStorage.removeItem('userInfo');
        localStorage.removeItem('token'); // 同时也清除 Token
        this.$message.success('退出成功');
        // 如果退出后需要跳转到特定页面，可以在这里写
        // this.$router.push('/login'); // 现在是弹窗模式，其实不一定要跳走，留在当前页变回未登录状态也可
      });
    },
  
    openAuth(mode) {
      this.authMode = mode;
      this.authVisible = true;
    },

    // 登录/注册成功回调
    handleAuthSuccess(user) {
      this.userInfo = user;
      localStorage.setItem('userInfo', JSON.stringify(user));
      
      // 如果后端返回了 token 且之前 http.js 没有自动处理，这里需要手动存
      // localStorage.setItem('token', user.token);
    }
  },
  created() {
    // 初始化时从本地缓存恢复登录状态
    const userStr = localStorage.getItem('userInfo');
    if (userStr) {
      try {
        this.userInfo = JSON.parse(userStr);
      } catch (e) {
        console.error('解析用户信息失败', e);
        localStorage.removeItem('userInfo');
      }
    }
  }
};
</script>

<style scoped>
.header-wrapper {
  height: 100%;
  display: flex;
  align-items: center;
  padding: 0 20px;
}
.toggle-btn { font-size: 24px; cursor: pointer; margin-right: 10px; }
.toggle-btn:hover { color: #409EFF; }
.header-right { margin-left: auto; }
.user-avatar-box { display: flex; align-items: center; }
.auth-buttons { display: flex; align-items: center; }
</style>