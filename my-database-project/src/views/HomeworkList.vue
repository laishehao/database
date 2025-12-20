<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <!-- 使用通用搜索组件 -->
        <expandable-search 
          v-model="searchKey" 
          placeholder="搜索作业名称..."
          @search="handleSearch"
        ></expandable-search>
      </div>
      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal(null)"
        >发布作业</el-button
      >
    </div>
    <!-- 作业列表 -->
    <div v-if="hasHomework">
      <el-table :data="tableData" style="width: 100%" stripe v-loading="loading">
        <el-table-column prop="title" label="作业名称" min-width="180">
          <template slot-scope="scope">
            <span style="font-weight: 500;">{{ scope.row.title }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="course" label="课程">
          <template slot-scope="scope">
            <el-tag size="medium" effect="plain">{{ scope.row.course }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="提交进度" width="200">
          <template slot-scope="scope">
            <el-progress :percentage="scope.row.progress" :status="scope.row.progress === 100 ? 'success' : null"></el-progress>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100">
            <template slot-scope="scope">
              <span :style="{color: scope.row.progress === 100 ? '#67C23A' : '#909399', fontWeight: 'bold'}">
                ● {{ scope.row.progress < 100 ? '进行中' : '已结束' }}
              </span>
            </template>
        </el-table-column>

        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" style="color: blue" @click="handleGrade(scope.row)">批改</el-button>
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" style="color: #F56C6C" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 分页组件 -->
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
    <!-- 暂无作业 -->
    <el-empty v-else description="暂无作业数据">
      <el-button type="primary" size="small" @click="openModal(null)"
        >立即发布作业</el-button
      >
    </el-empty>

    <homework-modal
      :visible.sync="modalVisible"
      :row-data="currentRow"
      @success="handleSuccess"
    ></homework-modal>
  </el-card>
</template>

<script>
import HomeworkModal from "@/components/modals/HomeworkModal.vue";
import ExpandableSearch from "@/components/features/ExpandableSearch.vue"; 

export default {
  name: "HomeworkList",
  components: {
    HomeworkModal,
    ExpandableSearch 
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      loading: false,
      tableData: [],
      currentRow: null,
      currentPage: 1,     //当前页码
      pageSize: 10,     //每页展示的数据条数
      total: 0        //符合条件的结果总数
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    //row如果为null就是新增, 如果有内容就是编辑窗口
    openModal(row = null) {
      this.currentRow = row;
      this.modalVisible = true;
    },
    //打开编辑窗口
    handleEdit(row) {
      this.openModal(row);
    },
    //提交表单成功回调函数
    handleSuccess() {
      this.getHomework();
    },
    // 处理搜索事件
    handleSearch() {
      this.currentPage = 1;
      this.getHomework();
    },
    //批改作业
    handleGrade(row) {
      this.$router.push({
        name:'homeworkGrading',
        params: {
          id: row.id
        }
      })
    },
    //获取作业列表
    getHomework() {
      this.loading = true;
      this.$api({
        apiType: "homework",
        data: { 
          role: 'teacher', 
          query: this.searchKey, 
          page: this.currentPage, 
          pageSize: this.pageSize
        },
      }).then((result) => {
          const list = result.list || (result.data && result.data.list) || [];
          const total = result.total || (result.data && result.data.total) || list.length;
          
          this.tableData = list;
          this.total = total;
        }).catch((err) => {
          console.error(err);
        }).finally(() => {
          this.loading = false;
        });
    },
    //删除作业
    handleDelete(row) {
      this.$confirm(`确认删除作业 ${row.title} 吗?`, "提示", {
        type: "warning",
      }).then(() => {
        this.$api({
          apiType: "homeworkDelete",
          data: { id: row.id }, 
        }).then(() => {
          this.$message.success("删除成功");
          if (this.tableData.length === 1 && this.currentPage > 1) {
            this.currentPage--;
          }
          this.getHomework();
        });
      });
    },
    //以下两个函数都是绑定在分页组件上的
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.getHomework();
    },
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getHomework();
    }
  },
  created() {
    this.getHomework();
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