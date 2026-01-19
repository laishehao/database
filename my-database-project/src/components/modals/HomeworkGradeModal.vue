<template>
  <el-dialog
    :title="`正在批改：${submission.studentName || ''}`"
    :visible.sync="dialogVisible"
    width="700px"
    :close-on-click-modal="false"
    custom-class="grade-dialog"
    @close="handleClose"
  >
    <div class="grade-container">
      <div class="answer-section">
        <div class="section-title">
          <i class="el-icon-document"></i> 学生提交内容
        </div>
        <div class="answer-content-box">
          <div
            v-if="submission.content"
            v-html="submission.content"
            class="rich-text-content"
          ></div>
          <div v-else class="empty-answer">该学生未填写文本内容</div>
        </div>
        <div class="submit-info">
          提交时间：{{ submission.submitTime || "--" }}
        </div>
      </div>

      <el-divider></el-divider>

      <el-form :model="gradeForm" label-width="60px" class="grade-form">
        <el-form-item label="评分">
          <el-input-number
            v-model="gradeForm.score"
            :min="0"
            :max="100"
            size="medium"
          ></el-input-number>
        </el-form-item>

        <el-form-item label="评语">
          <el-input
            type="textarea"
            v-model="gradeForm.comment"
            :rows="4"
            placeholder="请输入评语，鼓励一下学生吧~"
            maxlength="200"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
    </div>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取 消</el-button>
      <el-button
        type="primary"
        :loading="submitting"
        @click="handleSubmit"
        class="pink-btn"
        >确 定</el-button
      >
    </span>
  </el-dialog>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "HomeworkGradeModal",
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
    submission: {
      type: Object,
      default: () => ({}),
    },
    homeworkId: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      submitting: false,
      gradeForm: {
        score: 80,
        comment: "",
      },
    };
  },
  computed: {
    dialogVisible: {
      get() {
        return this.visible;
      },
      set(val) {
        this.$emit("update:visible", val);
      },
    },
    ...mapGetters(["userInfo"]),
  },
  watch: {
    visible(newVal) {
      if (newVal && this.submission) {
        // 弹窗打开时，初始化表单数据
        this.gradeForm = {
          score:
            this.submission.score !== null &&
            this.submission.score !== undefined
              ? this.submission.score
              : 85,
          comment: this.submission.teacherComment || "",
        };
      }
    },
  },
  methods: {
    // 关闭窗口
    handleClose() {
      this.dialogVisible = false;
    },
    //提交表单
    handleSubmit() {
      this.submitting = true;
      this.$api({
        apiType: "homeworkGrade",
        data: {
          workId: this.homeworkId, //作业Id
          teacherId: this.userInfo.id, //教师Id
          studentId: this.submission.userId, //学生在数据库中的id
          score: this.gradeForm.score, //成绩
          teacherComment: this.gradeForm.comment, //教师评语
        },
      })
        .then((res) => {
          this.$message.success("批改完成");
          this.$emit("update:visible", false);
          // 触发成功事件，传递更新后的数据
          //父组件的回调函数会处理
          this.$emit("success", {
            ...res,
            studentId: this.submission.studentId || this.submission.userId,
            score: res.score !== undefined ? res.score : this.gradeForm.score,
            teacherComment:
              res.teacherComment || res.comment || this.gradeForm.comment,
          });
        })
        .catch((err) => {
          console.error(err);
          this.$message.error("批改失败，请重试");
        })
        .finally(() => {
          this.submitting = false;
        });
    },
  },
};
</script>

<style scoped>
/* 弹窗内容样式 */
.section-title {
  font-size: 15px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 10px;
}

.answer-content-box {
  background: #f9fafc;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  padding: 15px;
  min-height: 120px;
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.rich-text-content {
  line-height: 1.6;
  font-size: 14px;
  color: #606266;
}

.rich-text-content >>> img {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
}

.empty-answer {
  color: #909399;
  font-style: italic;
  text-align: center;
  padding-top: 40px;
}

.submit-info {
  text-align: right;
  font-size: 12px;
  color: #909399;
}

.pink-btn {
  background-color: #ff69b4;
  border-color: #ff69b4;
}
.pink-btn:hover {
  background-color: #ff85c2;
  border-color: #ff85c2;
}
</style>

