<template>
  <el-dialog 
    append-to-body
    :title="isEdit ? '编辑学生' : '添加学生'" 
    :visible.sync="modalVisible" 
    width="500px"
    :before-close="handleClose"
    :close-on-click-modal="false">
    <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
      <el-form-item label="学号" prop="studentId">
        <el-input v-model="form.studentId" placeholder="请输入学号" :disabled="isEdit"></el-input>
      </el-form-item>
      <el-form-item label="姓名" prop="name">
        <el-input v-model="form.name" placeholder="请输入姓名"></el-input>
      </el-form-item>
      <el-form-item label="性别" prop="gender">
        <el-radio-group v-model="form.gender">
          <el-radio label="男">男</el-radio>
          <el-radio label="女">女</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="专业" prop="major">
        <el-select v-model="form.major" placeholder="请选择专业" style="width: 100%">
          <el-option label="计算机科学" value="计算机科学"></el-option>
          <el-option label="软件工程" value="软件工程"></el-option>
          <el-option label="信息管理" value="信息管理"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="联系电话" prop="phone">
        <el-input v-model="form.phone" placeholder="请输入手机号" maxlength="11"></el-input>
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
  name: 'StudentModal',
  props: {
    visible: { type: Boolean, default: false },
    rowData: { type: Object, default: null }
  },
  computed: {
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); }
    },
    isEdit() {
      return !!this.rowData;
    }
  },
  watch: {
    visible(val) {
      if (val) {
        if (this.rowData) {
          // 深拷贝数据到 form (防止直接修改表格数据)
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = { studentId: '', name: '', gender: '男', major: '', phone: '', avatar: '' };
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
      form: { studentId: '',
        name: '',
        gender: '男',
        major: '',
        phone: '',
        avatar: '' 
      },
      rules: { studentId: [{ required: true, message: '请输入学号', trigger: 'blur' }],
        name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
        major: [{ required: true, message: '请选择专业', trigger: 'change' }],
        phone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ] 
      }
    };
  },
  methods: {
    handleClose() {
      this.modalVisible = false;
    },
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          const apiType = this.isEdit ? 'studentEdit' : 'studentAdd';
          
          this.$api({ apiType, data: {
            role: 'teacher', ...this.form} }).then(() => {
              this.$message.success(this.isEdit ? '修改成功' : '添加成功');
              this.$emit('success');
            }).catch(err => {
              console.error(err)
              const errMsg = this.isEdit ? '修改失败':'添加失败'
              this.$message.error(errMsg)
            }).finally(() => { 
              this.loading = false; 
              this.handleClose();
          });
        }
      });
    }
  }
};
</script>