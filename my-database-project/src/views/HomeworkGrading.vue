<template>
  <div class="grading-container">
    <el-card shadow="never" class="grading-card">
      <!-- 头部：返回按钮和标题 -->
      <div slot="header" class="clearfix header-wrapper">
        <el-page-header
          @back="goBack"
          :content="`${homeworkTitle}`"
          title="返回列表"
        ></el-page-header>

        <!-- 统计信息区域 -->
        <div class="header-stats">
          <!-- 基础计数 -->
          <span class="stat-group">
            <span>共 {{ total }} 人</span>
            <el-divider direction="vertical"></el-divider>
            <span class="stat-item submitted"
              >已提交: {{ submittedCount }}</span
            >
            <el-divider direction="vertical"></el-divider>
            <span class="stat-item graded">已批改: {{ gradedCount }}</span>
          </span>

          <!-- 分数统计 (仅当有已批改作业时显示) -->
          <span class="stat-group score-stats" v-if="gradedCount > 0">
            <el-divider direction="vertical" class="divider-wide"></el-divider>
            <span
              >平均分: <b style="color: #409eff">{{ averageScore }}</b></span
            >
            <el-divider direction="vertical"></el-divider>
            <span
              >最高分: <b style="color: #67c23a">{{ maxScore }}</b></span
            >
            <el-divider direction="vertical"></el-divider>
            <span
              >最低分: <b style="color: #f56c6c">{{ minScore }}</b></span
            >
          </span>
        </div>
      </div>

      <!-- 数据表格 -->
      <div v-loading="loading">
        <el-table :data="submissions" style="width: 100%" stripe>
          <el-table-column prop="studentName" label="学生姓名" width="180">
            <template slot-scope="scope">
              <div style="display: flex; align-items: center">
                <!-- 保持之前的修改：只显示姓名 -->
                <span style="font-weight: 500">{{
                  scope.row.studentName
                }}</span>
              </div>
            </template>
          </el-table-column>

          <el-table-column prop="studentId" label="学号" width="150">
            <template slot-scope="scope">
              <span style="font-family: monospace">{{
                scope.row.studentId
              }}</span>
            </template>
          </el-table-column>

          <el-table-column prop="submitTime" label="提交时间" min-width="180">
            <template slot-scope="scope">
              <span v-if="scope.row.submitTime">{{
                scope.row.submitTime
              }}</span>
              <span v-else style="color: #909399; font-size: 12px">--</span>
            </template>
          </el-table-column>

          <el-table-column label="状态" width="120" align="center">
            <template slot-scope="scope">
              <el-tag
                :type="getStatusType(scope.row.status)"
                size="small"
                effect="light"
              >
                {{ getStatusText(scope.row.status) }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column label="分数" width="120" align="center">
            <template slot-scope="scope">
              <span
                v-if="scope.row.score !== null && scope.row.score !== undefined"
                class="score-text"
              >
                {{ scope.row.score }}
              </span>
              <span v-else style="color: #ccc">-</span>
            </template>
          </el-table-column>

          <el-table-column label="操作" width="150" fixed="right">
            <template slot-scope="scope">
              <el-button
                v-if="scope.row.status !== 'unsubmitted'"
                type="text"
                size="small"
                :style="{
                  color: scope.row.status === 'graded' ? '#909399' : '#ff69b4',
                }"
                icon="el-icon-edit-outline"
                @click="openGradeModal(scope.row)"
              >
                {{ scope.row.status === "graded" ? "修改评分" : "批改作业" }}
              </el-button>
              <span v-else style="color: #c0c4cc; font-size: 12px"
                >暂未提交</span
              >
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 批改弹窗 -->
      <HomeworkGradeModal
        :visible.sync="modalVisible"
        :submission="currentSubmission"
        :homework-id="workId"
        @success="handleGradeSuccess"
      />
    </el-card>
  </div>
</template>

<script>
import HomeworkGradeModal from "@/components/modals/HomeworkGradeModal.vue";

