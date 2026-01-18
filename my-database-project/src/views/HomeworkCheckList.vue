<!--
 * @Author: kusachan 3253975221@qq.com
 * @Date: 2025-12-15 00:57:59
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2026-01-18 16:03:32
 * @Description: 学生作业查看列表 - 古代典籍风格版
-->
<template>
  <div class="ancient-scroll-page">
    <!-- 装饰：线装书侧边装订线 -->
    <div class="book-binding"></div>

    <el-card shadow="never" class="ancient-card">
      <div slot="header" class="clearfix header-actions ancient-header">
        <div class="filter-left">
          <!-- 标题装饰 -->
          <div class="ancient-title-mark">
            <span>课业</span>
            <span>名录</span>
          </div>
          <expandable-search
            v-model="searchKey"
            placeholder="寻觅课业..."
            @search="handleSearch"
            class="ancient-search"
          ></expandable-search>
        </div>
      </div>

      <!-- 有作业时渲染 -->
      <div v-if="hasHomework" class="ancient-table-wrapper">
        <el-table
          :data="tableData"
          style="width: 100%"
          class="ancient-table"
          :header-cell-style="headerCellStyle"
          :row-class-name="tableRowClassName"
        >
          <!-- 作业名称 -->
          <el-table-column prop="title" label="课业题跋" min-width="180">
            <template slot-scope="scope">
              <span class="ink-text title-font">{{ scope.row.title }}</span>
            </template>
          </el-table-column>

          <!-- 作业所属课程 -->
          <el-table-column prop="course" label="所属经籍">
            <template slot-scope="scope">
              <span class="course-text">《{{ scope.row.course }}》</span>
            </template>
          </el-table-column>

          <!-- 作业状态 -->
          <el-table-column label="批阅状态" width="140" align="center">
            <template slot-scope="scope">
              <!-- 将Tag改为印章风格 -->
              <div
                :class="[
                  'seal-box',
                  scope.row.completed ? 'seal-red' : 'seal-ink',
                ]"
              >
                <span class="seal-inner">
                  {{ scope.row.completed ? "已 阅" : "未 呈" }}
                </span>
              </div>
            </template>
          </el-table-column>

          <!-- 操作栏 -->
          <el-table-column
            label="裁决"
            width="120"
            fixed="right"
            align="center"
          >
            <template slot-scope="scope">
              <el-button
                type="text"
                size="small"
                class="ancient-btn"
                @click="handleView(scope.row)"
              >
                <i class="el-icon-view"></i> 展卷
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页 -->
        <div
          style="margin-top: 30px; text-align: center"
          class="ancient-pagination"
        >
          <el-pagination
            background
            layout="prev, pager, next, total"
            :total="total"
            :current-page.sync="currentPage"
            :page-size="pageSize"
            prev-text="上一卷"
            next-text="下一卷"
            @current-change="handleCurrentChange"
          ></el-pagination>
        </div>
      </div>

      <!-- 没有作业时渲染 -->
      <div v-else class="empty-state-ancient">
        <div class="empty-text">暂无课业记录</div>
        <div class="empty-seal">空</div>
      </div>
    </el-card>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import ExpandableSearch from "@/components/features/ExpandableSearch.vue";

