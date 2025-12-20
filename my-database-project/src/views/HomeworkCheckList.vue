<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 00:57:59
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-19 18:18:19
 * @Description: 学生作业查看列表
-->
<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <expandable-search 
          v-model="searchKey" 
          placeholder="搜索作业名称..."
          @search="getHomework"
        ></expandable-search>
      </div>
    </div>
    <!-- 有作业时渲染 -->
    <div v-if="hasHomework">
      <el-table :data="tableData" style="width: 100%" stripe>
        <!-- 作业名称 -->
        <el-table-column prop="title" label="作业名称" min-width="180">
          <template slot-scope="scope">
            <span style="font-weight: 500;">{{ scope.row.title }}</span>
          </template>
        </el-table-column>
        <!-- 作业所属课程 -->
        <el-table-column prop="course" label="课程">
          <template slot-scope="scope">
            <el-tag size="medium" effect="plain">{{ scope.row.course }}</el-tag>
          </template>
        </el-table-column>
        <!-- 作业状态 -->
        <el-table-column label="状态" width="120">
          <template slot-scope="scope">
            <!-- el-tag的样式可以选择 -->
            <el-tag
              :type="scope.row.completed ? 'success' : 'warning'"
              size="small"
              effect="dark"
            >
              {{ scope.row.completed ? '已完成' : '未完成' }}
            </el-tag>
          </template>
        </el-table-column>
        <!-- 操作栏 -->
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
      <!-- 分页 -->
      <div style="margin-top: 20px; text-align: right">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="total"
        ></el-pagination>
      </div>
    </div>
    <!-- 没有作业时渲染 -->
    <el-empty v-else description="暂无作业数据"></el-empty>

  </el-card>
</template>

<script>
import { mapGetters } from 'vuex';
import ExpandableSearch from "@/components/features/ExpandableSearch.vue";
export default {
  name: "HomeworkCheckList",
  data() {
    return {
      searchKey: "",    
      total: 0,       //符合条件的作业总数
      tableData: [],    //作业数据
    };
  },
  components: {
    ExpandableSearch,
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
    ...mapGetters(['userInfo']),
  },
  methods: {
    //获取作业列表
    getHomework() {
      this.$api({
        apiType: "homework",
        data: { query: this.searchKey },
      }).then((result) => {
          // 获取列表数据 (兼容不同的返回结构)
          const list = result.list || (result.data && result.data.list) || [];
          this.tableData = list;
          this.total = result.total || (result.data && result.data.total) || list.length;

          // 自动同步 checkHomework 到 Vuex
          list.forEach(item => {
            if (item.completed) {
              this.$store.dispatch('completeHomework', item.id);
            }
          });
        }).catch((err) => {
          console.error(err);
        });
    },
    //查看具体的作业内容
    handleView(row) {
      //改变path, route-view会自动渲染
      this.$router.push({
        name: 'homeworkDetail',
        params: {
          id: row.id
        }
      })
    },
    //确认完成 / 取消完成
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
              workId: row.id,
              userId: this.userInfo.id,
              writeCheck: !isUndo 
            },
          }).then(() => {
            this.$message.success(`${actionText}成功`);
            // 更新本地数据
            row.completed = !isUndo;
            // 更新 Vuex Store, 同步修改localStorage中的checkHomework
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