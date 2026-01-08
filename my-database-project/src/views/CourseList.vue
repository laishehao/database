<!--
 * @Description: 课程列表 - 老师管理课程的列表
-->
<template>
  <div class="cute-container">
    <!-- 背景装饰：漂浮的云朵和点缀 -->
    <div class="cloud cloud-1"></div>
    <div class="cloud cloud-2"></div>
    <div class="bg-pattern"></div>

    <el-card shadow="never" class="cute-card">
      <div slot="header" class="clearfix header-actions cute-header">
        <div class="filter-left">
          <!-- 标题装饰 -->
          <div class="cute-title">
            <span class="title-icon">🏰</span>
            <span class="title-text">课程管理</span>
          </div>
          <ExpendableSearchVue
            v-model="searchKey"
            placeholder="搜索神秘课程..."
            @search="getCourses"
            class="cute-search"
          >
          </ExpendableSearchVue>
        </div>

        <el-button
          class="cute-btn-primary"
          size="medium"
          icon="el-icon-magic-stick"
          @click="openModal(null)"
          round
          >召唤新课程</el-button
        >
      </div>

      <!-- 课程列表 -->
      <div v-if="hasCourse || loading" class="cute-table-wrapper">
        <el-table
          :data="tableData"
          style="width: 100%"
          class="cute-table"
          v-loading="loading"
          :header-cell-style="{
            background: '#FFF0F5',
            color: '#FF69B4',
            borderColor: '#FFE4E1',
          }"
        >
          <el-table-column
            prop="courseId"
            label="🎓 课程号"
            width="140"
            sortable
          >
            <template slot-scope="scope">
              <span class="cute-id-text">{{ scope.row.courseId }}</span>
            </template>
          </el-table-column>

          <el-table-column
            prop="courseName"
            label="✨ 课程名称"
            min-width="180"
            show-overflow-tooltip
          >
            <template slot-scope="scope">
              <span class="cute-course-name">{{ scope.row.courseName }}</span>
            </template>
          </el-table-column>

          <el-table-column prop="major" label="🎪 所属学院" width="180">
            <template slot-scope="scope">
              <div class="major-info">
                <i
                  class="el-icon-school"
                  style="margin-right: 6px; color: #ffb7c5"
                ></i>
                <span>{{ scope.row.major }}</span>
              </div>
            </template>
          </el-table-column>

          <el-table-column
            prop="credits"
            label="⭐ 学分"
            width="80"
            align="center"
          >
            <template slot-scope="scope">
              <span class="cute-credits">{{ scope.row.credits }}</span>
            </template>
          </el-table-column>

          <el-table-column
            prop="type"
            label="🏷️ 性质"
            width="100"
            align="center"
          >
            <template slot-scope="scope">
              <el-tag
                :class="
                  scope.row.type === '必修'
                    ? 'cute-tag-danger'
                    : 'cute-tag-success'
                "
                effect="light"
                size="small"
              >
                {{ scope.row.type }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column prop="teacher" label="🧙‍♂️ 导师" width="120">
            <template slot-scope="scope">
              <span style="color: #6b4c56; font-weight: 500">{{
                scope.row.teacher
              }}</span>
            </template>
          </el-table-column>

          <el-table-column label="💖 操作" width="200" fixed="right">
            <template slot-scope="scope">
              <div class="action-btn-group">
                <el-button
                  type="text"
                  size="small"
                  class="action-btn btn-edit"
                  @click="openModal(scope.row)"
                  >编辑</el-button
                >
                <el-button
                  type="text"
                  size="small"
                  class="action-btn btn-stop"
                  @click="handleCheck(scope.row)"
                  >查看学生</el-button
                >
                <el-button
                  type="text"
                  size="small"
                  class="action-btn btn-stop"
                  @click="handleStop(scope.row)"
                  >停开</el-button
                >
              </div>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页组件 -->
        <div class="cute-pagination-wrapper">
          <el-pagination
            background
            layout="prev, pager, next"
            :current-page="currentPage"
            :page-sizes="[10, 20, 50]"
            :page-size="pageSize"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            class="cute-pagination"
          ></el-pagination>
        </div>
      </div>

      <!-- 空状态 -->
      <el-empty v-else description="还没有课程安排哦~" class="cute-empty">
        <template slot="image">
          <div class="empty-icon">🎠</div>
        </template>
        <el-button
          class="cute-btn-primary"
          size="small"
          round
          @click="openModal(null)"
          >立即召唤</el-button
        >
      </el-empty>
    </el-card>

    <!-- 
        弹窗组件 
        【重要】移出 el-card 防止被 overflow:hidden 遮挡或 z-index 问题 
    -->
    <course-modal
      :visible.sync="modalVisible"
      :row-data="currentRow"
      @success="handleSuccess"
    ></course-modal>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import CourseModal from "@/components/modals/CourseModal.vue";
import ExpendableSearchVue from "@/components/features/ExpandableSearch.vue";

export default {
  name: "CourseList",
  components: {
    CourseModal,
    ExpendableSearchVue,
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      currentRow: null,
      loading: false, // 加载状态
      tableData: [], // 初始化为空，由 API 获取
      // 分页配置
      currentPage: 1,
      pageSize: 10,
      total: 0,
    };
  },
  computed: {
    hasCourse() {
      // 只要有数据或者正在加载中，都显示表格结构
      return (this.tableData && this.tableData.length > 0) || this.loading;
    },
    ...mapGetters(["userInfo"]),
  },
  methods: {
    openModal(row) {
      this.currentRow = row;
      this.modalVisible = true;
    },
    handleSuccess() {
      this.getCourses();
    },
    // 搜索处理：重置到第一页
    handleSearch() {
      this.currentPage = 1;
      this.getCourses();
    },
    // 获取课程列表
    getCourses() {
      this.loading = true;
      this.$api({
        apiType: "course",
        data: {
          role: "teacher",
          Tno: this.userInfo.id,
          query: this.searchKey,
          page: this.currentPage,
          pageSize: this.pageSize,
        },
      })
        .then((result) => {
          // 兼容处理：支持直接返回 list 或 { data: { list... } }
          const resData = result.data || result;
          this.tableData = resData.list || [];
          this.total = resData.total || 0;
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          this.loading = false;
        });
    },
    // 处理每页条数变化
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.getCourses();
    },
    // 处理页码变化
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getCourses();
    },
    // 查看学生
    handleCheck(row) {
      this.$router.push({
        name: "student",
        params: { courseId: row.courseId },
      });
    },
    // 删除停开课程
    handleStop(row) {
      this.$confirm(`真的要封印 ${row.courseName} 课程吗? (QAQ)`, "封印警告", {
        type: "warning",
        confirmButtonText: "封印它",
        cancelButtonText: "手下留情",
        confirmButtonClass: "el-button--danger is-plain",
        cancelButtonClass: "el-button--primary is-plain",
      })
        .then(() => {
          this.$api({
            apiType: "courseDelete",
            data: { courseId: row.courseId, Tno: this.userInfo.id },
          })
            .then(() => {
              this.$message.success("封印成功~");
              // 如果删除的是当前页最后一条数据，且不是第一页，自动前翻
              if (this.tableData.length === 1 && this.currentPage > 1) {
                this.currentPage--;
              }
              this.getCourses();
            })
            .catch((err) => {
              console.error(err);
              this.$message.error("封印失败了...");
            });
        })
        .catch(() => {
          // 捕获取消操作，防止控制台报错
        });
    },
  },
  created() {
    this.getCourses();
  },
};
</script>