export default {
  name: "HomeworkCheckList",
  data() {
    return {
      searchKey: "",
      total: 0, //符合条件的作业总数
      currentPage: 1, // 当前页码
      pageSize: 10, // 每页显示条数
      tableData: [], //作业数据
      // 样式辅助
      headerCellStyle: {
        background: "#eaddcf",
        color: "#5d4037",
        fontWeight: "bold",
        borderBottom: "2px solid #8b7d6b",
        fontFamily: '"KaiTi", "STKaiti", serif',
        fontSize: "18px", // [已修改] 表头字体增大到 18px
      },
    };
  },
  components: {
    ExpandableSearch,
  },
  computed: {
    hasHomework() {
      return this.tableData && this.tableData.length > 0;
    },
    ...mapGetters(["userInfo"]),
  },
  methods: {
    // 辅助方法：隔行变色样式
    tableRowClassName({ rowIndex }) {
      if (rowIndex % 2 === 1) {
        return "ancient-row-stripe";
      }
      return "";
    },
    // 搜索处理：重置页码
    handleSearch() {
      this.currentPage = 1;
      this.getHomework();
    },
    // 处理页码改变
    handleCurrentChange(val) {
      this.currentPage = val;
      this.getHomework();
    },
    //获取作业列表
    getHomework() {
      this.$api({
        apiType: "homework",
        data: {
          role: this.userInfo.role,
          id: this.userInfo.id,
          query: this.searchKey,
          page: this.currentPage,
          pageSize: this.pageSize,
        },
      })
        .then((result) => {
          // 获取列表数据 (兼容不同的返回结构)
          const list = result.list || (result.data && result.data.list) || [];
          this.tableData = list;
          this.total =
            result.total || (result.data && result.data.total) || list.length;

          // 自动同步 checkHomework 到 Vuex
          list.forEach((item) => {
            if (item.completed) {
              this.$store.dispatch("completeHomework", item.id);
            }
          });
        })
        .catch((err) => {
          console.error(err);
        });
    },
    //查看具体的作业内容
    handleView(row) {
      // 兼容后端返回的 id 字段名（可能是 id 或 workId）
      const id = row.id || row.workId || row.work_id;
      if (!id) {
        console.warn("handleView: missing id/workId in row", row);
        return;
      }
      // 改变 path, route-view 会自动渲染
      this.$router.push({
        name: "homeworkDetail",
        params: {
          id,
        },
      });
    },
  },
  created() {
    this.getHomework();
  },
};
</script>

<style scoped>
/* 引入字体变量，优先使用楷体 */
.ancient-scroll-page {
  --paper-bg: #fdfbf7;
  --paper-dark: #f0e6d2;
  --ink-color: #2c2c2c;
  --border-color: #8b7d6b;
  --cinnabar: #9e2a2b; /* 朱砂红 */
  --jade: #567e76; /* 玉石绿 */
  --font-serif: "KaiTi", "STKaiti", "SimSun", "Songti SC", serif;

  font-family: var(--font-serif);
  background-color: var(--paper-bg);
  padding: 20px;
  position: relative;
  min-height: 100%;
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23d6cbb5' fill-opacity='0.15' fill-rule='evenodd'/%3E%3C/svg%3E");
}

/* 装饰性侧边装订线 */
.book-binding {
  position: absolute;
  left: 20px;
  top: 0;
  bottom: 0;
  width: 4px;
  border-left: 1px solid var(--border-color);
  border-right: 1px solid var(--border-color);
  background-color: #fff;
  z-index: 0;
}
.book-binding::after {
  content: "";
  position: absolute;
  top: 30px;
  left: -6px;
  width: 14px;
  height: 100%;
  background-image: repeating-linear-gradient(
    0deg,
    var(--border-color),
    var(--border-color) 2px,
    transparent 2px,
    transparent 40px
  );
  z-index: 1;
}

/* 卡片容器 */
.ancient-card {
  margin-left: 20px;
  background-color: rgba(255, 255, 255, 0.4);
  border: 1px double var(--border-color);
  border-radius: 4px;
  position: relative;
  z-index: 2;
}

/* 头部样式 */
.ancient-header {
  border-bottom: 2px solid var(--border-color);
  padding-bottom: 15px;
}

