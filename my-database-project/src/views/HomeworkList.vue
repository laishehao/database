<!--
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 20:26:04
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-12 13:10:42
 * @FilePath: \my-database-project\src\views\HomeworkList.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
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
      <el-button
        type="primary"
        size="small"
        icon="el-icon-plus"
        @click="openModal"
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
            <el-progress :percentage="scope.row.progress" :status="scope.row.progress === 100 ? 'success' : ''"></el-progress>
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
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
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
      <el-button type="primary" size="small" @click="openModal"
        >立即发布作业</el-button
      >
    </el-empty>

    <homework-modal
      :visible.sync="modalVisible"
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
      tableData: [
        {
          id: 1,
          title: "数据库设计与规范化作业",
          course: "数据库系统原理",
          progress: 85,
          active: true,
        },
        {
          id: 2,
          title: "高等数学期末复习题（上）",
          course: "高等数学",
          progress: 40,
          active: true,
        },
        {
          id: 3,
          title: "Java 面向对象设计模式",
          course: "计算机科学",
          progress: 100,
          active: false,
        },
        {
          id: 4,
          title: "Unit 5 听力练习",
          course: "大学英语",
          progress: 100,
          active: true,
        },
        {
          id: 5,
          title: "线性代数习题三",
          course: "数学院",
          progress: 0,
          active: true,
        },
      ],
    };
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
  },
  methods: {
    openModal() {
      this.modalVisible = true;
    },
    handleSuccess() {
      this.getHomework();
    },
    getHomework() {
      this.$api({
        apiType: "homework",
        data: { query: this.searchKey },
      }).then((result) => {
          console.log(result);
          this.tableData = [
            {
              id: 1,
              title: "数据库设计与规范化作业",
              course: "数据库系统原理",
              progress: 85,
              active: true,
            },
            {
              id: 2,
              title: "高等数学期末复习题（上）",
              course: "高等数学",
              progress: 40,
              active: true,
            },
            {
              id: 3,
              title: "Java 面向对象设计模式",
              course: "计算机科学",
              progress: 100,
              active: false,
            },
            {
              id: 4,
              title: "Unit 5 听力练习",
              course: "大学英语",
              progress: 100,
              active: true,
            },
            {
              id: 5,
              title: "线性代数习题三",
              course: "数学院",
              progress: 0,
              active: true,
            },
          ];
        }).catch((err) => {
          console.error(err);
        });
    },
    handleView(row) {
      this.$message.info(`查看作业：${row.title}`);
    },
    handleDelete(row) {
      this.$confirm(`确认删除作业 ${row.title} 吗?`, "提示", {
        type: "warning",
      }).then(() => {
        if (!row.id) {
          console.warn("缺少ID，可能无法删除", row);
        }
        this.$api({
          apiType: "homeworkDelete",
          data: { id: row.id }, // 对应 api.config.js 中 /homework/:id
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