<template>
  <div class="dashboard-container">
    <el-row :gutter="20" style="margin-bottom: 20px;">
      
      <el-col :span="6">
        <el-card shadow="hover" class="data-card" style="background: #409EFF; color: white;">
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">45</div>
              <div class="card-text">学生总数</div>
            </div>
            <i class="el-icon-user-solid card-icon"></i>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="data-card" style="background: #67C23A; color: white;">
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">12</div>
              <div class="card-text">进行中的作业</div>
            </div>
            <i class="el-icon-notebook-1 card-icon"></i>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="data-card" style="background: #E6A23C; color: white;">
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">8</div>
              <div class="card-text">待批改</div>
            </div>
            <i class="el-icon-edit-outline card-icon"></i>
          </div>
        </el-card>
      </el-col>

      <el-col :span="6">
        <el-card shadow="hover" class="data-card" style="background: #F56C6C; color: white;">
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">3</div>
              <div class="card-text">预警课程</div>
            </div>
            <i class="el-icon-warning-outline card-icon"></i>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="16">
        <el-card shadow="never">
          <div slot="header">
            <span>📅 教学日历</span>
          </div>
          <el-calendar v-model="currentDate">
            <template
              slot="dateCell"
              slot-scope="{ data }"> 
              <p :class="data.isSelected ? 'is-selected' : ''">
                {{ data.day.split('-').slice(1).join('-') }} 
              <span v-if="data.day === '2023-12-25'">🎄</span>
             </p>
          </template>
          </el-calendar>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card shadow="never">
          <div slot="header">
            <span>🔔 最新动态</span>
            <el-button style="float: right; padding: 3px 0" type="text">全部标为已读</el-button>
          </div>
          <div style="height: 400px; overflow-y: auto;">
             <el-timeline>
                <el-timeline-item timestamp="2023/12/01" placement="top" color="#0bbd87">
                  <el-card>
                    <h4>发布了新作业</h4>
                    <p>王老师 发布了《微积分期中测试》</p>
                  </el-card>
                </el-timeline-item>
                <el-timeline-item timestamp="2023/11/28" placement="top">
                  <el-card>
                    <h4>学生提交提醒</h4>
                    <p>李明 提交了《Java 基础》作业</p>
                  </el-card>
                </el-timeline-item>
                <el-timeline-item timestamp="2023/11/25" placement="top">
                  <el-card>
                    <h4>系统维护通知</h4>
                    <p>教务系统将于今晚 24:00 进行升级</p>
                  </el-card>
                </el-timeline-item>
              </el-timeline>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'DashBoard',
  data() {
    return {
      currentDate: new Date()
    }
  }
}
</script>

<style scoped>
.data-card {
  border: none;
  cursor: pointer;
}
.card-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80px;
}
.card-num {
  font-size: 32px;
  font-weight: bold;
}
.card-text {
  font-size: 14px;
  opacity: 0.8;
  margin-top: 5px;
}
.card-icon {
  font-size: 48px;
  opacity: 0.3;
}
.is-selected {
  color: #1989FA;
}
</style>