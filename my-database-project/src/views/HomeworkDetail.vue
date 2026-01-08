<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix">
      <!-- 页头组件，自带返回按钮 -->
      <el-page-header @back="goBack" content="作业详情"></el-page-header>
    </div>

    <div v-loading="loading" class="detail-container">
      <!-- 作业基本信息 -->
      <el-descriptions
        title="基本信息"
        border
        :column="2"
        style="margin-bottom: 20px"
      >
        <el-descriptions-item label="作业名称">
          <span style="font-weight: bold">{{ detail.title }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="所属课程">
          <el-tag size="small">{{ detail.course }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="detail.completed ? 'success' : 'warning'" size="small">
            {{ detail.completed ? "已完成" : "未完成" }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="截止时间"
          >2025-12-31 23:59</el-descriptions-item
        >
        <el-descriptions-item
          label="成绩"
          v-if="
            detail.completed &&
            detail.score !== null &&
            detail.score !== undefined
          "
        >
          <span class="score-display">{{ detail.score }} 分</span>
        </el-descriptions-item>
        <el-descriptions-item
          label="评语"
          v-if="detail.completed && detail.teacherComment"
        >
          <span style="color: #606266">{{ detail.teacherComment }}</span>
        </el-descriptions-item>
      </el-descriptions>

      <!-- 作业要求区域 -->
      <div class="content-section">
        <h3>📄 作业要求</h3>
        <div class="content-box requirement-box">
          {{ detail.content || "暂无详细描述..." }}
        </div>
      </div>

      <!-- 作答区域 (富文本编辑器) -->
      <div class="submission-section" style="margin-top: 20px">
        <h3>✏️ 我的作答</h3>

        <!-- 情况 A: 未完成状态，显示可编辑的富文本编辑器 -->
        <div v-if="!detail.completed" class="editor-container">
          <wang-editor
            v-model="submissionContent"
            placeholder="在此处输入您的作业答案..."
            :upload-server="uploadServerUrl"
            height="300px"
          />
        </div>

        <!-- 情况 B: 已完成状态，显示只读的 HTML 内容 -->
        <div v-else class="content-box submission-display">
          <div
            v-if="submissionContent"
            v-html="submissionContent"
            class="ql-editor"
            style="padding: 0"
          ></div>
          <div v-else style="color: #909399; font-style: italic">
            (本次提交无文本内容)
          </div>
        </div>
      </div>

      <!-- 4. 底部操作区 -->
      <div
        style="margin-top: 50px; text-align: center"
        v-if="!detail.completed"
      >
        <el-button
          type="primary"
          icon="el-icon-check"
          :loading="submitting"
          @click="handleComplete"
        >
          确认提交作业
        </el-button>
      </div>
    </div>
  </el-card>
</template>

<script>
import { mapGetters } from "vuex";
import WangEditor from "@/components/WangEditor.vue";

export default {
  name: "HomeworkDetail",
  components: {
    WangEditor,
  },
  data() {
    return {
      loading: false,
      submitting: false, // 提交按钮加载状态
      detail: {
        //单个作业信息
        id: "",
        title: "",
        course: "",
        completed: false,
        content: "",
        score: null, // 成绩
        teacherComment: "", // 教师评语
      },
      // 学生作答内容 (HTML 字符串)
      submissionContent: "",
    };
  },
  computed: {
    ...mapGetters(["userInfo"]),
    // 图片上传服务器地址，从环境变量读取
    uploadServerUrl() {
      return process.env.VUE_APP_FILE_UPLOAD_PATH || "/api/upload/image";
    },
  },
  created() {
    this.fetchDetail();
  },
  methods: {
    //this.$router.go(-1)返回上一页
    goBack() {
      this.$router.go(-1);
    },
    // 获取作业详情
    fetchDetail() {
      this.loading = true;
      const id = String(this.$route.params.id || "");

      this.$api({
        apiType: "homeworkDetail",
        data: { workId: id, userId: this.userInfo && this.userInfo.id }, // restful 替换 :id
      })
        .then((res) => {
          // 兼容后端返回不同字段名，优先使用 res.detail，如果没有则使用 res 本身
          const returned = res && res.detail ? res.detail : res || {};
          // 归一化 id 字段：确保有 workId 和 id，优先级：returned.workId -> returned.id -> route id
          const normalizedWorkId =
            returned.workId ||
            returned.id ||
            id ||
            (res && (res.workId || res.id)) ||
            "";
          returned.workId = String(normalizedWorkId);
          returned.id = returned.id || returned.workId;

          this.detail = returned;

          // 回显学生已保存的答案（如果存在）
          if (res && res.studentAnswer) {
            this.submissionContent = res.studentAnswer;
          } else if (returned.content && returned.completed) {
            // 若已完成且后端返回了 content，可选择回显 studentContent 等字段
          }
        })
        .catch((err) => {
          console.error(err);
          this.$message.error("获取作业详情失败");
        })
        .finally(() => {
          this.loading = false;
        });
    },

    // 提交作业
    handleComplete() {
      // 校验内容是否为空
      // 使用正则去除 HTML 标签，判断纯文本是否为空
      const plainText = this.submissionContent.replace(/<[^>]+>/g, "").trim();
      const hasImage = this.submissionContent.includes("<img");
      if (!plainText && !hasImage) {
        this.$message.warning("请填写作业内容后再提交");
        return;
      }

      this.$confirm("确认提交该作业吗? 提交后不可修改", "提示", {
        confirmButtonText: "确定提交",
        cancelButtonText: "取消",
        type: "success",
      })
        .then(() => {
          this.submitting = true;
          // 归一化并校验 workId 与 userId，避免 undefined
          const workId = String(
            this.detail &&
              (this.detail.workId ||
                this.detail.id ||
                this.$route.params.id ||
                "")
          );
          const userId =
            this.userInfo && this.userInfo.id ? this.userInfo.id : null;
          if (!workId) {
            this.$message.error("无法确定作业 ID，无法提交");
            this.submitting = false;
            return;
          }
          if (!userId) {
            this.$message.error("未检测到当前用户，无法提交");
            this.submitting = false;
            return;
          }

          this.$api({
            apiType: "homeworkSubmit",
            data: {
              role: "student",
              workId,
              userId,
              writeCheck: true,
              content: this.submissionContent,
            },
          })
            .then(() => {
              this.$message.success("提交成功");
              this.detail.completed = true;
              // 同步 Vuex 状态 (可选)，确保传入的是 id（回退到 workId）
              this.$store.dispatch(
                "completeHomework",
                this.detail.id || workId
              );
            })
            .catch((err) => {
              console.error(err);
            })
            .finally(() => {
              this.submitting = false;
            });
        })
        .catch(() => {
          // 取消提交
        });
    },
  },
};
</script>

<style scoped>
/* 通用内容容器样式 */
.detail-container {
  max-width: 900px;
  margin: 0 auto;
}

.content-box {
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 4px;
  color: #606266;
  line-height: 1.6;
  border: 1px solid #ebeef5;
}

/* 题目要求区域 */
.requirement-box {
  min-height: 80px;
  font-size: 15px;
}

/* 编辑器容器高度控制 */
.editor-container {
  /* 给编辑器留足空间，包括工具栏和编辑区 */
  margin-bottom: 60px;
}

/* 已提交内容展示区域 */
.submission-display {
  min-height: 150px;
  background-color: #f0f9eb; /* 浅绿色背景表示已完成 */
  border-color: #e1f3d8;
  overflow-x: auto; /* 防止大图溢出 */
}

/* wangEditor 编辑器样式 */
#wangeditor-toolbar {
  border: 1px solid #dcdfe6;
  border-bottom: none;
  border-radius: 4px 4px 0 0;
}

#wangeditor-content {
  border: 1px solid #dcdfe6;
  border-radius: 0 0 4px 4px;
  min-height: 300px;
}

/* 编辑器内容区域图片样式 */
::v-deep #wangeditor-content img {
  max-width: 100%;
  height: auto;
}

/* 已提交内容区域的图片样式 */
.submission-display img {
  max-width: 100%;
  height: auto;
}

/* 成绩显示样式 */
.score-display {
  font-family: "Arial", sans-serif;
  font-size: 18px;
  color: #ff69b4;
  font-weight: bold;
}
</style>