.ancient-title-mark {
  display: inline-flex;
  flex-direction: column;
  border: 2px solid var(--cinnabar);
  color: var(--cinnabar);
  padding: 6px 12px; /* 增加内边距 */
  margin-right: 15px;
  font-weight: bold;
  font-size: 20px; /* [已修改] 标题装饰字体增大 */
  line-height: 1.2;
  border-radius: 4px;
  box-shadow: inset 0 0 5px rgba(158, 42, 43, 0.2);
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.filter-left {
  display: flex;
  align-items: center;
}

/* 表格深度定制 */
::v-deep .el-table {
  background-color: transparent !important;
}
::v-deep .el-table tr {
  background-color: transparent !important;
}
::v-deep .ancient-row-stripe {
  background-color: rgba(230, 222, 204, 0.3) !important;
}
::v-deep .el-table td {
  border-bottom: 1px dashed #d1c7b7;
  border-right: 1px solid rgba(139, 125, 107, 0.2);
}
::v-deep .el-table--border::after,
::v-deep .el-table--group::after,
::v-deep .el-table::before {
  background-color: var(--border-color);
}
::v-deep .el-table tbody tr:hover > td {
  background-color: rgba(139, 125, 107, 0.1) !important;
}

/* 文字样式 */
.ink-text {
  color: var(--ink-color);
  font-size: 18px; /* [已修改] 作业标题字体增大 */
}
.title-font {
  font-weight: 600;
  letter-spacing: 1px;
}
.course-text {
  color: #555;
  font-size: 16px; /* [已修改] 课程字体增大 */
  font-style: italic;
  font-family: "FangSong", "KaiTi", serif;
}

/* 印章风格的状态 */
.seal-box {
  display: inline-block;
  width: 56px; /* [已修改] 稍微加大印章尺寸以适应字体 */
  height: 56px;
  line-height: 50px;
  border-radius: 4px;
  text-align: center;
  transform: rotate(-5deg);
  font-weight: bold;
  font-size: 16px; /* [已修改] 印章字体增大 */
  position: relative;
  opacity: 0.9;
}
.seal-inner {
  display: block;
  border: 2px solid currentColor;
  border-radius: 3px;
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  font-family: "LiSu", "KaiTi", serif; /* 隶书更有印章感 */
}
.seal-red {
  color: var(--cinnabar);
}
.seal-ink {
  color: #666;
  border-color: #666;
  border-style: dashed;
}

/* 按钮样式古风化 */
.ancient-btn {
  font-size: 16px; /* [已修改] 按钮字体增大 */
  font-family: var(--font-serif);
  padding: 5px 10px;
  transition: all 0.3s;
}
.ancient-btn:hover {
  transform: scale(1.05);
}
.ancient-btn >>> i {
  font-weight: bold;
}
.ancient-btn.el-button--text {
  color: var(--jade);
}
.btn-undo {
  color: #888 !important;
}
.btn-do {
  color: var(--cinnabar) !important;
}

/* 分页组件样式覆盖 */
::v-deep
  .ancient-pagination
  .el-pagination.is-background
  .el-pager
  li:not(.disabled).active {
  background-color: var(--cinnabar);
  color: #fff;
  border-color: var(--cinnabar);
}
::v-deep .ancient-pagination .el-pagination.is-background .el-pager li {
  background-color: transparent;
  border: 1px solid var(--border-color);
  color: var(--ink-color);
  font-family: var(--font-serif);
  font-size: 14px; /* [已修改] 分页字体微调 */
}
::v-deep .ancient-pagination .el-pagination.is-background .btn-prev,
::v-deep .ancient-pagination .el-pagination.is-background .btn-next {
  background-color: transparent;
  border: 1px solid var(--border-color);
  color: var(--ink-color);
  padding: 0 10px;
}

/* 空状态 */
.empty-state-ancient {
  text-align: center;
  padding: 60px 0;
  color: #999;
}
.empty-seal {
  font-size: 90px; /* [已修改] 空状态印章加大 */
  font-family: "LiSu", serif;
  color: #eaddcf;
  border: 4px solid #eaddcf;
  width: 140px; /* [已修改] 尺寸加大 */
  height: 140px;
  line-height: 125px;
  border-radius: 50%;
  margin: 0 auto 20px;
  transform: rotate(15deg);
}
.empty-text {
  font-family: var(--font-serif);
  font-size: 20px; /* [已修改] 空状态文字加大 */
  letter-spacing: 2px;
}

/* 搜索框微调 */
.ancient-search {
  width: 320px; /* [已修改] 稍微加宽 */
}
::v-deep .ancient-search .el-input__inner {
  background-color: rgba(255, 255, 255, 0.5);
  border: 1px solid var(--border-color);
  border-radius: 20px;
  color: var(--ink-color);
  font-family: var(--font-serif);
  font-size: 16px; /* [已修改] 输入框文字加大 */
}
</style>