<template>
  <div class="scroll-section">
    <h2 class="section-title scroll-hidden">🏆 优秀作业展示</h2>
    <el-row :gutter="20" type="flex" justify="center" style="flex-wrap: wrap">
      <el-col
        :span="8"
        v-for="(work, index) in works"
        :key="work.id"
        class="scroll-hidden"
        :style="{ transitionDelay: `${index * 100}ms`, marginBottom: '30px' }"
      >
        <el-card shadow="hover" class="display-card work-card">
          <div class="work-header">
            <el-avatar size="small" :src="work.avatar"></el-avatar>
            <span class="author-name">{{ work.author }}</span>
            <el-tag size="mini" type="danger" effect="plain">A+</el-tag>
          </div>
          <div class="work-content">
            <h4>{{ work.title }}</h4>
            <p>{{ work.comment }}</p>
          </div>
          <div class="work-footer">
            <span><i class="el-icon-view"></i> {{ work.views }}</span>
            <span><i class="el-icon-star-off"></i> {{ work.likes }}</span>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ExcellentWorks',
  props: {
    works: {
      type: Array,
      default: () => []
    }
  }
};
</script>

<style scoped>
.scroll-section {
  margin-top: 80px;
}

.section-title {
  text-align: center;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  font-size: 30px;
  font-weight: 600;
  color: #ff69b4;
  margin-bottom: 45px;
  letter-spacing: 1px;
}

.scroll-hidden {
  opacity: 0;
  transform: translateY(50px);
  transition: all 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.scroll-visible {
  opacity: 1;
  transform: translateY(0);
}

.display-card {
  border: none;
  border-radius: 16px;
  transition: transform 0.3s, box-shadow 0.3s;
  overflow: hidden;
  height: 100%;
}

.display-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 30px rgba(255, 105, 180, 0.15);
}

.work-card .el-card__body {
  margin: 20px 0;
  padding: 20px;
}
.work-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
.author-name {
  margin-left: 10px;
  margin-right: auto;
  font-size: 14px;
  font-weight: bold;
  color: #606266;
}
.work-content h4 {
  margin: 10px 0;
  color: #303133;
}
.work-content p {
  font-size: 13px;
  color: #606266;
  background: #fff0f5;
  padding: 10px;
  border-radius: 6px;
  margin-bottom: 15px;
}
.work-footer {
  display: flex;
  justify-content: space-between;
  color: #909399;
  font-size: 12px;
}
</style>

