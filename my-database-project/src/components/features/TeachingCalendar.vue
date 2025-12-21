<template>
  <el-card shadow="never" class="pink-theme-card">
    <div slot="header" class="cute-header">
      <span>📅 教学日历</span>
    </div>
    <el-calendar v-model="currentDate">
      <template slot="dateCell" slot-scope="{ data }">
        <p :class="data.isSelected ? 'is-selected' : ''">
          {{ data.day.split("-").slice(1).join("-") }}
          <span v-if="data.day === '2025-12-25'">🎄</span>
        </p>
      </template>
    </el-calendar>
  </el-card>
</template>

<script>
export default {
  name: 'TeachingCalendar',
  data() {
    return {
      currentDate: new Date()
    };
  }
};
</script>

<style scoped>
.cute-header span {
  font-family: "ZCOOL KuaiLe", cursive, sans-serif;
  font-size: 20px;
  color: #ff69b4;
}
::v-deep .el-calendar__header {
  border-bottom: 1px solid #ffe6f0;
}
::v-deep .el-calendar__title,
::v-deep .el-calendar-table thead th {
  color: #ff69b4;
}
::v-deep .el-calendar-table .el-calendar-day:hover {
  background-color: #fff0f5;
}
::v-deep .el-calendar-table td.is-selected .el-calendar-day {
  background-color: #ffe6f0;
  color: #ff69b4;
}
::v-deep .el-calendar-table td.is-today,
.is-selected {
  color: #ff69b4;
  font-weight: bold;
}
</style>

