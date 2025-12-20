<template>
  <el-dialog 
    :title="title" 
    :visible.sync="modalVisible" 
    width="420px"
    :before-close="handleClose"
    :close-on-click-modal="false"
    append-to-body
    custom-class="glass-auth-modal"
  >
    <el-form :model="form" :rules="rules" ref="formRef" label-width="0px">
      <!-- 注册窗口可以选角色 -->
      <template v-if="mode === 'register'">
        <!-- role -->
        <el-form-item prop="role" style="text-align: center">
          <el-radio-group v-model="form.role" size="small" class="glass-radio-group">
            <el-radio label="student" border>我是学生</el-radio>
            <el-radio label="teacher" border>我是老师</el-radio>
          </el-radio-group>
        </el-form-item>
        <!-- 名字 -->
        <el-form-item prop="name">
          <el-input 
            v-model="form.name" 
            prefix-icon="el-icon-user" 
            placeholder="请输入您的昵称/姓名">
          </el-input>
        </el-form-item>
        <!-- 邮箱 -->
        <el-form-item prop="email">
          <el-input 
            v-model="form.email" 
            prefix-icon="el-icon-message" 
            placeholder="请输入电子邮箱">
          </el-input>
        </el-form-item>
      </template>
      <!-- 手机号 -->
      <el-form-item prop="phone">
        <el-input 
          v-model="form.phone" 
          prefix-icon="el-icon-phone" 
          placeholder="请输入手机号">
        </el-input>
      </el-form-item>
      <!-- 密码 -->
      <el-form-item prop="password">
        <el-input 
          v-model="form.password" 
          prefix-icon="el-icon-lock" 
          type="password" 
          placeholder="请输入密码 (8-12位,含大小写+数字)"
          show-password
          @keyup.enter.native="handleSubmit"
        ></el-input>
      </el-form-item>

    </el-form>
    <!-- 底部按钮栏 -->
    <div class="form-footer">
      <el-button type="primary" style="width: 100%;" :loading="loading" @click="handleSubmit" class="glass-button">
        {{ mode === 'login' ? '登 录' : '注 册' }}
      </el-button>
      
      <div class="switch-mode-text">
        <template v-if="mode === 'login'">
          没有账号？<span class="link" @click="switchMode('register')">去注册</span>
        </template>
        <template v-else>
          已有账号？<span class="link" @click="switchMode('login')">去登录</span>
        </template>
      </div>
    </div>
  </el-dialog>
</template>

<script>
// 正则定义
const REGEX_PASSWORD = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d!.#*?&]{8,12}$/;
const REGEX_PHONE = /^1[3-9]\d{9}$/;
const REGEX_EMAIL = /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;

const validatePassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入密码'));
  } else if (!REGEX_PASSWORD.test(value)) {
    callback(new Error('密码需8-12位，含大写、小写字母及数字'));
  } else {
    callback();
  }
};

export default {
  name: 'AuthModal',
  props: {
    visible: { type: Boolean, default: false },
    initialMode: { type: String, default: 'login' }
  },
  data() {
    return {
      mode: 'login',  //登录模式
      loading: false,   //加载状态
      form: {         //表单
        phone: '',
        password: '',
        name: '',
        email: '',
        role: 'student'
      },
      rules: {    //表单判断规则(要对应!)
        phone: [
          { required: true, message: '手机号不能为空', trigger: 'blur' },
          { pattern: REGEX_PHONE, message: '请输入合法的手机号', trigger: 'blur' }
        ],
        password: [
          { required: true, validator: validatePassword, trigger: 'blur' }
        ],
        name: [
          { required: true, message: '昵称不能为空', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '邮箱不能为空', trigger: 'blur' },
          { pattern: REGEX_EMAIL, message: '请输入正确的邮箱格式', trigger: 'blur' }
        ]
      }
    };
  },
  computed: {
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); } //自动向父组件传递关闭弹窗的事件
    },
    title() {
      return this.mode === 'login' ? '用户登录' : '注册新账号';
    }
  },
  watch: {
    visible(val) {
      if (val) {
        this.mode = this.initialMode;
        this.resetForm();
      }
    }
  },
  methods: {
    //关闭弹窗
    handleClose() {
      this.modalVisible = false;
    },
    //重置表单
    resetForm() {
      this.form = { phone: '', password: '', name: '', email: '', role: 'student' };
      this.$nextTick(() => {
        this.$refs.formRef && this.$refs.formRef.clearValidate();
      });
    },
    //切换登录/注册模式
    switchMode(targetMode) {
      this.mode = targetMode;
      this.resetForm()
    },
    //提交
    handleSubmit() {
      //通过this.$refs找到el-form
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;  //进入加载状态
          const apiType = this.mode;
          //发起api请求
          this.$api({ 
            apiType: apiType,
            data: this.form
          }).then(res => {
            this.$message.success(this.mode === 'login' ? '登录成功' : '注册成功');
            
            // 获取用户信息
            let userInfo = res.user || res;

            // 防御性检查：确保 userInfo 存在
            if (!userInfo) {
              throw new Error('获取用户信息失败');
            }

            // 数据补全
            if (this.mode === 'register' && !userInfo.role) {
              userInfo.role = this.form.role;
            }
            if (!userInfo.name) {
              userInfo.name = this.form.name || '佚名用户';
            }
            if (!userInfo.avatar) {
              userInfo.avatar = require('@/assets/img/z4kr.png');
            }

            // 登录时将userInfo存储到 Vuex Store
            this.$store.dispatch('login', userInfo);

            // 派发事件 (保留以兼容旧的 SideMenu 监听逻辑)
            const setItemEvent = new Event('setItemEvent');
            window.dispatchEvent(setItemEvent);

            // 通知父组件,关闭弹窗
            this.$emit('success', userInfo);
            this.handleClose();
          }).catch(err => {
            console.error(err);
          }).finally(() => {
            this.loading = false;
          });
        }
      });
    }
  }
};
</script>

