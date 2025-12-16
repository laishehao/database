<template>
  <el-dialog 
    :title="title" 
    :visible.sync="modalVisible" 
    width="420px"
    :before-close="handleClose"
    :close-on-click-modal="false"
    append-to-body
  >
    <el-form :model="form" :rules="rules" ref="formRef" label-width="0px">
      
      <template v-if="mode === 'register'">
        <el-form-item prop="role" style="text-align: center">
          <el-radio-group v-model="form.role" size="small">
            <el-radio label="student" border>我是学生</el-radio>
            <el-radio label="teacher" border>我是老师</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item prop="name">
          <el-input 
            v-model="form.name" 
            prefix-icon="el-icon-user" 
            placeholder="请输入您的昵称/姓名">
          </el-input>
        </el-form-item>

        <el-form-item prop="email">
          <el-input 
            v-model="form.email" 
            prefix-icon="el-icon-message" 
            placeholder="请输入电子邮箱">
          </el-input>
        </el-form-item>
      </template>

      <el-form-item prop="username">
        <el-input 
          v-model="form.username" 
          prefix-icon="el-icon-user-solid" 
          placeholder="请输入账号 (4-16位字母/数字)">
        </el-input>
      </el-form-item>

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

    <div class="form-footer">
      <el-button type="primary" style="width: 100%;" :loading="loading" @click="handleSubmit">
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
// 正则定义提取到外面
const REGEX_PASSWORD = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d!.#*?&]{8,12}$/;
const REGEX_USERNAME = /^[a-zA-Z0-9_-]{4,16}$/;
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
      mode: 'login',
      loading: false,
      form: {
        username: '',
        password: '',
        name: '',
        email: '',
        role: 'student'
      },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { pattern: REGEX_USERNAME, message: '账号需为4-16位字母、数字、下划线或减号', trigger: 'blur' }
        ],
        password: [
          { required: true, validator: validatePassword, trigger: 'blur' }
        ],
        name: [
          { required: true, message: '请输入昵称', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { pattern: REGEX_EMAIL, message: '请输入正确的邮箱格式', trigger: 'blur' }
        ]
      }
    };
  },
  computed: {
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); }
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
    handleClose() {
      this.modalVisible = false;
    },
    resetForm() {
      this.form = { username: '', password: '', name: '', email: '', role: 'student' };
      this.$nextTick(() => {
        this.$refs.formRef && this.$refs.formRef.clearValidate();
      });
    },
    switchMode(targetMode) {
      this.mode = targetMode;
      this.$nextTick(() => {
        this.$refs.formRef.clearValidate();
      });
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          const apiType = this.mode;
          
          this.$api({
            apiType: apiType,
            data: this.form
          }).then(res => {
            this.$message.success(this.mode === 'login' ? '登录成功' : '注册成功');
            
            // 1. 获取用户信息 (兼容 res 是 user 对象 或 res.user 是 user 对象)
            let userInfo = res.user || res;

            // 防御性检查：确保 userInfo 存在
            if (!userInfo) {
              throw new Error('获取用户信息失败');
            }

            // 2. 数据补全 (角色、名字、头像)
            if (this.mode === 'register' && !userInfo.role) {
              userInfo.role = this.form.role;
            }
            if (!userInfo.name) {
              userInfo.name = this.form.name || this.form.username;
            }
            if (!userInfo.avatar) {
              userInfo.avatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png';
            }

            // 3. 存储到 Vuex Store (Store 内部会自动存 localStorage)
            this.$store.dispatch('login', userInfo);

            // 4. 派发事件 (保留以兼容旧的 SideMenu 监听逻辑)
            const setItemEvent = new Event('setItemEvent');
            window.dispatchEvent(setItemEvent);

            // 5. 通知父组件
            this.$emit('success', userInfo);
            this.handleClose();
          }).catch(err => {
            console.error(err);
            // 错误提示已在 http.js 统一处理，此处不用写 notify
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
.form-footer {
  margin-top: 20px;
}
.switch-mode-text {
  margin-top: 15px;
  text-align: right;
  font-size: 14px;
  color: #606266;
}
.link {
  color: #409EFF;
  cursor: pointer;
  margin-left: 5px;
  font-weight: 500;
}
.link:hover {
  text-decoration: underline;
}
</style>