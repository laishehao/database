<!--
 * @Description: 教师作业列表 - 粉嫩少女萌系风格版 (修复 Promise 捕获问题)
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
          <!-- 标题装饰：带图标的可爱标题 -->
          <div class="cute-title">
            <span class="title-icon">🎀</span>
            <span class="title-text">作业管理</span>
          </div>
          <!-- 搜索框 -->
          <expandable-search
            v-model="searchKey"
            placeholder="搜搜看今天要做什么..."
            @search="handleSearch"
            class="cute-search"
          ></expandable-search>
        </div>

        <el-button
          class="cute-btn-primary"
          size="medium"
          icon="el-icon-magic-stick"
          @click="openModal(null)"
          round
          >发布新任务</el-button
        >
      </div>

      <!-- 作业列表 -->
      <div v-if="hasHomework" class="cute-table-wrapper">
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
          <el-table-column prop="title" label="✨ 作业名称" min-width="180">
            <template slot-scope="scope">
              <span class="cute-text-title">{{ scope.row.title }}</span>
            </template>
          </el-table-column>

          <el-table-column prop="course" label="🍰 所属课程">
            <template slot-scope="scope">
              <el-tag size="medium" class="cute-tag" effect="light">
                <i class="el-icon-collection-tag"></i> {{ scope.row.course }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column label="📅 提交进度" width="220">
            <template slot-scope="scope">
              <div class="progress-box">
                <el-progress
                  :percentage="scope.row.progress"
                  :stroke-width="14"
                  :color="customColors"
                  class="cute-progress"
                  :show-text="false"
                ></el-progress>
                <span class="progress-txt">{{ scope.row.progress }}%</span>
              </div>
            </template>
          </el-table-column>

          <el-table-column label="🍓 状态" width="120">
            <template slot-scope="scope">
              <div
                :class="[
                  'status-badge',
                  scope.row.progress < 100 ? 'status-ing' : 'status-done',
                ]"
              >
                {{ scope.row.progress < 100 ? "进行中~" : "已完结" }}
              </div>
            </template>
          </el-table-column>

          <el-table-column label="💖 操作" width="200" fixed="right">
            <template slot-scope="scope">
              <el-button
                type="text"
                size="small"
                class="action-btn btn-grade"
                @click="handleGrade(scope.row)"
              >
                批改
              </el-button>
              <el-button
                type="text"
                size="small"
                class="action-btn btn-edit"
                @click="handleEdit(scope.row)"
              >
                编辑
              </el-button>
              <el-button
                type="text"
                size="small"
                class="action-btn btn-delete"
                @click="handleDelete(scope.row)"
              >
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页组件 -->
        <div class="cute-pagination-wrapper">
          <el-pagination
            background
            layout="prev, pager, next"
            :current-page="currentPage"
            :page-size="pageSize"
            :total="total"
            @current-change="handleCurrentChange"
            class="cute-pagination"
          ></el-pagination>
        </div>
      </div>

      <!-- 暂无作业 -->
      <el-empty v-else description="空空如也哦~" class="cute-empty">
        <template slot="image">
          <div class="empty-icon">🐰</div>
        </template>
        <el-button
          class="cute-btn-primary"
          size="small"
          round
          @click="openModal(null)"
        >
          去发布第一个任务吧
        </el-button>
      </el-empty>
    </el-card>

    <!-- 弹窗组件 -->
    <!-- 要把modal移出el-card防止被overflow:hidden遮挡或z-index问题 -->
    <homework-modal
      :visible.sync="modalVisible"
      :row-data="currentRow"
      @success="handleSuccess"
    ></homework-modal>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import HomeworkModal from "@/components/modals/HomeworkModal.vue";
import ExpandableSearch from "@/components/features/ExpandableSearch.vue";

