<template>
  <div class="scroll-section">
    <h2 class="section-title scroll-hidden">✨ 开启您的独享创作之旅</h2>
    <el-row :gutter="50" type="flex" justify="center">
      <el-col
        :span="6"
        v-for="(course, index) in courses"
        :key="course.id"
        class="scroll-hidden"
        :style="{ transitionDelay: `${index * 100}ms` }"
      >
        <el-card
          shadow="hover"
          class="display-card minimal-course-card"
          :body-style="{
            padding: '40px 30px',
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center'
          }"
        >
          <div class="minimal-icon" :style="{ color: course.color }">
            <i :class="course.icon"></i>
          </div>
          <h3 class="minimal-title">{{ course.title }}</h3>
          <p class="mid-desc">{{ course.desc }}</p>
          <p class="minimal-desc">{{ course.minDesc }}</p>
          <el-button type="primary" class="pink-btn-wide">
            Try Claude
          </el-button>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'RecommendCourses',
  props: {
    courses: {
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

.minimal-course-card {
  min-height: 420px;
  border: 1px solid #fff0f5;
}

.minimal-icon {
  font-size: 56px;
  margin-bottom: 25px;
  transition: transform 0.3s;
}
.minimal-course-card:hover .minimal-icon {
  transform: scale(1.1);
}

.minimal-title {
  margin: 0 0 15px 0;
  font-size: 30px;
  font-weight: bold;
  color: #333;
  text-align: center;
  width: 100%;
}

.mid-desc {
  color: #666;
  font-size: 18px;
  line-height: 1.6;
  text-align: center;
  margin-bottom: 20px;
  overflow: hidden;
  height: 120px;
}

.minimal-desc {
  color: #666;
  font-size: 12px;
  font-weight: normal;
  text-align: center;
  width: 100%;
  margin-bottom: 20px;
  overflow: hidden;
  height: 48px;
}

.pink-btn-wide {
  width: 100%;
  margin-bottom: 6px;
  font-size: 16px;
  font-weight: 600;
  background: linear-gradient(90deg, #ff9a9e 0%, #ff69b4 100%);
  border: none;
  box-shadow: 0 4px 10px rgba(255, 105, 180, 0.3);
  transition: all 0.3s;
}
.pink-btn-wide:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(255, 105, 180, 0.4);
}
</style>

