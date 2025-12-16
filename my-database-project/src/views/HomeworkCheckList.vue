<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 00:57:59
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 13:32:00
 * @FilePath: \my-database-project\src\views\HomeworkCheckList.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <!-- 移除了发布按钮 -->
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
        >查询</el-button>
      </div>
    </div>

    <div v-if="hasHomework">
      <el-table :data="tableData" style="width: 100%" stripe>
        <!-- 1. 作业名称 -->
        <el-table-column prop="title" label="作业名称" min-width="180">
          <template slot-scope="scope">
            <span style="font-weight: 500;">{{ scope.row.title }}</span>
          </template>
        </el-table-column>

        <!-- 2. 课程 -->
        <el-table-column prop="course" label="课程">
          <template slot-scope="scope">
            <el-tag size="medium" effect="plain">{{ scope.row.course }}</el-tag>
          </template>
        </el-table-column>

        <!-- 3. 状态 -->
        <el-table-column label="状态" width="120">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.completed ? 'success' : 'warning'"
              size="small"
              effect="dark"
            >
              {{ scope.row.completed ? '已完成' : '未完成' }}
            </el-tag>
          </template>
        </el-table-column>

        <!-- 4. 操作 -->
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="text" 
              size="small" 
              icon="el-icon-view" 
              @click="handleView(scope.row)"
            >查看</el-button>
            
            <!-- 确认完成按钮：如果已完成则禁用或隐藏 -->
            <el-button 
              type="text" 
              size="small" 
              icon="el-icon-check"
              :disabled="scope.row.completed"
              :style="{ color: scope.row.completed ? '#909399' : '#67C23A' }"
              @click="handleComplete(scope.row)"
            >
              {{ scope.row.completed ? '已完成' : '确认完成' }}
            </el-button>
          </template>
        </el-table-column>

      </el-table>

      <div style="margin-top: 20px; text-align: right">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="total"
        ></el-pagination>
      </div>
    </div>

    <el-empty v-else description="暂无作业数据"></el-empty>

  </el-card>
</template>

<script>
export default {
  name: "HomeworkCheckList",
  data() {
    return {
      searchKey: "",
      total: 0,
      tableData: [ ],
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    getHomework() {
      // 调用获取作业列表接口
      this.$api({
        apiType: "homework",
        data: { query: this.searchKey },
      }).then((result) => {
          // 这里假设后端返回的数据结构包含 list 和 total
          // 如果是模拟数据，这里可能会直接使用上面的 mock 数据
          if (result ) {
            this.tableData = result.data.list || this.tableData;
            this.total = result.total || this.tableData.length;
          }
        }).catch((err) => {
          console.error(err);
        });
    },
    handleView(row) {
      this.$router.push({
        name: 'homeworkDetail',
        params: {
          id: row.id
        }
      })
    },
    handleComplete(row) {
      this.$confirm(`确认已完成作业《${row.title}》吗?`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "success",
      }).then(() => {
          // 调用 API 更新状态
          // 假设有一个 homeworkEdit 接口用于更新状态
          this.$api({
            apiType: "homeworkSubmit", 
            data: { 
              role: 'student',
              id: row.id, 
              writeCheck: true 
            },
          }).then(() => {
            this.$message.success("作业状态已更新");
            // 乐观更新：直接修改本地数据，避免刷新页面
            row.completed = true;
          });
        }).catch(() => {
          // 取消操作
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
