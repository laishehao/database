<!--
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-11 20:35:54
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-12 13:18:20
 * @FilePath: \my-database-project\src\components\HomeworkModal.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
<template>
  <el-dialog 
    title="发布新作业" 
    :visible.sync="modalVisible" 
    width="500px"
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
        </el-select>
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
    }
  },
  computed: {
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); }
    }
  },
  data() {
    return {
      loading: false,
      form: {
        title: '',
        course: ''
      },
      rules: {
        title: [{ required: true, message: '请输入作业名称', trigger: 'blur' }],
        course: [{ required: true, message: '请选择所属课程', trigger: 'change' }]
      }
    };
  },
  methods: {
    handleClose() {
      this.$refs.formRef.resetFields();
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.$api({
            apiType: 'homeworkAdd', 
            data: {
              ...this.form,
              progress: 0,
              active: true
            }
          }).then(() => {
            this.$message.success('发布成功');
            this.$emit('success');
            this.handleClose();
          }).finally(() => {
            this.loading = false;
          });
        }
      });
    }
  }
};
</script>