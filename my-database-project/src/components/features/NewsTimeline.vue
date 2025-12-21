<template>
  <el-card shadow="never" class="pink-theme-card">
    <div slot="header" class="cute-header">
      <span>🔔 最新动态</span>
      <el-button
        style="float: right; padding: 3px 0; color: #ff69b4"
        type="text"
        @click="markAllAsRead"
      >
        全部标为已读
      </el-button>
    </div>
    <div style="overflow-y: auto">
      <el-timeline>
        <el-timeline-item
          v-for="item in timelineItems"
          :key="item.id"
          :timestamp="item.timestamp"
          placement="top"
          :color="item.color"
        >
          <el-card>
            <h4>{{ item.title }}</h4>
            <p>{{ item.content }}</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </div>
  </el-card>
</template>

<script>
export default {
  name: 'NewsTimeline',
  data() {
    return {
      timelineItems: [
        {
          id: 1,
          timestamp: '2025/12/01',
          color: '#ff69b4',
          title: '发布了新作业',
          content: '王老师 发布了《微积分期中测试》'
        },
        {
          id: 2,
          timestamp: '2025/11/28',
          color: '#ffb6c1',
          title: '学生提交提醒',
          content: '李明 提交了《Java 基础》作业'
        },
        {
          id: 3,
          timestamp: '2025/11/25',
          color: '#ffb6c1',
          title: '发布了新作业',
          content: '祥老师 发布了《春日影》'
        }
      ]
    };
  },
  methods: {
    markAllAsRead() {
      // TODO: 实现全部标为已读的逻辑
      this.$message.success('已将所有动态标为已读');
    }
  }
};
</script>

<style scoped>
.cute-header span {
  font-family: "ZCOOL KuaiLe", cursive, sans-serif;
  font-size: 20px;
  color: #ff69b4;
}
::v-deep .el-timeline-item__timestamp {
  color: #909399;
}
</style>

