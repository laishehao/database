<template>
  <el-card shadow="never">
    <div slot="header" class="clearfix">
      <!-- 页头组件，自带返回按钮 -->
      <el-page-header @back="goBack" content="作业详情"></el-page-header>
    </div>

    <div v-loading="loading" class="detail-container">
      <!-- 作业基本信息 -->
      <el-descriptions title="基本信息" border :column="2" style="margin-bottom: 20px">
        <el-descriptions-item label="作业名称">
          <span style="font-weight: bold">{{ detail.title }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="所属课程">
          <el-tag size="small">{{ detail.course }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="detail.completed ? 'success' : 'warning'" size="small">
            {{ detail.completed ? '已完成' : '未完成' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="截止时间">2025-12-31 23:59</el-descriptions-item>
      </el-descriptions>

      <!-- 作业要求区域 -->
      <div class="content-section">
        <h3>📄 作业要求</h3>
        <div class="content-box requirement-box">
          {{ detail.content || '暂无详细描述...' }}
        </div>
      </div>

      <!-- 作答区域 (富文本编辑器) -->
      <div class="submission-section" style="margin-top: 20px;">
        <h3>✏️ 我的作答</h3>
        
        <!-- 情况 A: 未完成状态，显示可编辑的富文本编辑器 -->
        <div v-if="!detail.completed" class="editor-container">
          <quill-editor 
            v-model="submissionContent" 
            ref="myQuillEditor" 
            :options="editorOption"
            style="height: 250px;" 
          >
          </quill-editor>
        </div>

        <!-- 情况 B: 已完成状态，显示只读的 HTML 内容 -->
        <div v-else class="content-box submission-display">
          <div v-if="submissionContent" v-html="submissionContent" class="ql-editor" style="padding: 0;"></div>
          <div v-else style="color: #909399; font-style: italic;">(本次提交无文本内容)</div>
        </div>
      </div>

      <!-- 底部操作区 -->
      <div style="margin-top: 50px; text-align: center;" v-if="!detail.completed">
        <el-button type="primary" icon="el-icon-check" :loading="submitting" @click="handleComplete">
          确认提交作业
        </el-button>
      </div>
    </div>
  </el-card>
</template>

<script>
// 1. 引入 Quill 样式
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

// 2. 引入 VueQuillEditor 组件
import { quillEditor } from 'vue-quill-editor'

export default {
  name: 'HomeworkDetail',
  components: {
    quillEditor
  },
  data() {
    return {
      loading: false,
      submitting: false, // 提交按钮加载状态
      detail: {
        id: '',
        title: '',
        course: '',
        completed: false,
        content: ''
      },
      // 学生作答内容 (HTML 字符串)
      submissionContent: '',
      
      // 富文本编辑器配置
      editorOption: {
        placeholder: '在此处输入您的作业答案...',
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'strike'],    // 加粗，斜体，下划线，删除线
            ['blockquote', 'code-block'],                 // 引用，代码块
            [{ 'header': 1 }, { 'header': 2 }],           // 标题
            [{ 'list': 'ordered'}, { 'list': 'bullet' }], // 列表
            [{ 'color': [] }, { 'background': [] }],      // 颜色
            ['clean']                                     // 清除格式
          ]
        }
      }
    };
  },
  created() {
    this.fetchDetail();
  },
  methods: {
    goBack() {
      this.$router.go(-1); // 返回上一页
    },
    
    // 获取作业详情
    fetchDetail() {
      this.loading = true;
      const id = this.$route.params.id; // 获取路由参数中的 ID
      
      console.log(`正在获取 ID 为 ${id} 的作业详情`);
      
      //  this.$api({ apiType: 'homeworkDetail', data: { id } })
      setTimeout(() => {
        // 模拟后端返回的数据
        this.detail = {
          id: id,
          title: '数据库设计与规范化作业',
          course: '数据库系统原理',
          completed: false, // 改为 true 可测试只读模式
          content: '请阅读教材第三章，完成课后习题 1-5。并使用 Visio 或 ProcessOn 绘制图书管理系统的 E-R 图，导出为 PNG 格式上传。'
        }; 
        this.loading = false;
      }, 500);
    },

    // 提交作业
    handleComplete() {
      // 校验内容是否为空
      const plainText = this.submissionContent.replace(/<[^>]+>/g, "").trim();
      const hasImage = this.submissionContent.includes('<img');

      if (!plainText && !hasImage) {
        this.$message.warning('请填写作业内容后再提交');
        return;
      }

      this.$confirm('确认提交该作业吗? 提交后不可修改', '提示', {
        confirmButtonText: '确定提交',
        cancelButtonText: '取消',
        type: 'success' 
      }).then(() => {
        this.submitting = true;

        // 调用 API 提交
        this.$api({
          apiType: "homeworkSubmit", 
          data: { 
            role: 'student',
            id: this.detail.id, 
            writeCheck: true,
            content: this.submissionContent // 将富文本 HTML 内容传给后端
          },
        }).then(() => {
          this.$message.success('提交成功');
          // 更新本地状态为已完成，界面会自动切换为只读模式
          this.detail.completed = true;
        }).catch((err) => {
           console.error(err);
        }).finally(() => {
           this.submitting = false;
        });
      }).catch((err) => {
        console.error(err)
      });
    }
  }
};
</script>

<style scoped>
/* 通用内容容器样式 */
.detail-container {
  max-width: 900px;
  margin: 0 auto;
}

.content-box {
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 4px;
  color: #606266;
  line-height: 1.6;
  border: 1px solid #EBEEF5;
}

/* 题目要求区域 */
.requirement-box {
  min-height: 80px;
  font-size: 15px;
}

/* 编辑器容器高度控制 */
.editor-container {
  /* 给编辑器留足空间，包括工具栏和编辑区 */
  margin-bottom: 60px; 
}

/* 已提交内容展示区域 */
.submission-display {
  min-height: 150px;
  background-color: #f0f9eb; /* 浅绿色背景表示已完成 */
  border-color: #e1f3d8;
  overflow-x: auto; /* 防止大图溢出 */
}

/* 覆盖 Quill 默认样式以匹配 Element UI */
::v-deep .ql-container {
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  font-size: 14px;
}

::v-deep .ql-editor {
  min-height: 200px;
}
</style>