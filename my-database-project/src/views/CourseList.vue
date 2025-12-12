<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix header-actions">
      <div class="filter-left">
        <el-select v-model="majorFilter" placeholder="筛选专业" size="small" style="width: 150px; margin-right: 10px;" clearable>
          <el-option label="所有专业" value=""></el-option>
          <el-option label="计算机学院" value="cs"></el-option>
          <el-option label="数学院" value="math"></el-option>
          <el-option label="外国语学院" value="eng"></el-option>
        </el-select>
        
        <el-input 
          v-model="searchKey" 
          placeholder="搜索课程名或代码" 
          prefix-icon="el-icon-search"
          size="small"
          style="width: 200px; margin-right: 10px;" 
          clearable
          @keyup.enter.native="getCourses"
          @clear="getCourses"
        ></el-input>
        <el-button type="primary" size="small" icon="el-icon-search" @click="getCourses">查询</el-button>
      </div>

      <el-button type="primary" size="small" icon="el-icon-plus" @click="openModal(null)">新建课程</el-button>
    </div>

    <div v-if="hasCourse">
      <el-table :data="tableData" style="width: 100%" border stripe>  
        <el-table-column prop="courseId" label="课程号" width="120" sortable>
          <template slot-scope="scope">
            <el-tag type="info" size="mini" style="font-family: monospace;">{{ scope.row.courseId }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="courseName" label="课程名称" min-width="180" show-overflow-tooltip>
          <template slot-scope="scope">
            <span style="font-weight: 600; color: #303133;">{{ scope.row.courseName }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="major" label="所属专业/学院" width="180">
          <template slot-scope="scope">
            <i class="el-icon-school" style="margin-right: 4px; color: #909399;"></i>
            <span>{{ scope.row.major }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="credits" label="学分" width="80" align="center"></el-table-column>

        <el-table-column prop="type" label="性质" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.type === '必修' ? 'danger' : 'success'" effect="dark" size="small">
              {{ scope.row.type }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="teacher" label="授课教师" width="120"></el-table-column>

        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleSchedule(scope.row)">排课</el-button>
            <el-button type="text" size="small" @click="openModal(scope.row)">编辑</el-button>
            <el-button type="text" size="small" style="color: #F56C6C" @click="handleStop(scope.row)">停开</el-button>
          </template>
        </el-table-column>

      </el-table>

      <div style="margin-top: 20px; text-align: right;">
        <el-pagination background layout="total, prev, pager, next" :total="100"></el-pagination>
      </div>
    </div>

    <el-empty v-else description="暂无课程信息">
      <el-button type="primary" size="small" @click="openModal(null)">立即新建课程</el-button>
    </el-empty>

    <course-modal 
      :visible.sync="modalVisible" 
      :row-data="currentRow"
      @success="handleSuccess"
    ></course-modal>

  </el-card>
</template>

<script>
import CourseModal from '@/components/CourseModal.vue';

export default {
  name: 'CourseList',
  components: {
    CourseModal
  },
  data() {
    return {
      searchKey: '',
      majorFilter: '',
      modalVisible: false, 
      currentRow: null,
      tableData: [
        {
          "courseId": "CS-101",
          "courseName": "Java 面向对象程序设计",
          "major": "计算机科学",
          "credits": 4.0,
          "type": "必修",
          "teacher": "王建国"
        },
        {
          "courseId": "MA-203",
          "courseName": "线性代数（B）",
          "major": "数学院",
          "credits": 3.0,
          "type": "必修",
          "teacher": "张教授"
        },
        {
          "courseId": "EN-310",
          "courseName": "跨文化交际与英语应用",
          "major": "外国语学院",
          "credits": 2.5,
          "type": "选修",
          "teacher": "李老师"
        },
        {
          "courseId": "IT-405",
          "courseName": "数据库系统原理与实践",
          "major": "计算机科学",
          "credits": 4.5,
          "type": "必修",
          "teacher": "赵工"
        }
      ]
    };
  },
  computed:{
    hasCourse(){
      return this.tableData && this.tableData.length > 0
    }
  },
  methods:{
    openModal(row) {
      this.currentRow = row
      this.modalVisible = true;
    },
    handleSuccess() {
      this.getCourses(); 
    },
    getCourses(){
      this.$api({
        apiType: 'course', 
        data: { 
          query: this.searchKey,
          major: this.majorFilter 
        }
      }).then(result => { 
        this.tableData = result?.list || this.tableData; 
      }).catch(err => {
         console.error(err);
      })
    },
    handleStop(row) {
      this.$confirm(`确认删除课程 ${row.courseName} 吗?`, '警告', { 
        type: 'warning',
        confirmButtonText: '确定停开',
        cancelButtonText: '取消'
      }).then(() => {
        this.$api({
          apiType: 'courseDelete',
          data: { courseId: row.courseId } //对应 api.config.js 中 url: '/course/:courseId'
        }).then(() => {
          this.$message.success('操作成功');
          this.getCourses();
        }).catch(err => {
          console.error(err)
          this.$message.error('操作失败');
        });
      });
    },
    handleSchedule(row) { this.$message.success(`排课: ${row.courseName}`); },
  },
  created(){
    this.getCourses()
  }
};
</script>

<style scoped>
.header-actions { display: flex; justify-content: space-between; align-items: center; }
.filter-left { display: flex; align-items: center; }
</style>