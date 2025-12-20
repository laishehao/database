<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <ExpendableSearchVue
          v-model="searchKey"
          :placeholder="请输入课程信息"
          @search="getCourses"
        >
        </ExpendableSearchVue>
      </div>

      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal(null)"
        >新建课程</el-button
      >
    </div>

    <!-- 增加 v-loading -->
    <div v-if="hasCourse || loading">
      <el-table
        :data="tableData"
        style="width: 100%"
        border
        stripe
        v-loading="loading"
      >
        <el-table-column prop="courseId" label="课程号" width="120" sortable>
          <template slot-scope="scope">
            <el-tag type="info" size="mini" style="font-family: monospace">{{
              scope.row.courseId
            }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column
          prop="courseName"
          label="课程名称"
          min-width="180"
          show-overflow-tooltip
        >
          <template slot-scope="scope">
            <span style="font-weight: 600; color: #303133">{{
              scope.row.courseName
            }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="major" label="所属专业/学院" width="180">
          <template slot-scope="scope">
            <i
              class="el-icon-school"
              style="margin-right: 4px; color: #909399"
            ></i>
            <span>{{ scope.row.major }}</span>
          </template>
        </el-table-column>

        <el-table-column
          prop="credits"
          label="学分"
          width="80"
          align="center"
        ></el-table-column>

        <el-table-column prop="type" label="性质" width="100" align="center">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.type === '必修' ? 'danger' : 'success'"
              effect="dark"
              size="small"
            >
              {{ scope.row.type }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column
          prop="teacher"
          label="授课教师"
          width="120"
        ></el-table-column>

        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="openModal(scope.row)"
              >编辑</el-button
            >
            <el-button
              type="text"
              size="small"
              style="color: #f56c6c"
              @click="handleStop(scope.row)"
              >停开</el-button
            >
          </template>
        </el-table-column>
      </el-table>

      <!-- 完善的分页组件 -->
      <div style="margin-top: 20px; text-align: right">
        <el-pagination
          background
          layout="total, sizes, prev, pager, next, jumper"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50]"
          :page-size="pageSize"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        ></el-pagination>
      </div>
    </div>

    <el-empty v-else description="暂无课程信息">
      <el-button type="primary" size="small" @click="openModal(null)"
        >立即新建课程</el-button
      >
    </el-empty>

    <course-modal
      :visible.sync="modalVisible"
      :row-data="currentRow"
      @success="handleSuccess"
    ></course-modal>
  </el-card>
</template>

<script>
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
    // 删除/停开课程
    handleStop(row) {
      this.$confirm(`确认删除课程 ${row.courseName} 吗?`, "警告", {
        type: "warning",
        confirmButtonText: "确定停开",
        cancelButtonText: "取消",
      }).then(() => {
        this.$api({
          apiType: "courseDelete",
          data: { courseId: row.courseId },
        })
          .then(() => {
            this.$message.success("操作成功");
            // 如果删除的是当前页最后一条数据，且不是第一页，自动前翻
            if (this.tableData.length === 1 && this.currentPage > 1) {
              this.currentPage--;
            }
            this.getCourses();
          })
          .catch((err) => {
            console.error(err);
            this.$message.error("操作失败");
          });
      });
    },
  },
  created() {
    this.getCourses();
  },
};
</script>

<style scoped>
.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.filter-left {
  display: flex;
  align-items: center;
}
</style>