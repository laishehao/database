<template>
  <el-dialog
    append-to-body
    :title="titleWithIcon"
    :visible.sync="modalVisible"
    width="550px"
    :before-close="handleClose"
    :close-on-click-modal="false"
    custom-class="cute-dialog-wrapper"
  >
    <el-form
      :model="form"
      :rules="rules"
      ref="formRef"
      label-width="90px"
      class="cute-form"
    >
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="🎓 学号" prop="studentId">
            <el-input
              v-model="form.studentId"
              placeholder="请输入学号"
              :readonly="isView"
              class="cute-input"
            >
              <i slot="prefix" class="el-icon-postcard"></i>
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="🌸 姓名" prop="name">
            <el-input
              v-model="form.name"
              placeholder="请输入姓名"
              :readonly="isView"
              class="cute-input"
            >
              <i slot="prefix" class="el-icon-user"></i>
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="🌈 性别" prop="gender">
        <el-radio-group
          v-model="form.gender"
          class="cute-radio-group"
          :disabled="isView"
        >
          <el-radio label="男" border class="cute-radio blue-radio"
            >👦 男生</el-radio
          >
          <el-radio label="女" border class="cute-radio pink-radio"
            >👧 女生</el-radio
          >
        </el-radio-group>
      </el-form-item>

      <el-form-item label="📚 专业" prop="major">
        <el-select
          v-model="form.major"
          placeholder="请选择修习专业"
          style="width: 100%"
          :disabled="isView"
          popper-class="cute-select-dropdown"
        >
          <el-option label="💻 计算机科学" value="计算机科学"></el-option>
          <el-option label="⚙️ 软件工程" value="软件工程"></el-option>
          <el-option label="📊 信息管理" value="信息管理"></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="📞 电话" prop="phone">
        <el-input
          v-model="form.phone"
          placeholder="用于接收魔法信件"
          maxlength="11"
          :readonly="isView"
          class="cute-input"
        >
          <i slot="prefix" class="el-icon-mobile-phone"></i>
        </el-input>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose" class="cute-btn-cancel" round>{{
        isView ? "关闭" : "暂不召唤"
      }}</el-button>
      <el-button
        v-if="!isView"
        type="primary"
        :loading="loading"
        @click="handleSubmit"
        class="cute-btn-submit"
        round
        icon="el-icon-magic-stick"
      >
        立即召唤
      </el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  name: "StudentModal",
  props: {
    visible: { type: Boolean, default: false },
    rowData: { type: Object, default: null },
  },
  computed: {
    modalVisible: {
      get() {
        return this.visible;
      },
      set(val) {
        this.$emit("update:visible", val);
      },
    },
    isView() {
      return !!this.rowData;
    },
    titleWithIcon() {
      return this.isView ? "✨ 查看同学档案" : "🦄 召唤新同学";
    },
  },
  watch: {
    visible(val) {
      if (val) {
        if (this.rowData) {
          // 深拷贝数据到 form (防止直接修改表格数据)
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = {
            studentId: "",
            name: "",
            gender: "男",
            major: "",
            phone: "",
            avatar: "",
          };
        }
        this.$nextTick(() => {
          this.$refs.formRef && this.$refs.formRef.clearValidate();
        });
      }
    },
  },
  data() {
    return {
      loading: false,
      form: {
        studentId: "",
        name: "",
        gender: "男",
        major: "",
        phone: "",
        avatar: "",
      },
      rules: {
        studentId: [
          { required: true, message: "不可以没有学号哦", trigger: "blur" },
        ],
        name: [
          { required: true, message: "同学叫什么名字呢?", trigger: "blur" },
        ],
        major: [
          { required: true, message: "请选择修习专业", trigger: "change" },
        ],
        phone: [
          { required: true, message: "请留下联系方式", trigger: "blur" },
          {
            pattern: /^1[3-9]\d{9}$/,
            message: "好像不是正确的手机号呢",
            trigger: "blur",
          },
        ],
      },
    };
  },
  methods: {
    handleClose() {
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          // isView 模式下不应该调用此方法，但为了逻辑完整保留 Add
          const apiType = "studentAdd";

          this.$api({
            apiType,
            data: {
              role: "teacher",
              Cno: this.$route.params.courseId,
              Sno: this.form.studentId,
              ...this.form,
            },
          })
            .then(() => {
              this.$message.success("新同学召唤成功~");
              this.$emit("success");
            })
            .catch((err) => {
              console.error(err);
              this.$message.error("召唤失败了QAQ");
            })
            .finally(() => {
              this.loading = false;
              this.handleClose();
            });
        }
      });
    },
  },
};
</script>

