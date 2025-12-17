<template>
  <div class="profile-container">
    <!-- 如果已登录显示内容 -->
    <el-card shadow="never" class="profile-card" v-if="userInfo">
      <div slot="header" class="clearfix">
        <span>个人中心</span>
      </div>
      
      <el-row :gutter="40">
        <!-- 左侧：头像和身份概览 -->
        <el-col :span="8" class="profile-left">
          <div class="avatar-wrapper">
            <el-avatar 
              :size="120" 
              :src="userInfo.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"
            ></el-avatar>
          </div>
          <h2 class="user-name">{{ userInfo.name || userInfo.username }}</h2>
          <div class="user-role">
            <el-tag :type="userInfo.role === 'teacher' ? 'success' : 'primary'" effect="dark">
              {{ userInfo.role === 'teacher' ? '教 师' : '学 生' }}
            </el-tag>
          </div>
          <div class="last-login">
            <p>上次登录时间：{{ lastLoginTime }}</p>
          </div>
        </el-col>

        <!-- 右侧：详细资料列表 -->
        <el-col :span="16">
          <el-descriptions title="基本资料" :column="1" border size="medium">
            <el-descriptions-item label="用户账号">
              {{ userInfo.username }}
            </el-descriptions-item>
            
            <el-descriptions-item label="姓名">
              {{ userInfo.name || '未设置' }}
            </el-descriptions-item>

            <el-descriptions-item label="联系邮箱">
              {{ userInfo.email || '未绑定' }}
            </el-descriptions-item>

            <el-descriptions-item label="联系电话">
              {{ userInfo.phone || '未绑定' }}
            </el-descriptions-item>
            
            <!-- 针对学生角色的额外展示 -->
            <template v-if="userInfo.role === 'student'">
               <el-descriptions-item label="学号">
                {{ userInfo.studentId || userInfo.username }}
              </el-descriptions-item>
              <el-descriptions-item label="所属专业">
                {{ userInfo.major || '计算机科学与技术' }}
              </el-descriptions-item>
            </template>
          </el-descriptions>

          <div style="margin-top: 30px;">
            <el-button type="primary"  @click="dialogVisible = true">编辑资料</el-button>
            <el-button type="danger" plain @click="handleLogout">退出登录</el-button>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 未登录状态占位 -->
    <el-empty v-else description="您尚未登录，无法查看个人信息">
      <el-button type="primary" @click="$router.push('/index')">返回首页</el-button>
    </el-empty>

    <!-- 挂载新提取的组件 -->
    <profile-edit-modal 
      :visible.sync="dialogVisible" 
      :user-info="userInfo"
      @success="onEditSuccess"
    ></profile-edit-modal>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import ProfileEditModal from '@/components/ProfileModal.vue'; 

export default {
  name: 'ProfilePage',
  components: {
    ProfileEditModal // 2. 注册组件
  },
  data() {
    return {
      lastLoginTime: new Date().toLocaleString(),
      dialogVisible: false,
      // form 数据移到子组件了，这里不需要了
    };
  },
  computed: {
    ...mapGetters(['userInfo'])
  },
  methods: {
    // 3. 处理编辑成功的回调
    onEditSuccess(updatedUser) {
      // 调用 Vuex Action 更新本地状态和 LocalStorage
      // 这样页面上的信息会立即刷新
      this.$store.dispatch('login', updatedUser); 
    },
    handleLogout() {
      this.$confirm('确认退出当前账号吗?', '提示', { type: 'warning' }).then(() => {
        this.$store.dispatch('logout');
        this.$router.push('/index');
        this.$message.success('已退出登录');
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.profile-container {
  padding: 20px;
}
.profile-card {
  max-width: 900px;
  margin: 0 auto;
  min-height: 500px;
}
.profile-left {
  text-align: center;
  border-right: 1px solid #EBEEF5;
  padding-right: 20px;
  padding-top: 20px;
}
.avatar-wrapper {
  margin-bottom: 20px;
}
.user-name {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 10px;
}
.user-role {
  margin-bottom: 30px;
}
.last-login {
  color: #909399;
  font-size: 13px;
  margin-top: 40px;
}
</style>