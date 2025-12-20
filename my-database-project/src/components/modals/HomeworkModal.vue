<template>
  <el-dialog 
    :title="isEdit ? '编辑作业' : '发布新作业'" 
    :visible.sync="modalVisible" 
    width="600px"
    :before-close="handleClose"
    :close-on-click-modal="false"
  >
    <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
      <el-form-item label="作业名称" prop="title">
        <el-input v-model="form.title" placeholder="请输入作业名称"></el-input>
      </el-form-item>
      
      <el-form-item label="所属课程" prop="course">
        <el-select v-model="form.course" placeholder="请选择课程" style="width: 100%">
          <el-option label="高等数学" value="高等数学"></el-option>
          <el-option label="计算机科学" value="计算机科学"></el-option>
          <el-option label="大学英语" value="大学英语"></el-option>
          <el-option label="数据库系统原理" value="数据库系统原理"></el-option>
        </el-select>
      </el-form-item>

      <!-- 新增：作业内容字段 -->
      <el-form-item label="作业内容" prop="content">
        <el-input 
          type="textarea" 
          v-model="form.content" 
          :rows="4"
          placeholder="请输入作业详细要求或内容描述..."
        ></el-input>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取 消</el-button>
      <el-button type="primary" :loading="loading" @click="handleSubmit">确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  name: 'HomeworkModal',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    // 接收回显数据
    rowData: {
      type: Object,
      default: null
    }
  },
  computed: {
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); }
    },
    // 判断是否为编辑模式
    isEdit() {
      return !!this.rowData;
    }
  },
  watch: {
    visible(val) {
      if (val) {
        if (this.rowData) {
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = {
            title: '',
            course: '',
            content: '' // 初始化 content
          };
        }
        this.$nextTick(() => {
          this.$refs.formRef && this.$refs.formRef.clearValidate();
        });
      }
    }
  },
  data() {
    return {
      loading: false,
      form: {
        title: '',
        course: '',
        content: ''
      },
      rules: {
        title: [{ required: true, message: '请输入作业名称', trigger: 'blur' }],
        course: [{ required: true, message: '请选择所属课程', trigger: 'change' }],
        content: [{ required: true, message: '请输入作业内容', trigger: 'blur' }]
      }
    };
  },
  methods: {
    //关闭窗口
    handleClose() {
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          
          // 根据模式选择接口
          const apiType = this.isEdit ? 'homeworkEdit' : 'homeworkAdd';

          // 准备提交的数据
          const submitData = {
            ...this.form,
            ...(this.isEdit ? {} : { progress: 0, active: true })
          };

          this.$api({
            apiType: apiType,
            data: submitData
          }).then(() => {
            this.$message.success(this.isEdit ? '修改成功' : '发布成功');
            this.$emit('success');
            this.handleClose();
          }).catch(err => {
             console.error(err);
          }).finally(() => {
            this.loading = false;
          });
        }
      });
    }
  }
};
</script>