<template>
  <el-dialog
    title="编辑个人资料"
    :visible.sync="modalVisible"
    width="500px"
    :close-on-click-modal="false"
    append-to-body
  >
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
      <el-form-item label="姓名" prop="name">
        <el-input v-model="form.name" placeholder="请输入姓名"></el-input>
      </el-form-item>

      <!-- 性别选择 -->
      <el-form-item label="性别" prop="gender">
        <el-radio-group v-model="form.gender">
          <el-radio label="male">男</el-radio>
          <el-radio label="female">女</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="专业" prop="major" v-if="isStudent">
        <el-input v-model="form.major" placeholder="请输入专业"></el-input>
      </el-form-item>

      <el-form-item label="邮箱" prop="email">
        <el-input v-model="form.email" placeholder="请输入邮箱"></el-input>
      </el-form-item>

      <el-form-item label="电话" prop="phone">
        <el-input v-model="form.phone" placeholder="请输入联系电话"></el-input>
      </el-form-item>

      <el-divider content-position="left">修改密码（可选）</el-divider>

      <el-form-item label="新密码" prop="newPassword">
        <el-input
          v-model="form.newPassword"
          type="password"
          placeholder="不修改请留空"
          show-password
        ></el-input>
      </el-form-item>

      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input
          v-model="form.confirmPassword"
          type="password"
          placeholder="请再次输入新密码"
          show-password
        ></el-input>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取 消</el-button>
      <el-button type="primary" :loading="loading" @click="handleSubmit"
        >保 存</el-button
      >
    </span>
  </el-dialog>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "ProfileEditModal",
  props: {
    // 控制显示隐藏
    visible: {
      type: Boolean,
      default: false,
    },
    // 当前用户信息，用于回显
    userInfo: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    // 自定义确认密码校验器
    const validateConfirmPassword = (rule, value, callback) => {
      if (this.form.newPassword && !value) {
        callback(new Error("请再次输入新密码"));
      } else if (this.form.newPassword && value !== this.form.newPassword) {
        callback(new Error("两次输入的密码不一致"));
      } else {
        callback();
      }
    };

    return {
      loading: false,
      form: {
        name: "",
        gender: "",
        major: "",
        email: "",
        phone: "",
        newPassword: "",
        confirmPassword: "",
      },
      rules: {
        name: [{ required: true, message: "请输入姓名", trigger: "blur" }],
        major: [{ required: true, message: "请输入专业", trigger: "blur" }],
        email: [
          { required: true, message: "请输入邮箱", trigger: "blur" },
          {
            type: "email",
            message: "请输入正确的邮箱格式",
            trigger: ["blur", "change"],
          },
        ],
        phone: [{ required: true, message: "请输入联系电话", trigger: "blur" }],
        newPassword: [
          { min: 6, message: "密码长度至少为6位", trigger: "blur" },
        ],
        confirmPassword: [
          { validator: validateConfirmPassword, trigger: "blur" },
        ],
      },
    };
  },
  computed: {
    ...mapGetters({ storeUserInfo: "userInfo" }),
    isStudent() {
      return this.storeUserInfo.role === "student";
    },
    // 使用计算属性处理 sync，避免直接修改 prop
    modalVisible: {
      get() {
        return this.visible;
      },
      set(val) {
        this.$emit("update:visible", val);
      },
    },
  },
  watch: {
    // 监听窗口打开，进行数据回显
    visible(val) {
      if (val && this.userInfo) {
        this.form = {
          name: this.userInfo.name || "",
          gender: this.userInfo.gender || "",
          major: this.userInfo.major || "",
          email: this.userInfo.email || "",
          phone: this.userInfo.phone || "",
          newPassword: "",
          confirmPassword: "",
        };
        // 清除之前的校验红字
        this.$nextTick(() => {
          if (this.$refs.formRef) this.$refs.formRef.clearValidate();
        });
      }
    },
  },
  methods: {
    handleClose() {
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;

          // 1. 准备提交的数据（排除 confirmPassword）
          // eslint-disable-next-line no-unused-vars
          const { confirmPassword, newPassword, ...restForm } = this.form;
          const submitData = { ...restForm };

          // 如果用户填写了新密码，则添加 password 字段
          if (newPassword) {
            submitData.password = newPassword;
          }

          // 2. 调用 API
          this.$api({
            apiType: "profileSubmit",
            data: {
              ...submitData,
              id: this.storeUserInfo.id,
              role: this.storeUserInfo.role,
            },
          })
            .then((res) => {
              this.$message.success("资料更新成功");

              // 3. 修改点：直接使用后端返回的最新用户信息
              // 兼容处理：如果后端返回结构是 { user: {...} } 则取 res.user，否则直接用 res
              const returnedUser = res.user || res;

              // 将后端返回的数据传回父组件，用于更新 Vuex
              this.$emit("success", returnedUser);
              this.handleClose();
            })
            .catch((err) => {
              console.error(err);
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
  },
};
</script>