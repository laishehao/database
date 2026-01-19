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
        <el-col :span="12" v-if="isEdit">
          <el-form-item label="📝 代码">
            <el-input v-model="form.courseId" readonly class="cute-input">
              <i slot="prefix" class="el-icon-tickets"></i>
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="🎪 学院" prop="major">
            <el-select
              v-model="form.major"
              placeholder="请选择魔法分院"
              style="width: 100%"
              popper-class="cute-select-dropdown"
            >
              <el-option label="计算机学院" value="计算机科学"></el-option>
              <el-option label="数学院" value="数学"></el-option>
              <el-option label="外国语学院" value="英语"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="✨ 名称" prop="courseName">
        <el-input
          v-model="form.courseName"
          placeholder="给课程起个好听的名字吧"
          class="cute-input"
        >
          <i slot="prefix" class="el-icon-reading"></i>
        </el-input>
      </el-form-item>

      <el-form-item label="⭐ 学分" prop="credits">
        <el-input-number
          v-model="form.credits"
          :min="0.5"
          :step="0.5"
          style="width: 220px"
          class="cute-input-number"
          controls-position="right"
        ></el-input-number>
      </el-form-item>

      <el-form-item label="性质" prop="type">
        <el-radio-group v-model="form.type" class="cute-radio-group">
          <el-radio label="必修" border class="cute-radio">必修</el-radio>
          <el-radio label="选修" border class="cute-radio">选修</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="🧙‍♂️ 导师" v-if="isEdit">
        <el-input v-model="form.teacher" readonly class="cute-input">
          <i slot="prefix" class="el-icon-user"></i>
        </el-input>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose" class="cute-btn-cancel" round
        >暂不召唤</el-button
      >
      <el-button
        type="primary"
        :loading="loading"
        @click="handleSubmit"
        class="cute-btn-submit"
        round
        icon="el-icon-magic-stick"
      >
        {{ isEdit ? "保存修改" : "立即召唤" }}
      </el-button>
    </span>
  </el-dialog>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "CourseModal",
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
    isEdit() {
      return !!this.rowData;
    },
    titleWithIcon() {
      return this.isEdit ? "✨ 重新编排课程" : "🌟 召唤新课程";
    },
    ...mapGetters(["userInfo"]),
  },
  watch: {
    visible(val) {
      if (val) {
        if (this.rowData) {
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = {
            courseId: "",
            courseName: "",
            major: "",
            credits: 2.0,
            type: "必修",
            teacher: "",
          };
        }
        this.$nextTick(() => {
          if (this.$refs.formRef) {
            this.$refs.formRef.clearValidate();
          }
        });
      }
    },
  },
  data() {
    return {
      loading: false,
      form: {
        courseId: "",
        courseName: "",
        major: "",
        credits: 2.0,
        type: "必修",
        teacher: "",
      },
      rules: {
        courseId: [
          { required: true, message: "不可以没有代码哦", trigger: "blur" },
        ],
        courseName: [
          { required: true, message: "课程叫什么名字呢?", trigger: "blur" },
        ],
        major: [
          { required: true, message: "请选择所属学院", trigger: "change" },
        ],
        teacher: [{ required: true, message: "导师是谁呀?", trigger: "blur" }],
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
          const apiType = this.isEdit ? "courseEdit" : "courseAdd";

          this.$api({
            apiType: apiType,
            data: {
              role: "teacher",
              userId: this.userInfo.id,
              ...this.form,
            },
          })
            .then(() => {
              this.$message.success(
                this.isEdit ? "修改成功啦~" : "召唤成功啦~"
              );
              this.$emit("success");
            })
            .catch((error) => {
              console.error(error);
              const errorMsg = this.isEdit ? "修改失败了QAQ" : "召唤失败了QAQ";
              this.$message.error(errorMsg);
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
/* 注意：这里没有使用 scoped
  因为 el-dialog 设置了 append-to-body，它会挂载到 body 下，
  scoped样式无法穿透到 body 级的元素。
  我们通过 custom-class="cute-dialog-wrapper" 来限定样式范围。
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
  padding-left: 35px; /* 为图标留位置 */
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

/* 禁用状态 */
.cute-input.is-disabled .el-input__inner {
  background-color: #f8f8f8;
  border-color: #eee;
  color: #aaa;
}

/* 只读状态 */
.cute-input .el-input__inner[readonly] {
  background-color: #fff5f7;
  border: 2px dashed #ffe4e1;
  color: #888;
  cursor: not-allowed;
}

/* 下拉框 */
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

/* 数字输入框 */
.cute-input-number .el-input__inner {
  border-radius: 20px;
  border: 2px solid #ffe4e1;
  text-align: left;
  padding-left: 15px;
}
.cute-input-number .el-input-number__decrease,
.cute-input-number .el-input-number__increase {
  background: transparent;
  border: none !important; /* 移除所有分割线 */
  color: #ff69b4;
}

/* 单选框 */
.cute-radio-group {
  display: flex;
  gap: 10px;
}
.cute-radio.is-bordered {
  border-radius: 20px;
  border-color: #ffe4e1;
  color: #888;
}
.cute-radio.is-bordered.is-checked {
  border-color: #ff69b4;
  background-color: #fff0f5;
}
.cute-radio .el-radio__label {
  font-weight: bold;
}
.cute-radio .el-radio__input.is-checked .el-radio__inner {
  border-color: #ff69b4;
  background: #ff69b4;
}

/* 底部按钮栏 */
.cute-dialog-wrapper .el-dialog__footer {
  padding: 15px 20px 25px;
  text-align: center; /* 按钮居中 */
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