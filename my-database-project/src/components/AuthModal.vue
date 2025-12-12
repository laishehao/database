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
export default {
  name: 'AuthModal',
  props: {
    visible: { type: Boolean, default: false },
    initialMode: { type: String, default: 'login' }
  },
  data() {
      /*
      *密码 (REGEX_PASSWORD):/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d!.#*?&]{8,12}$/
      *(?=.*[a-z]): 必须包含至少一个小写字母。
      *(?=.*[A-Z]): 必须包含至少一个大写字母。
      *(?=.*\d): 必须包含至少一个数字。
      *[a-zA-Z\d!.#*?&]{8,12}: 长度在 8 到 12 位之间，且字符只能是字母、数字和 !.#*?& 这些特殊字符。
      */
      /*
      *账号 (REGEX_USERNAME)/^[a-zA-Z0-9_-]{4,16}$/
      *允许大小写字母、数字、下划线、减号，长度 4-16 位。
      */
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

    return {
      mode: 'login',
      loading: false,
      form: {
        username: '',
        password: '',
        name: '',
        email: '' // 新增
      },
      // 3. 校验规则配置
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
      // 重置时记得包含 email
      this.form = { username: '', password: '', name: '', email: '' };
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
            // 注意：如果注册成功后后端不直接返回用户信息，而是要求去登录，
            // 这里可能需要判断一下 mode，如果是 register 则切换到 login 模式
            const userInfo = res.user || res; 
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