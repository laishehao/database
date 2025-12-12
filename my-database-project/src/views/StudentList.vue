<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <el-input
          v-model="searchKey"
          placeholder="请输入姓名或学号"
          prefix-icon="el-icon-search"
          size="small"
          style="width: 240px; margin-right: 10px"
          clearable
          @keyup.enter.native="getStudents"
          @clear="getStudents"
        ></el-input>
        <el-button type="primary" size="small" icon="el-icon-plus" @click="getStudents">搜索</el-button>
      </div>
      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal(null)"
        >添加学生</el-button
      >
    </div>

    <div v-if="hasStudent">
      <el-table :data="tableData" style="width: 100%" stripe>
        <el-table-column prop="studentId" label="学号" width="140" sortable>
          <template slot-scope="scope">
            <span style="font-family: monospace; font-weight: bold">
              {{ scope.row.studentId }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="姓名" min-width="150">
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

        <el-table-column prop="phone" label="联系电话" width="150"></el-table-column>

        <el-table-column label="操作" width="180" fixed="right">
          <template slot-scope="scope">
            <el-button size="mini" icon="el-icon-edit" @click="openModal(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">退学</el-button>
          </template>
        </el-table-column>

      </el-table>

      <div style="margin-top: 20px; text-align: right">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="100"
        ></el-pagination>
      </div>
    </div>

    <el-empty v-else description="暂无学生信息，请添加或重新搜索">
      <el-button type="primary" size="small" @click="openModal(null)"
        >立即添加学生</el-button
      >
    </el-empty>

    <StudentModal
      :visible.sync="modalVisible" 
      :rowData="currentRow" 
      @success="handleSuccess"
    ></StudentModal>
  </el-card>
</template>

<script>
import StudentModal from "@/components/StudentModal.vue";

export default {
  name: "StudentList",
  components: {
    StudentModal,
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      currentRow: null,
      tableData: [
        {
          studentId: "2023001",
          name: "王小明",
          gender: "男",
          major: "计算机科学",
          phone: "13812345678",
          avatar:
            "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png",
        },
        {
          "studentId": "2023002",
          "name": "李清照",
          "gender": "女",
          "major": "外国语学院",
          "phone": "13987654321",
          "avatar": "https://cube.elemecdn.com/9/c2/f0ee8444e8777e4ad9d5b4104d55eapng.png"
        },
        {
          "studentId": "2023003",
          "name": "张子凡",
          "gender": "男",
          "major": "数学院",
          "phone": "13700010002",
          "avatar": "" // 测试默认头像情况
        },
      ],
    };
  },
  computed: {
    hasStudent() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    //展示窗口
    openModal(row) {
      this.currentRow = row;
      this.modalVisible = true;
    },
    // 添加学生信息
    handleSuccess() {
      // 重新调用接口获取最新列表，确保数据与后端一致
      // 如果后端没有返回 ID 或其他自动生成的字段，仅仅 push 到前端数组是不够严谨的
      this.tableData = []; // 可选：清空当前数据会有 loading 效果
      this.getStudents();
    },
    getStudents() {
      this.$api({
        apiType: "student",
        data: {
          query: this.searchKey, // 假设后端接收的参数名是 query
          page: 1,
          pageSize: 15
        },
      }).then((result) => {
          this.tableData = result?.list || this.tableData;
        }).catch((err) => {
          console.error(err);
        });
    },
    handleDelete(row) {
      this.$confirm(`确认将学生 ${row.name} 删除吗?`, "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
          // 调用删除接口
          this.$api({
            apiType: "studentDelete",
            data: { id: row.studentId }, //对应 api.config.js 中 url 的 '/student/:id'
          }).then(() => {
            this.$message.success("删除成功");
            this.getStudents(); // 刷新列表
          });
        }).catch((error) => {
          console.error(error);
        });
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