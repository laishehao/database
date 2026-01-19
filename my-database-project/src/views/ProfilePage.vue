<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 00:57:59
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2026-01-19 11:53:20
 * @Description: 个人信息页
-->
<template>
  <div class="profile-container">
    <!-- 如果已登录显示内容 -->
    <el-card shadow="never" class="profile-card" v-if="userInfo">
      <div slot="header" class="clearfix card-header">
        <span>👤 个人中心</span>
        <div class="header-decoration"></div>
      </div>

      <el-row :gutter="40" type="flex" align="middle" style="flex-wrap: wrap">
        <!-- 左侧：头像和身份概览 -->
        <el-col :xs="24" :sm="8" class="profile-left">
          <div class="avatar-container">
            <div class="avatar-wrapper">
              <el-upload
                class="avatar-uploader"
                :action="uploadUrl"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
                name="file"
              >
                <el-avatar
                  :size="130"
                  :src="
                    userAvatar ||
                    'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
                  "
                  fit="cover"
                ></el-avatar>
                <div class="upload-overlay">
                  <i class="el-icon-camera-solid"></i>
                  <span style="font-size: 14px; margin-top: 5px">更换头像</span>
                </div>
              </el-upload>
            </div>
            <!-- 装饰性光晕 -->
            <div class="avatar-halo"></div>
          </div>

          <h2 class="user-name">{{ userInfo.name || userInfo.username }}</h2>

          <div class="user-role-badge">
            <i
              :class="
                userInfo.role === 'teacher'
                  ? 'el-icon-s-custom'
                  : 'el-icon-user'
              "
            ></i>
            <span>{{ userInfo.role === "teacher" ? "教 师" : "学 生" }}</span>
          </div>

          <div class="last-login">
            <i class="el-icon-time"></i> 上次登录：{{ lastLoginTime }}
          </div>
        </el-col>

        <!-- 右侧：详细资料列表 -->
        <el-col :xs="24" :sm="16" class="profile-right">
          <el-descriptions
            class="custom-descriptions"
            :column="1"
            border
            size="medium"
          >
            <el-descriptions-item>
              <template slot="label"
                ><i class="el-icon-postcard"></i> 真实姓名</template
              >
              {{ userInfo.name || "未设置" }}
            </el-descriptions-item>

            <el-descriptions-item>
              <template slot="label"
                ><i class="el-icon-message"></i> 联系邮箱</template
              >
              {{ userInfo.email || "未绑定" }}
            </el-descriptions-item>

            <el-descriptions-item>
              <template slot="label"
                ><i class="el-icon-mobile-phone"></i> 联系电话</template
              >
              {{ userInfo.phone || "未绑定" }}
            </el-descriptions-item>

            <!-- 针对学生角色的额外展示 -->
            <template v-if="userInfo.role === 'student'">
              <el-descriptions-item>
                <template slot="label"
                  ><i class="el-icon-school"></i> 学号</template
                >
                {{ userInfo.studentId || userInfo.id }}
              </el-descriptions-item>
              <el-descriptions-item>
                <template slot="label"
                  ><i class="el-icon-reading"></i> 所属专业</template
                >
                {{ userInfo.major || "计算机科学与技术" }}
              </el-descriptions-item>
            </template>
          </el-descriptions>

          <div class="action-buttons">
            <el-button
              type="primary"
              icon="el-icon-edit"
              class="pink-btn"
              @click="modalVisible = true"
              >编辑资料</el-button
            >
            <el-button
              type="danger"
              icon="el-icon-switch-button"
              class="glass-btn"
              plain
              @click="handleLogout"
              >退出登录</el-button
            >
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 未登录状态占位 -->
    <el-empty v-else description="您尚未登录，无法查看个人信息">
      <el-button type="primary" class="pink-btn" @click="$router.push('/index')"
        >返回首页</el-button
      >
    </el-empty>

    <!-- 挂载新提取的组件 -->
    <profile-edit-modal
      :visible.sync="modalVisible"
      :user-info="userInfo"
      @success="onEditSuccess"
    ></profile-edit-modal>
  </div>
</template>

<script>
import { mapGetters, mapState } from "vuex";
import ProfileEditModal from "@/components/modals/ProfileModal.vue";

export default {
  name: "ProfilePage",
  components: {
    ProfileEditModal,
  },
  data() {
    return {
      lastLoginTime: new Date().toLocaleString(),
      modalVisible: false,
    };
  },
  computed: {
    ...mapGetters(["userInfo"]),
    ...mapState(["token"]),
    uploadUrl() {
      return process.env.VUE_APP_USER_UPLOAD_PATH;
    },
    headers() {
      return {
        Authorization: `Bearer ${this.token}`,
      };
    },
    userAvatar() {
      const avatar = this.userInfo.avatar;
      if (!avatar)
        return "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png";

      return avatar.includes("http")
        ? avatar
        : process.env.VUE_APP_BASE_URL + avatar;
    },
  },
  methods: {
    // 头像上传成功
    handleAvatarSuccess(res) {
      if (res.code === 200 || res.errno === 0 || res.success) {
        // 获取图片地址：优先尝试 res.data.url，如果 res.data 本身就是字符串则直接用
        const imageUrl = res.data && res.data.url ? res.data.url : res.data;
        const updatedUser = {
          ...this.userInfo,
          avatar: imageUrl,
        };
        // 触发 Vuex 更新同步到全站
        this.$store.dispatch("login", updatedUser);
        this.$message.success("头像上传成功");
      } else {
        this.$message.error(res.msg || "上传失败, 请重试");
      }
    },
    // 上传前校验
    beforeAvatarUpload(file) {
      const isJPGOrPNG =
        file.type === "image/jpeg" || file.type === "image/png";
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPGOrPNG) {
        this.$message.error("上传头像图片只能是 JPG/PNG 格式!");
      }
      if (!isLt2M) {
        this.$message.error("上传头像图片大小不能超过 2MB!");
      }
      return isJPGOrPNG && isLt2M;
    },
    //个人信息编辑成功的回调函数
    onEditSuccess(updatedUser) {
      this.$store.dispatch("login", updatedUser);
    },
    //退出账号
    handleLogout() {
      this.$confirm("确认退出当前账号吗?", "提示", {
        confirmButtonText: "狠心退出",
        cancelButtonText: "再留一会",
        type: "warning",
      })
        .then(() => {
          this.$store.dispatch("logout");
          this.$router.push("/index");
          this.$message.success("已退出登录");
        })
        .catch(() => {});
    },
  },
};
</script>