export default {
  name: "HomeworkGrading",
  components: {
    HomeworkGradeModal,
  },
  data() {
    return {
      workId: null,
      homeworkTitle: "作业批改",
      loading: false,
      submissions: [],

      modalVisible: false,
      currentSubmission: {},
    };
  },
  computed: {
    total() {
      return this.submissions.length;
    },
    submittedCount() {
      return this.submissions.filter((s) => s.status !== "unsubmitted").length;
    },
    gradedCount() {
      return this.submissions.filter((s) => s.status === "graded").length;
    },

    // filter保留已打分的作业（排除 score 为 null 或 undefined 的项）
    gradedList() {
      return this.submissions.filter((s) => typeof s.score === "number");
    },
    // 平均分
    averageScore() {
      if (this.gradedList.length === 0) return "--";
      const sum = this.gradedList.reduce((acc, curr) => acc + curr.score, 0);
      return (sum / this.gradedList.length).toFixed(1); // 保留一位小数
    },
    // 最高分
    maxScore() {
      if (this.gradedList.length === 0) return "--";
      return Math.max(...this.gradedList.map((s) => s.score));
    },
    // 最低分
    minScore() {
      if (this.gradedList.length === 0) return "--";
      return Math.min(...this.gradedList.map((s) => s.score));
    },
  },
  created() {
    const routeId =
      this.$route.params.workId ||
      this.$route.params.id ||
      this.$route.query.workId ||
      this.$route.query.id ||
      "";
    this.workId = routeId ? String(routeId) : null;
    // 优先使用路由 query 中的 title
    if (this.$route.query.title) {
      this.homeworkTitle = this.$route.query.title;
    }
    this.fetchSubmissions();
  },
  methods: {
    goBack() {
      this.$router.go(-1);
    },
    getStatusType(status) {
      const map = {
        unsubmitted: "info",
        submitted: "warning",
        graded: "success",
      };
      return map[status] || "info";
    },
    getStatusText(status) {
      const map = {
        unsubmitted: "未提交",
        submitted: "待批改",
        graded: "已批改",
      };
      return map[status] || "未知";
    },

    fetchSubmissions() {
      this.loading = true;
      // 归一化 workId，优先使用 data 字段 this.workId，再回退到路由参数
      const workId =
        this.workId ||
        this.$route.params.id ||
        this.$route.params.workId ||
        this.$route.query.id ||
        this.$route.query.workId ||
        null;
      if (!workId) {
        console.warn(
          "fetchSubmissions: missing workId, aborting fetchSubmissions"
        );
        this.$message.error("无法确定作业 ID，无法获取提交列表");
        this.loading = false;
        return;
      }

      this.$api({
        apiType: "homeworkSubmissions",
        data: { workId },
      })
        .then((res) => {
          // 根据后端返回结构：{ code: 200, msg: "获取成功", data: { title: "...", list: [...] } }
          // 获取提交列表
          const list = res?.data?.list || res?.list || [];

          // 字段映射：后端返回 userId/name，前端使用 studentId/studentName
          this.submissions = Array.isArray(list)
            ? list.map((item) => ({
                ...item,
                studentId: item.studentId || item.userId,
                studentName: item.studentName || item.name,
              }))
            : [];

          // 如果后端返回了作业标题，更新 homeworkTitle
          // 优先使用路由 query 的 title，如果没有则使用后端返回的
          if (!this.$route.query.title && res?.data?.title) {
            this.homeworkTitle = res.data.title;
          }
        })
        .catch((err) => {
          console.error(err);
          this.$message.error("获取提交列表失败");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    //打开评分窗口
    openGradeModal(row) {
      this.currentSubmission = row;
      this.modalVisible = true;
    },
    // 批改成功后的回调，更新本地数据
    handleGradeSuccess(res) {
      const studentId =
        res.studentId ||
        this.currentSubmission.studentId ||
        this.currentSubmission.userId;
      const index = this.submissions.findIndex(
        (s) => s.studentId === studentId || s.userId === studentId
      );

      if (index !== -1) {
        if (res && typeof res === "object") {
          this.$set(this.submissions, index, {
            ...this.submissions[index],
            ...res,
            status: "graded",
            score:
              res.score !== undefined
                ? res.score
                : this.submissions[index].score,
            teacherComment:
              res.teacherComment !== undefined
                ? res.teacherComment
                : res.comment || this.submissions[index].teacherComment,
          });
        } else {
          // 兜底逻辑
          this.$set(this.submissions[index], "status", "graded");
          if (res.score !== undefined) {
            this.$set(this.submissions[index], "score", res.score);
          }
          if (res.teacherComment !== undefined || res.comment !== undefined) {
            this.$set(
              this.submissions[index],
              "teacherComment",
              res.teacherComment || res.comment
            );
          }
        }
      }
    },
  },
};
</script>

<style scoped>
.grading-container {
  padding: 0;
}
.header-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.header-stats {
  font-size: 14px;
  color: #606266;
  display: flex;
  align-items: center;
}
.stat-item.submitted {
  color: #e6a23c;
  font-weight: bold;
}
.stat-item.graded {
  color: #67c23a;
  font-weight: bold;
}

/* 分数统计样式 */
.divider-wide {
  margin: 0 15px; /* 增加分隔线距离，区分两组数据 */
}
.score-stats {
  display: flex;
  align-items: center;
}

.score-text {
  font-family: "Arial", sans-serif;
  font-size: 16px;
  color: #ff69b4;
  font-weight: bold;
}

::v-deep .el-page-header__content {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}
</style>