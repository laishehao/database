<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 00:57:59
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-17 01:22:30
 * @Description: 学生作业查看列表
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
        >查询</el-button>
      </div>
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

        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="text" 
              size="small" 
              icon="el-icon-view" 
              @click="handleView(scope.row)"
            >查看</el-button>
            
            <el-button 
              type="text" 
              size="small" 
              :icon="scope.row.completed ? 'el-icon-refresh-left' : 'el-icon-check'"
              :style="{ color: scope.row.completed ? '#909399' : '#67C23A' }"
              @click="handleComplete(scope.row)"
            >
              {{ scope.row.completed ? '取消完成' : '确认完成' }}
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
      tableData: [],
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    getHomework() {
      this.$api({
        apiType: "homework",
        data: { query: this.searchKey },
      }).then((result) => {
          // 1. 获取列表数据 (兼容不同的返回结构)
          const list = result.list || (result.data && result.data.list) || [];
          this.tableData = list;
          this.total = result.total || (result.data && result.data.total) || list.length;

          // 2. 关键修改：自动同步 checkHomework 到 Vuex
          // 遍历后端返回的列表，如果后端标记为已完成，则确保 Vuex 中也有这个 ID
          list.forEach(item => {
            if (item.completed) {
              // 这是一个幂等操作，Vuex action 内部会去重，不用担心重复添加
              this.$store.dispatch('completeHomework', item.id);
            }
          });

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
      const isUndo = row.completed;
      const actionText = isUndo ? "撤销完成" : "确认完成";
      const confirmType = isUndo ? "warning" : "success";

      this.$confirm(`确定要${actionText}作业《${row.title}》吗?`, "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: confirmType,
      }).then(() => {
          this.$api({
            apiType: "homeworkSubmit", 
            data: { 
              role: 'student',
              id: row.id, 
              writeCheck: !isUndo 
            },
          }).then(() => {
            this.$message.success(`${actionText}成功`);
            
            // 更新本地数据
            row.completed = !isUndo;

            // 更新 Vuex Store
            if (row.completed) {
              this.$store.dispatch('completeHomework', row.id);
            } else {
              this.$store.dispatch('undoHomework', row.id);
            }
          });
        }).catch((err) => {
          if (err !== 'cancel') console.error(err);
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