<style scoped>
/* 局部样式，主要用于布局微调 */
.form-footer {
  margin-top: 25px;
}
.switch-mode-text {
  margin-top: 15px;
  text-align: right;
  font-size: 14px;
  color: #555;
  text-shadow: 0 1px 1px rgba(255,255,255,0.8);
}
.link {
  color: #ff69b4; /* 粉色链接 */
  cursor: pointer;
  margin-left: 5px;
  font-weight: 600;
  transition: all 0.3s;
}
.link:hover {
  text-decoration: underline;
  color: #ff1493; /* 深粉色 */
}

/* --- 玻璃拟态深度定制 (Glassmorphism) --- */
/* 注意：由于 el-dialog 使用了 append-to-body，我们需要使用 ::v-deep 来穿透样式 */

::v-deep .glass-auth-modal {
  /* 1. 半透明背景 (偏白) */
  background: rgba(255, 255, 255, 0.45) !important;
  
  /* 2. 背景模糊 (关键) */
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  
  /* 3. 边框高光 */
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  
  /* 4. 柔和的阴影 */
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
}

/* 标题样式 */
::v-deep .glass-auth-modal .el-dialog__title {
  color: #444;
  font-weight: 700;
  letter-spacing: 1px;
}

/* 输入框玻璃化 */
::v-deep .glass-auth-modal .el-input__inner {
  background: rgba(255, 255, 255, 0.5); /* 输入框也半透明 */
  border: 1px solid rgba(255, 255, 255, 0.5);
  border-radius: 8px;
  color: #333;
  transition: all 0.3s ease;
  backdrop-filter: blur(5px);
}

::v-deep .glass-auth-modal .el-input__inner:focus {
  background: rgba(255, 255, 255, 0.9);
  border-color: #ff69b4; /* 粉色聚焦边框 */
  box-shadow: 0 0 0 2px rgba(255, 105, 180, 0.2);
}

/* 按钮玻璃化/渐变 */
.glass-button {
  background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%);
  border: none;
  border-radius: 8px;
  font-weight: 600;
  color: white;
  transition: transform 0.2s, box-shadow 0.2s;
  box-shadow: 0 4px 6px rgba(255, 105, 180, 0.2);
}

.glass-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(255, 105, 180, 0.3);
  background: linear-gradient(135deg, #ff8085 0%, #fdb5e3 100%);
}

.glass-button:active {
  transform: translateY(0);
}

/* 单选框样式微调 */
::v-deep .glass-radio-group .el-radio.is-bordered {
  background: rgba(255, 255, 255, 0.5);
  border-color: rgba(255, 255, 255, 0.8);
}
::v-deep .glass-radio-group .el-radio.is-bordered.is-checked {
  background: rgba(255, 230, 240, 0.6);
  border-color: #ff69b4;
}
::v-deep .glass-radio-group .el-radio__input.is-checked .el-radio__inner {
  border-color: #ff69b4;
  background: #ff69b4;
}
::v-deep .glass-radio-group .el-radio__input.is-checked+.el-radio__label {
  color: #ff69b4;
}
</style>