export default {
  name: "HomeworkList",
  components: {
    HomeworkModal,
    ExpandableSearch,
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      loading: false,
      tableData: [],
      currentRow: null,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      customColors: [
        { color: "#FFB6C1", percentage: 20 },
        { color: "#FFC0CB", percentage: 40 },
        { color: "#DDA0DD", percentage: 60 },
        { color: "#87CEEB", percentage: 80 },
        { color: "#98FB98", percentage: 100 },
      ],
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
    ...mapGetters(["userInfo"]),
  },
  methods: {
    openModal(row = null) {
      this.currentRow = row;
      //this.currentRow = row ? Object.assign({}, row, { workId: row.id }) : null;
      this.modalVisible = true;
    },
    handleEdit(row) {
      this.openModal(row);
    },
    handleSuccess() {
      this.getHomework();
    },
    handleSearch() {
      this.currentPage = 1;
      this.getHomework();
    },
    handleGrade(row) {
      if (!row) return;
      this.$router.push({
        name: "homeworkGrading",
        params: { workId: row.workId || row.id },
      });
    },
    getHomework() {
      this.loading = true;
      this.$api({
        apiType: "homework",
        data: {
          role: this.userInfo.role,
          id: this.userInfo.id,
          query: this.searchKey,
          page: this.currentPage,
          pageSize: this.pageSize,
        },
      })
        .then((result) => {
          const list = result.list || (result.data && result.data.list) || [];
          const total =
            result.total || (result.data && result.data.total) || list.length;
          this.tableData = list;
          this.total = total;
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          this.loading = false;
        });
    },
    handleDelete(row) {
      this.$confirm(
        `要让 "${row.title}" 消失嘛？(｡•́︿•̀｡)`,
        "这是个严肃的提示",
        {
          confirmButtonText: "狠心删除",
          cancelButtonText: "留着吧",
          type: "warning",
          confirmButtonClass: "el-button--danger is-plain",
          cancelButtonClass: "el-button--primary is-plain",
        }
      )
        .then(() => {
          // 用户点击“狠心删除”
          this.$api({
            apiType: "homeworkDelete",
            data: { workId: row.workId },
          })
            .then(() => {
              this.$message.success("虽然不舍，但已经删掉啦~");
              if (this.tableData.length === 1 && this.currentPage > 1) {
                this.currentPage--;
              }
              this.getHomework();
            })
            .catch(() => {
              // 【修复】捕获用户点击“留着吧”或“叉号”的操作，防止抛出未捕获异常
            });
        })
        .catch(() => {
          // 【修复】捕获用户点击“留着吧”或“叉号”的操作，防止抛出未捕获异常
        });
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.getHomework();
    },
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getHomework();
    },
  },
  created() {
    this.getHomework();
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
  --cute-text: #6b4c56;
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

.cute-card {
  position: relative;
  z-index: 2;
  background: rgba(255, 255, 255, 0.95);
  border: 4px solid white;
  border-radius: 25px;
  box-shadow: var(--cute-shadow);
}

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

.cute-text-title {
  font-weight: bold;
  color: #6b4c56;
}
.cute-tag {
  background-color: #e0f7fa;
  border-color: #b2ebf2;
  color: #00bcd4;
  border-radius: 12px;
  font-weight: bold;
}

.progress-box {
  display: flex;
  align-items: center;
}
.cute-progress {
  flex: 1;
  margin-right: 8px;
}
.progress-txt {
  font-size: 12px;
  font-weight: bold;
  color: #ff69b4;
  background: #fff0f5;
  padding: 2px 6px;
  border-radius: 10px;
}
::v-deep .el-progress-bar__outer,
::v-deep .el-progress-bar__inner {
  border-radius: 10px;
}

.status-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
}
.status-ing {
  background-color: #fff3e0;
  color: #ff9800;
  border: 1px solid #ffe0b2;
}
.status-done {
  background-color: #e8f5e9;
  color: #4caf50;
  border: 1px solid #c8e6c9;
}

.action-btn {
  font-weight: bold;
  border-radius: 12px;
  padding: 5px 10px;
  transition: all 0.2s;
}
.action-btn:hover {
  background-color: #fff0f5;
}
.btn-grade {
  color: #87ceeb;
}
.btn-edit {
  color: #dda0dd;
}
.btn-delete {
  color: #ffb7c5;
}

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