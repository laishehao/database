<!--
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 20:26:04
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 21:43:35
 * @Description: 作业列表管理
-->
<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <el-input
          v-model="searchKey"
          placeholder="搜索作业名称"
          prefix-icon="el-icon-search"
          size="small"
          style="width: 200px; margin-right: 10px"
          clearable
          @keyup.enter.native="getHomework"
          @clear="getHomework"
        ></el-input>
        <el-button
          type="primary"
          size="small"
          icon="el-icon-search"
          @click="getHomework"
          >查询</el-button
        >
      </div>
      <!-- 点击发布时传 null，表示新增 -->
      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal(null)"
        >发布作业</el-button
      >
    </div>

    <div v-if="hasHomework">
      <el-table :data="tableData" style="width: 100%" stripe>
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
              <span :style="{color: scope.row.active ? '#67C23A' : '#909399', fontWeight: 'bold'}">
                ● {{ scope.row.active ? '进行中' : '已结束' }}
              </span>
            </template>
        </el-table-column>

        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <!-- 新增编辑按钮 -->
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" style="color: #F56C6C" @click="handleDelete(scope.row)">删除</el-button>
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

    <el-empty v-else description="暂无作业数据">
      <el-button type="primary" size="small" @click="openModal(null)"
        >立即发布作业</el-button
      >
    </el-empty>

    <!-- 传入 row-data 以支持回显 -->
    <homework-modal
      :visible.sync="modalVisible"
      :row-data="currentRow"
      @success="handleSuccess"
    ></homework-modal>
  </el-card>
</template>

<script>
import HomeworkModal from "@/components/HomeworkModal.vue";

export default {
  name: "HomeworkList",
  components: {
    HomeworkModal,
  },
  data() {
    return {
      searchKey: "",
      modalVisible: false,
      tableData: [],
      currentRow: null 
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    // 修改 openModal，接收 row 参数
    openModal(row = null) {
      this.currentRow = row;
      this.modalVisible = true;
    },
    handleEdit(row) {
      this.openModal(row);
    },
    handleSuccess() {
      this.getHomework();
    },
    // 获取Homework列表
    getHomework() {
      this.$api({
        apiType: "homework",
        data: { role: 'teacher', query: this.searchKey, page: 1, pageSize: 10},
      }).then((result) => {
          this.tableData = result.list || this.tableData;
        }).catch((err) => {
          console.error(err);
        });
    },
    // 删除作业
    handleDelete(row) {
      this.$confirm(`确认删除作业 ${row.title} 吗?`, "提示", {
        type: "warning",
      }).then(() => {
        this.$api({
          apiType: "homeworkDelete",
          // 注意：这里参数应该是 id 对应 restful 的 :id
          data: { id: row.id }, 
        }).then(() => {
          this.$message.success("删除成功");
          this.getHomework();
        });
      });
    },
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