<style>
/* 复用 CourseModal 中的 cute-dialog-wrapper 样式体系 
  确保风格高度统一
*/

/* 弹窗整体容器 */
.cute-dialog-wrapper {
  border-radius: 20px !important;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(255, 182, 193, 0.4) !important;
  font-family: "Muli", "Rounded Mplus 1c", sans-serif;
}

/* 标题栏 */
.cute-dialog-wrapper .el-dialog__header {
  background: linear-gradient(135deg, #ffb7c5 0%, #ff69b4 100%);
  padding: 15px 20px;
}

.cute-dialog-wrapper .el-dialog__title {
  color: white;
  font-weight: bold;
  letter-spacing: 1px;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
}

.cute-dialog-wrapper .el-dialog__headerbtn .el-dialog__close {
  color: white;
  font-weight: bold;
}
.cute-dialog-wrapper .el-dialog__headerbtn:hover .el-dialog__close {
  color: #fff0f5;
  transform: rotate(90deg);
  transition: transform 0.3s;
}

/* 内容区域 */
.cute-dialog-wrapper .el-dialog__body {
  padding: 30px 40px;
  background-color: #fffdfe;
}

/* 表单 Label */
.cute-form .el-form-item__label {
  color: #6b4c56;
  font-weight: bold;
}

/* 输入框美化 */
.cute-input .el-input__inner {
  border-radius: 20px;
  border: 2px solid #ffe4e1;
  color: #6b4c56;
  padding-left: 35px;
  transition: all 0.3s;
}
.cute-input .el-input__inner:focus {
  border-color: #ff69b4;
  box-shadow: 0 0 0 3px rgba(255, 105, 180, 0.1);
}
.cute-input .el-input__prefix {
  left: 10px;
  color: #ffb7c5;
}
.cute-input.is-disabled .el-input__inner {
  background-color: #f8f8f8;
  border-color: #eee;
  color: #aaa;
}

/* 下拉框样式 */
.cute-select-dropdown {
  border-radius: 15px !important;
  border: 1px solid #ffe4e1 !important;
}
.cute-select-dropdown .el-select-dropdown__item.selected {
  color: #ff69b4 !important;
  font-weight: bold;
}
.cute-select-dropdown .el-select-dropdown__item:hover {
  background-color: #fff0f5 !important;
}

/* 单选框美化 */
.cute-radio-group {
  display: flex;
  gap: 15px;
}
.cute-radio.is-bordered {
  border-radius: 20px;
  border-width: 2px;
  height: 40px;
  line-height: 40px;
  padding: 0 20px 0 10px !important;
}
.cute-radio .el-radio__label {
  font-weight: bold;
}

/* 男生单选样式 */
.blue-radio.is-bordered {
  border-color: #b2ebf2;
  color: #5d4037;
}
.blue-radio.is-bordered.is-checked {
  background-color: #e0f7fa;
  border-color: #4dd0e1;
}
.blue-radio .el-radio__input.is-checked .el-radio__inner {
  border-color: #4dd0e1;
  background: #4dd0e1;
}

/* 女生单选样式 */
.pink-radio.is-bordered {
  border-color: #ffc0cb;
  color: #5d4037;
}
.pink-radio.is-bordered.is-checked {
  background-color: #fff0f5;
  border-color: #ff69b4;
}
.pink-radio .el-radio__input.is-checked .el-radio__inner {
  border-color: #ff69b4;
  background: #ff69b4;
}

/* 底部按钮栏 */
.cute-dialog-wrapper .el-dialog__footer {
  padding: 15px 20px 25px;
  text-align: center;
}

.cute-btn-cancel {
  border: 2px solid #ffe4e1;
  color: #888;
  padding: 10px 25px;
}
.cute-btn-cancel:hover {
  background-color: #fff0f5;
  color: #6b4c56;
  border-color: #ffb7c5;
}

.cute-btn-submit {
  background: linear-gradient(135deg, #ffb6c1 0%, #ff69b4 100%);
  border: none;
  padding: 10px 30px;
  box-shadow: 0 4px 12px rgba(255, 105, 180, 0.4);
  transition: transform 0.2s;
}
.cute-btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(255, 105, 180, 0.6);
}
</style>