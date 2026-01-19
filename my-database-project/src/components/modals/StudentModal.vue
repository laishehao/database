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
import { mapGetters } from "vuex";

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
    ...mapGetters(["userInfo"]),
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
      },
      rules: {
        studentId: [
          { required: true, message: "不可以没有学号哦", trigger: "blur" },
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
              teacherId: this.userInfo.id,
              courseId: this.$route.params.courseId,
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