<!--
 * @Description: 学生列表
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
          <!-- 返回按钮 -->
          <el-button
            class="back-btn"
            icon="el-icon-arrow-left"
            circle
            size="small"
            @click="goBack"
            title="返回课程列表"
          ></el-button>

          <!-- 标题装饰 -->
          <div class="cute-title">
            <span class="title-icon">🦄</span>
            <span class="title-text">学生管理</span>
          </div>
          <!-- 自定义搜索组件 -->
          <expandable-search
            v-model="searchKey"
            placeholder="寻找哪位小可爱..."
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
          >召唤新同学</el-button
        >
      </div>

      <!-- 学生列表 -->
      <div v-if="hasStudent || loading" class="cute-table-wrapper">
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
            prop="studentId"
            label="🎓 学号"
            width="160"
            sortable
          >
            <template slot-scope="scope">
              <span class="cute-id-text">
                {{ scope.row.studentId }}
              </span>
            </template>
          </el-table-column>

          <el-table-column prop="name" label="🌸 姓名" min-width="160">
            <template slot-scope="scope">
              <div class="student-info">
                <!-- <el-avatar size="small" :src="scope.row.avatar" class="cute-avatar"></el-avatar> -->
                <span class="cute-name">{{ scope.row.name }}</span>
              </div>
            </template>
          </el-table-column>

          <el-table-column
            prop="gender"
            label="🌈 性别"
            width="100"
            align="center"
          >
            <template slot-scope="scope">
              <div class="gender-icon-box">
                <i
                  :class="
                    scope.row.gender === '男'
                      ? 'el-icon-male'
                      : 'el-icon-female'
                  "
                  :style="{
                    color: scope.row.gender === '男' ? '#87CEEB' : '#FF69B4',
                    fontWeight: 'bold',
                    fontSize: '16px',
                  }"
                >
                </i>
              </div>
            </template>
          </el-table-column>

          <el-table-column prop="major" label="📚 专业" width="200">
            <template slot-scope="scope">
              <el-tag size="medium" class="cute-tag" effect="light">
                {{ scope.row.major }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column label="💖 操作" width="180" fixed="right">
            <template slot-scope="scope">
              <el-button
                size="mini"
                class="action-btn btn-edit"
                icon="el-icon-view"
                @click="openModal(scope.row)"
              >
                查看
              </el-button>
              <el-button
                size="mini"
                class="action-btn btn-delete"
                icon="el-icon-delete"
                @click="handleDelete(scope.row)"
              >
                退学
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

      <!-- 空状态 -->
      <el-empty v-else description="还没有同学报到哦~" class="cute-empty">
        <template slot="image">
          <div class="empty-icon">🧸</div>
        </template>
        <el-button
          class="cute-btn-primary"
          size="small"
          round
          @click="openModal(null)"
        >
          立即添加
        </el-button>
      </el-empty>
    </el-card>

    <!-- 
      学生窗口 
      【重要】移出 el-card 防止被 overflow:hidden 遮挡或 z-index 问题
    -->
    <student-modal
      :visible.sync="modalVisible"
      :rowData="currentRow"
      @success="handleSuccess"
    ></student-modal>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import StudentModal from "@/components/modals/StudentModal.vue";
import ExpandableSearch from "@/components/features/ExpandableSearch.vue";

export default {
  name: "StudentList",
  components: {
    StudentModal,
    ExpandableSearch,
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      currentRow: null,
      tableData: [],
      loading: false,
      currentPage: 1,
      pageSize: 10,
      total: 0,
    };
  },
  computed: {
    hasStudent() {
      return (this.tableData && this.tableData.length > 0) || this.loading;
    },
    ...mapGetters(["userInfo"]),
  },
  methods: {
    // 返回上一页
    goBack() {
      this.$router.go(-1);
    },
    //打开学生窗口
    openModal(row = null) {
      this.currentRow = row;
      this.modalVisible = true;
    },
    //提交学生表单成功的回调函数
    handleSuccess() {
      this.getStudents();
    },
    // handleSearch 仅保留作为重置页码的逻辑，供组件 @search 调用
    handleSearch() {
      this.currentPage = 1;
      this.getStudents();
    },
    //获取学生列表
    getStudents() {
      this.loading = true;
      this.$api({
        apiType: "student",
        data: {
          role: this.userInfo.role,
          id: this.userInfo.id,
          Cno: this.$route.params.courseId,
          query: this.searchKey,
          page: this.currentPage,
          pageSize: this.pageSize,
        },
      })
        .then((result) => {
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
    //删除学生
    handleDelete(row) {
      this.$confirm(`真的要让 ${row.name} 同学退学吗? (QAQ)`, "退学警告", {
        confirmButtonText: "狠心确定",
        cancelButtonText: "再想想",
        type: "warning",
        confirmButtonClass: "el-button--danger is-plain",
        cancelButtonClass: "el-button--primary is-plain",
      })
        .then(() => {
          this.$api({
            apiType: "studentDelete",
            data: {
              studentId: row.studentId,
              Cno: this.$route.params.courseId,
            },
          }).then(() => {
            this.$message.success("删除成功~");
            if (this.tableData.length === 1 && this.currentPage > 1) {
              this.currentPage--;
            }
            this.getStudents();
          });
        })
        .catch((error) => {
          if (error !== "cancel") console.error(error);
        });
    },
    //以下两个函数用于分页组件
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.getStudents();
    },
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getStudents();
    },
  },
  created() {
    this.getStudents();
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

/* 返回按钮 */
.back-btn {
  margin-right: 15px;
  border: 2px solid var(--cute-border);
  color: var(--cute-dark-pink);
  font-weight: bold;
  background: white;
  transition: all 0.3s;
}
.back-btn:hover {
  background-color: #fff0f5;
  border-color: var(--cute-dark-pink);
  transform: scale(1.1);
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
.student-info {
  display: flex;
  align-items: center;
}
.cute-avatar {
  margin-right: 10px;
  border: 2px solid #ffb6c1;
}
.cute-name {
  font-weight: bold;
  color: #6b4c56;
}
.cute-tag {
  background-color: #e6e6fa;
  border-color: #d8bfd8;
  color: #9370db;
  border-radius: 12px;
  font-weight: bold;
}

/* 操作按钮 */
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
.btn-delete {
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