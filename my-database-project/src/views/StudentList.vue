<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <!-- 自定义搜索组件 -->
        <expandable-search 
          v-model="searchKey" 
          placeholder="请输入姓名或学号..."
          @search="getStudents"
        ></expandable-search>
      </div>

      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal(null)"
        >添加学生</el-button
      >
    </div>

    <!-- 学生列表 -->
    <div v-if="hasStudent || loading">
      <el-table :data="tableData" style="width: 100%" stripe v-loading="loading">
        <el-table-column prop="studentId" label="学号" width="140" sortable><!-- sortable需要prop来进行排序 -->
          <template slot-scope="scope">
            <span style="font-family: monospace; font-weight: bold">
              {{ scope.row.studentId }}
            </span>
          </template>
        </el-table-column>

        <el-table-column prop="name" label="姓名" min-width="150">
          <template slot-scope="scope">
            <div style="display: flex; align-items: center">
              <el-avatar size="small" :src="scope.row.avatar" style="margin-right: 10px"></el-avatar>
              <span>{{ scope.row.name }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="gender" label="性别" width="80" align="center">
          <template slot-scope="scope">
            <i :class="scope.row.gender === '男' ? 'el-icon-male' : 'el-icon-female'"
              :style="{ color: scope.row.gender === '男' ? '#409EFF' : '#F56C6C', fontWeight: 'bold' }">
            </i>
          </template>
        </el-table-column>

        <el-table-column prop="major" label="专业" width="180">
          <template slot-scope="scope">
            <el-tag size="medium" effect="plain">{{ scope.row.major }}</el-tag>
          </template>
        </el-table-column>

        <!-- <el-table-column prop="phone" label="联系电话" width="150"></el-table-column> -->

        <el-table-column label="操作" width="180" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" icon="el-icon-edit" @click="openModal(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">退学</el-button>
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

    <el-empty v-else description="暂无学生信息，请添加或重新搜索">
      <el-button type="primary" size="small" @click="openModal(null)"
        >立即添加学生</el-button
      >
    </el-empty>
    <!-- 学生窗口 -->
    <student-modal
      :visible.sync="modalVisible" 
      :rowData="currentRow" 
      @success="handleSuccess"
    ></student-modal>
  </el-card>
</template>

<script>
import StudentModal from "@/components/modals/StudentModal.vue";
import ExpandableSearch from "@/components/features/ExpandableSearch.vue"; 

export default {
  name: "StudentList",
  components: {
    StudentModal,
    ExpandableSearch 
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
      total: 0
    };
  },
  computed: {
    hasStudent() {
      return (this.tableData && this.tableData.length > 0) || this.loading;
    },
  },
  methods: {
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
          role: 'teacher',
          query: this.searchKey,
          page: this.currentPage,
          pageSize: this.pageSize
        },
      }).then((result) => {
          const resData = result.data || result;
          this.tableData = resData.list || [];
          this.total = resData.total || 0;
        }).catch((err) => {
          console.error(err);
        }).finally(() => {
          this.loading = false;
        });
    },
    //删除学生
    handleDelete(row) {
      this.$confirm(`确认将学生 ${row.name} 删除吗?`, "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
          this.$api({
            apiType: "studentDelete",
            data: { id: row.studentId }, 
          }).then(() => {
            this.$message.success("删除成功");
            if (this.tableData.length === 1 && this.currentPage > 1) {
              this.currentPage--;
            }
            this.getStudents();
          });
        }).catch((error) => {
          if (error !== 'cancel') console.error(error);
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