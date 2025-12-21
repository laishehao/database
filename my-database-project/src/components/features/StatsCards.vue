<template>
  <el-row :gutter="20" style="margin-bottom: 20px">
    <!-- 学生总数卡片 (教师可见) -->
    <el-col :span="6" v-if="userRole === 'teacher'">
      <el-card
        shadow="hover"
        class="data-card"
        :style="getCardStyle('student_bg.png', '#409EFF')"
      >
        <div class="card-content">
          <div class="card-left">
            <div class="card-num">{{ stats.student }}</div>
            <div class="card-text">学生总数</div>
          </div>
          <i class="el-icon-user-solid card-icon"></i>
        </div>
      </el-card>
    </el-col>

    <!-- 课程总数卡片 -->
    <el-col :span="6">
      <el-card
        shadow="hover"
        class="data-card"
        :style="getCardStyle('course_bg.png', '#67C23A')"
      >
        <div class="card-content">
          <div class="card-left">
            <div class="card-num">{{ stats.course }}</div>
            <div class="card-text">课程总数</div>
          </div>
          <i class="el-icon-reading card-icon"></i>
        </div>
      </el-card>
    </el-col>

    <!-- 进行中作业卡片 -->
    <el-col :span="6">
      <el-card
        shadow="hover"
        class="data-card"
        :style="getCardStyle('homework_bg.png', '#E6A23C')"
      >
        <div class="card-content">
          <div class="card-left">
            <div class="card-num">{{ stats.homework }}</div>
            <div class="card-text">进行中的作业</div>
          </div>
          <i class="el-icon-notebook-1 card-icon"></i>
        </div>
      </el-card>
    </el-col>

    <!-- 预警课程卡片 (学生可见) -->
    <el-col :span="6" v-if="userRole === 'student'">
      <el-card
        shadow="hover"
        class="data-card"
        :style="getCardStyle('warning_bg.png', '#F56C6C')"
      >
        <div class="card-content">
          <div class="card-left">
            <div class="card-num">3</div>
            <div class="card-text">预警课程</div>
          </div>
          <i class="el-icon-warning-outline card-icon"></i>
        </div>
      </el-card>
    </el-col>

    <!-- 待批改卡片 (教师可见) -->
    <el-col :span="6" v-if="userRole === 'teacher'">
      <el-card
        shadow="hover"
        class="data-card"
        :style="getCardStyle('mark_bg.png', '#42b983')"
      >
        <div class="card-content">
          <div class="card-left">
            <div class="card-num">8</div>
            <div class="card-text">待批改</div>
          </div>
          <i class="el-icon-edit-outline card-icon"></i>
        </div>
      </el-card>
    </el-col>
  </el-row>
</template>

<script>
export default {
  name: 'StatsCards',
  props: {
    stats: {
      type: Object,
      default: () => ({ student: 0, course: 0, homework: 0 })
    },
    userRole: {
      type: String,
      required: true
    }
  },
  methods: {
    getCardStyle(imageName, fallbackColor) {
      try {
        const imgUrl = require(`@/assets/img/dashboard/${imageName}`);
        const maskColor = fallbackColor + "CC";
        return {
          backgroundImage: `linear-gradient(${maskColor}, ${maskColor}), url(${imgUrl})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
          color: "white",
          border: "none",
        };
      } catch (e) {
        return { background: fallbackColor, color: "white", border: "none" };
      }
    }
  }
};
</script>

<style scoped>
.data-card {
  cursor: pointer;
  transition: transform 0.3s;
  overflow: hidden;
}
.data-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
.card-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80px;
  padding: 20px;
}
.card-num {
  font-size: 32px;
  font-weight: bold;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}
.card-text {
  font-size: 14px;
  opacity: 0.9;
  margin-top: 5px;
}
.card-icon {
  font-size: 48px;
  opacity: 0.8;
}
</style>