<style scoped>
/* 引入可爱字体 */
@import url("https://fonts.font.im/css2?family=ZCOOL+KuaiLe&display=swap");

.profile-container {
  padding: 20px;
  /* 给整个页面加一个极淡的粉色渐变背景，增加氛围感 */
  background: linear-gradient(135deg, #fff0f5 0%, #ffffff 100%);
  min-height: 85vh; /* 撑开高度 */
}

/* --- 卡片立体化设计 --- */
.profile-card {
  max-width: 900px;
  margin: 20px auto;
  border: none;
  border-radius: 20px; /* 大圆角 */
  /* 核心：多层阴影营造悬浮感 */
  box-shadow: 0 10px 30px rgba(255, 182, 193, 0.2),
    /* 粉色光晕 */ 0 5px 15px rgba(0, 0, 0, 0.05); /* 基础阴影 */
  background: rgba(255, 255, 255, 0.9); /* 微微半透明 */
  backdrop-filter: blur(10px); /* 磨砂玻璃效果 */
  position: relative;
  overflow: visible; /* 允许头像光晕溢出 */
}

/* 卡片头部 */
.card-header {
  font-family: "ZCOOL KuaiLe", cursive, sans-serif;
  font-size: 22px;
  color: #ff69b4;
  position: relative;
  padding-left: 10px;
}
.card-header::before {
  content: "";
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 20px;
  background: #ff69b4;
  border-radius: 4px;
}

/* --- 左侧区域：立体头像 --- */
.profile-left {
  text-align: center;
  position: relative;
  padding: 30px 0;
}

.avatar-container {
  position: relative;
  display: inline-block;
  margin-bottom: 20px;
}

.avatar-wrapper {
  position: relative;
  z-index: 2;
  border-radius: 50%;
  padding: 5px;
  background: #fff;
  /* 头像立体边框 */
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  cursor: pointer;
  overflow: hidden;
}

.avatar-wrapper:hover {
  transform: scale(1.05) rotate(3deg);
}

.avatar-wrapper:hover .upload-overlay {
  opacity: 1;
}

.avatar-uploader .el-upload {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}

.upload-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: #fff;
  font-size: 24px;
  opacity: 0;
  transition: opacity 0.3s;
  border-radius: 50%;
  z-index: 10;
}

.avatar-halo {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 140px;
  height: 140px;
  transform: translate(-50%, -50%);
  background: radial-gradient(
    circle,
    rgba(255, 105, 180, 0.2) 0%,
    rgba(255, 255, 255, 0) 70%
  );
  border-radius: 50%;
  z-index: 1;
  animation: pulse 3s infinite;
}

@keyframes pulse {
  0% {
    transform: translate(-50%, -50%) scale(0.95);
    opacity: 0.7;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.1);
    opacity: 1;
  }
  100% {
    transform: translate(-50%, -50%) scale(0.95);
    opacity: 0.7;
  }
}

.user-name {
  font-family: "ZCOOL KuaiLe", cursive, sans-serif;
  font-size: 28px;
  color: #303133;
  margin-bottom: 15px;
  letter-spacing: 1px;
}

.user-role-badge {
  display: inline-block;
  background: linear-gradient(45deg, #ff9a9e, #fad0c4);
  color: white;
  padding: 6px 20px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: bold;
  box-shadow: 0 4px 10px rgba(255, 154, 158, 0.4);
  margin-bottom: 30px;
}

.last-login {
  color: #909399;
  font-size: 13px;
  background: #f8f9fa;
  padding: 8px 15px;
  border-radius: 6px;
  display: inline-block;
}

/* --- 右侧区域：表格与按钮 --- */
.profile-right {
  padding: 20px;
}

/* 修改 Element Descriptions 样式 (深度选择器) */
::v-deep .custom-descriptions {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  border-radius: 8px;
  overflow: hidden;
}

::v-deep .custom-descriptions .el-descriptions__header {
  margin-bottom: 15px;
}

::v-deep .custom-descriptions .el-descriptions-item__label {
  background: #fff0f5 !important; /* 淡粉色表头 */
  color: #606266;
  font-weight: bold;
  width: 120px;
}

::v-deep .custom-descriptions .el-descriptions-item__content {
  background: #fff !important;
  color: #333;
}

/* 按钮样式优化 */
.action-buttons {
  margin-top: 40px;
  text-align: right;
}

.pink-btn {
  background: linear-gradient(90deg, #ff9a9e 0%, #ff69b4 100%);
  border: none;
  box-shadow: 0 4px 10px rgba(255, 105, 180, 0.3);
  padding: 12px 25px;
  transition: all 0.3s;
}

.pink-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(255, 105, 180, 0.4);
}

.glass-btn {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid #ffcccc;
  color: #ff69b4;
}

.glass-btn:hover {
  background: #fff0f5;
  color: #ff1493;
  border-color: #ff69b4;
}
</style>