<style scoped>
/* 少女心风格变量 */
.cute-container {
  --cute-pink: #ffb7c5;
  --cute-dark-pink: #ff69b4;
  --cute-bg: #fff5f7;
  --cute-white: #ffffff;
  --cute-text: #6b4c56; /* 巧克力色文字 */
  --cute-border: #ffe4e1;
  --cute-shadow: 0 8px 16px rgba(255, 182, 193, 0.4);

  font-family: "Muli", "Rounded Mplus 1c", "Varela Round", sans-serif;
  background-color: var(--cute-bg);
  min-height: 100%;
  padding: 20px;
  position: relative;
  overflow: hidden;
  color: var(--cute-text);
}

/* 背景波点图案 */
.bg-pattern {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: radial-gradient(#ffdee9 15%, transparent 16%),
    radial-gradient(#ffdee9 15%, transparent 16%);
  background-size: 30px 30px;
  background-position: 0 0, 15px 15px;
  opacity: 0.5;
  z-index: 0;
}

/* 装饰云朵 */
.cloud {
  position: absolute;
  background: white;
  border-radius: 50px;
  z-index: 1;
  opacity: 0.8;
  animation: float 6s ease-in-out infinite;
}
.cloud::after,
.cloud::before {
  content: "";
  position: absolute;
  background: white;
  border-radius: 50%;
}
.cloud-1 {
  width: 100px;
  height: 40px;
  top: 5%;
  right: 10%;
}
.cloud-1::after {
  width: 50px;
  height: 50px;
  top: -25px;
  left: 15px;
}
.cloud-1::before {
  width: 40px;
  height: 40px;
  top: -15px;
  right: 15px;
}

.cloud-2 {
  width: 80px;
  height: 30px;
  bottom: 10%;
  left: 5%;
  animation-duration: 8s;
  animation-delay: 2s;
}
.cloud-2::after {
  width: 40px;
  height: 40px;
  top: -20px;
  left: 10px;
}
.cloud-2::before {
  width: 30px;
  height: 30px;
  top: -10px;
  right: 10px;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* 主卡片 */
.cute-card {
  position: relative;
  z-index: 2;
  background: rgba(255, 255, 255, 0.95);
  border: 4px solid white;
  border-radius: 25px;
  box-shadow: var(--cute-shadow);
}

/* 头部样式 */
.cute-header {
  border-bottom: 2px dashed var(--cute-border);
  padding-bottom: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.filter-left {
  display: flex;
  align-items: center;
}

.cute-title {
  display: flex;
  align-items: center;
  margin-right: 20px;
}
.title-icon {
  font-size: 28px;
  margin-right: 8px;
  animation: shake 3s infinite;
}
.title-text {
  font-size: 20px;
  font-weight: bold;
  color: var(--cute-dark-pink);
  text-shadow: 2px 2px 0px #fff0f5;
}

@keyframes shake {
  0%,
  100% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(-10deg);
  }
  75% {
    transform: rotate(10deg);
  }
}

/* 搜索框 */
.cute-search {
  margin-right: 15px;
}
::v-deep .cute-search .el-input__inner {
  border-radius: 20px;
  border: 2px solid var(--cute-border);
  color: var(--cute-text);
  padding-left: 15px;
}
::v-deep .cute-search .el-input__inner:focus {
  border-color: var(--cute-dark-pink);
  box-shadow: 0 0 0 3px rgba(255, 105, 180, 0.2);
}

/* 主按钮 */
.cute-btn-primary {
  background: linear-gradient(135deg, #ffb6c1 0%, #ff69b4 100%);
  border: none;
  font-weight: bold;
  box-shadow: 0 4px 10px rgba(255, 105, 180, 0.4);
  transition: all 0.3s;
}
.cute-btn-primary:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 6px 15px rgba(255, 105, 180, 0.6);
}

/* 表格样式 */
.cute-table-wrapper {
  margin-top: 10px;
}
::v-deep .cute-table {
  border-radius: 15px;
  overflow: hidden;
}
::v-deep .cute-table th {
  font-size: 15px;
  padding: 15px 0;
}
::v-deep .cute-table td {
  border-bottom: 1px dashed var(--cute-border);
  padding: 12px 0;
}
::v-deep .el-table--striped .el-table__body tr.el-table__row--striped td {
  background: #fff9fb;
}
::v-deep .el-table--enable-row-hover .el-table__body tr:hover > td {
  background-color: #fff0f5 !important;
}

/* 表格特定元素 */
.cute-id-text {
  font-family: monospace;
  font-weight: bold;
  color: #6b4c56;
  background: #fff0f5;
  padding: 2px 6px;
  border-radius: 4px;
}
.cute-course-name {
  font-weight: bold;
  color: #6b4c56;
  font-size: 15px;
}
.cute-credits {
  font-weight: bold;
  color: #ff69b4;
  background: #fff0f5;
  width: 24px;
  height: 24px;
  display: inline-block;
  border-radius: 50%;
  line-height: 24px;
}

/* 标签样式 */
.cute-tag-danger {
  background-color: #fff0f5 !important;
  border-color: #ffb6c1 !important;
  color: #ff69b4 !important;
  border-radius: 12px;
  font-weight: bold;
}
.cute-tag-success {
  background-color: #e0f7fa !important;
  border-color: #b2ebf2 !important;
  color: #00bcd4 !important;
  border-radius: 12px;
  font-weight: bold;
}

/* 操作按钮 */
.action-btn-group {
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 4px;
}
.action-btn {
  font-weight: bold;
  border-radius: 12px;
  padding: 5px 10px;
  transition: all 0.2s;
  border: none;
}
.action-btn:hover {
  background-color: #fff0f5;
  transform: scale(1.05);
}
.btn-edit {
  color: #87ceeb;
  background: transparent;
}
.btn-stop {
  color: #ffb7c5;
  background: transparent;
}

/* 分页 */
.cute-pagination-wrapper {
  margin-top: 25px;
  text-align: center;
}
::v-deep .cute-pagination .el-pager li {
  background: white;
  border: 2px solid var(--cute-border);
  border-radius: 50% !important;
  color: var(--cute-text);
  font-weight: bold;
  min-width: 32px;
  height: 32px;
  line-height: 28px;
  margin: 0 3px;
}
::v-deep .cute-pagination .el-pager li.active {
  background-color: var(--cute-pink);
  border-color: var(--cute-pink);
  color: white;
}
::v-deep .cute-pagination .btn-prev,
::v-deep .cute-pagination .btn-next {
  background: white;
  border-radius: 50%;
  border: 2px solid var(--cute-border);
  color: var(--cute-pink);
}

/* 空状态 */
.cute-empty {
  padding: 40px 0;
}
.empty-icon {
  font-size: 60px;
  margin-bottom: 10px;
  animation: bounce 2s infinite;
}
@keyframes bounce {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}
</style>