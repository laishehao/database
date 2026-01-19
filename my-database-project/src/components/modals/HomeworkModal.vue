<template>
  <el-dialog
    append-to-body
    :title="titleWithIcon"
    :visible.sync="modalVisible"
    width="600px"
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
      <el-form-item label="📝 名称" prop="title">
        <el-input
          v-model="form.title"
          placeholder="给这次任务起个名字吧"
          class="cute-input"
        >
          <i slot="prefix" class="el-icon-edit-outline"></i>
        </el-input>
      </el-form-item>

      <el-form-item label="📚 课程" prop="course">
        <el-select
          v-model="form.course"
          placeholder="属于哪门魔法专业呢?"
          style="width: 100%"
          popper-class="cute-select-dropdown"
          @change="handleCourseChange"
        >
          <el-option
            v-for="item in courseList"
            :key="item.courseId"
            :label="item.courseName"
            :value="item.courseName"
          ></el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="📜 内容" prop="content">
        <el-input
          type="textarea"
          v-model="form.content"
          :rows="5"
          placeholder="请写下详细的任务说明..."
          class="cute-textarea"
          resize="none"
        ></el-input>
      </el-form-item>

      <el-form-item label="⏰ 开始时间" prop="starttime">
        <el-date-picker
          v-model="form.starttime"
          type="datetime"
          placeholder="选择开始时间"
          style="width: 100%"
          value-format="yyyy-MM-dd HH:mm:ss"
        ></el-date-picker>
      </el-form-item>

      <el-form-item label="⏳ 截止时间" prop="overtime">
        <el-date-picker
          v-model="form.overtime"
          type="datetime"
          placeholder="选择截止时间"
          style="width: 100%"
          value-format="yyyy-MM-dd HH:mm:ss"
        ></el-date-picker>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose" class="cute-btn-cancel" round
        >暂不发布</el-button
      >
      <el-button
        type="primary"
        :loading="loading"
        @click="handleSubmit"
        class="cute-btn-submit"
        round
        icon="el-icon-s-promotion"
      >
        {{ isEdit ? "保存修改" : "立即发布" }}
      </el-button>
    </span>
  </el-dialog>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "HomeworkModal",
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
    // 接收回显数据
    rowData: {
      type: Object,
      default: null,
    },
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
    // 判断是否为编辑模式
    isEdit() {
      return !!this.rowData;
    },
    titleWithIcon() {
      return this.isEdit ? "✨ 修正魔法任务" : "🌟 发布新任务";
    },
    ...mapGetters(["userInfo"]),
  },
  watch: {
    visible(val) {
      if (val) {
        this.fetchCourseList(); // 打开弹窗时获取课程列表
        if (this.rowData) {
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = {
            title: "",
            course: "",
            courseId: "",
            content: "",
            starttime: "",
            overtime: "",
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
      courseList: [], // 课程列表
      form: {
        title: "",
        course: "",
        courseId: "",
        content: "",
        starttime: "",
        overtime: "",
      },
      rules: {
        title: [
          { required: true, message: "任务名称不能为空哦", trigger: "blur" },
        ],
        course: [
          { required: true, message: "请选择所属课程", trigger: "change" },
        ],
        content: [
          { required: true, message: "记得写上作业内容呀", trigger: "blur" },
        ],
        starttime: [
          { required: true, message: "请选择开始时间", trigger: "change" },
          {
            validator: (rule, value, callback) => {
              if (value && this.form.overtime) {
                if (new Date(value) >= new Date(this.form.overtime)) {
                  callback(new Error("开始时间必须在截止时间之前哦~"));
                } else {
                  callback();
                }
              } else {
                callback();
              }
            },
            trigger: "change",
          },
        ],
        overtime: [
          { required: true, message: "请选择截止时间", trigger: "change" },
          {
            validator: (rule, value, callback) => {
              if (value && this.form.starttime) {
                if (new Date(value) <= new Date(this.form.starttime)) {
                  callback(new Error("截止时间必须在开始时间之后哦~"));
                } else {
                  callback();
                }
              } else {
                callback();
              }
            },
            trigger: "change",
          },
        ],
      },
    };
  },
  methods: {
    // 获取课程列表
    fetchCourseList() {
      this.$api({
        apiType: "course",
        data: {
          role: this.userInfo.role,
          id: this.userInfo.id,
          query: '',
        },
      })
        .then((res) => {
          // 兼容处理：支持 res.data.list 或 res.list
          const resData = res.data || res;
          this.courseList = resData.list || [];
        })
        .catch((err) => {
          console.error("获取课程列表失败:", err);
        });
    },
    // 课程选择变化时，同步更新courseId
    handleCourseChange(selectedCourseName) {
      const selected = this.courseList.find(
        (item) => item.courseName === selectedCourseName
      );
      if (selected) {
        this.form.courseId = selected.courseId;
      }
    },
    //关闭窗口
    handleClose() {
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;

          // 根据模式选择接口
          const apiType = this.isEdit ? "homeworkEdit" : "homeworkAdd";

          // 准备提交的数据
          const submitData = {
            ...this.form,
            ...(this.isEdit ? {} : { progress: 0, active: true }),
          };

          this.$api({
            apiType: apiType,
            data: {
              ...submitData,
              userId: this.userInfo.id,
            },
          })
            .then(() => {
              this.$message.success(
                this.isEdit ? "任务修正成功~" : "新试炼发布成功~"
              );
              this.$emit("success");
              this.handleClose();
            })
            .catch((err) => {
              console.error(err);
              this.$message.error("发布失败了QAQ");
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

<style>
/* 复用通用的 cute-dialog-wrapper 样式体系 */

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

/* 文本域特殊处理 */
.cute-textarea .el-textarea__inner {
  border-radius: 15px;
  border: 2px solid #ffe4e1;
  color: #6b4c56;
  padding: 15px;
  font-family: inherit;
  transition: all 0.3s;
}
.cute-textarea .el-textarea__inner:focus {
  border-color: #ff69b4;
  box-shadow: 0 0 0 3px rgba(255, 105, 180, 0.1);
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