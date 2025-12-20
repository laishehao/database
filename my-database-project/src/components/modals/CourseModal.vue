<template>
  <el-dialog 
    :title="isEdit ? '编辑课程' : '新建课程'" 
    :visible.sync="modalVisible" 
    width="600px"
    :before-close="handleClose"
    :close-on-click-modal="false"
  >
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
      
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="课程代码" prop="courseId">
            <el-input 
              v-model="form.courseId" 
              placeholder="例如: CS-101" 
              :disabled="isEdit"
            ></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="所属专业" prop="major">
            <el-select v-model="form.major" placeholder="请选择" style="width: 100%">
              <el-option label="计算机学院" value="计算机科学"></el-option>
              <el-option label="数学院" value="数学"></el-option>
              <el-option label="外国语学院" value="英语"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="课程名称" prop="courseName">
        <el-input v-model="form.courseName" placeholder="请输入课程全称"></el-input>
      </el-form-item>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="学分" prop="credits">
            <el-input-number v-model="form.credits" :min="0.5" :step="0.5" style="width: 100%"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="12">
           <el-form-item label="课程性质" prop="type">
            <el-radio-group v-model="form.type">
              <el-radio label="必修">必修</el-radio>
              <el-radio label="选修">选修</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="授课教师" prop="teacher">
        <el-input v-model="form.teacher" placeholder="请输入教师姓名"></el-input>
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
  name: 'CourseModal',
  props: {
    // 控制弹窗显示
    visible: {
      type: Boolean,
      default: false
    },
    // 接收行数据：有值代表编辑，null 代表新建
    rowData: {
      type: Object,
      default: null
    }
  },
  computed: {
    // 使用计算属性处理 .sync 修饰符，避免直接修改 prop 报错
    modalVisible: {
      get() { return this.visible; },
      set(val) { this.$emit('update:visible', val); }
    },
    // 判断当前是否为编辑模式
    isEdit() {
      return !!this.rowData;
    }
  },
  watch: {
    //(newValue, oldValue)
    visible(val) {
      if (val) {
        if (this.rowData) {
          // 深拷贝数据，避免直接修改父组件的 tableData
          this.form = JSON.parse(JSON.stringify(this.rowData));
        } else {
          this.form = {
            courseId: '',
            courseName: '',
            major: '',
            credits: 2.0,
            type: '必修',
            teacher: ''
          };
        }
        // 移除校验红字
        this.$nextTick(() => {
          if (this.$refs.formRef) {
            this.$refs.formRef.clearValidate();
          }
        });
      }
    }
  },
  data() {
    return {
      loading: false,
      form: {
        courseId: '',
        courseName: '',
        major: '',
        credits: 2.0,
        type: '必修',
        teacher: ''
      },
      rules: {
        courseId: [{ required: true, message: '请输入课程代码', trigger: 'blur' }],
        courseName: [{ required: true, message: '请输入课程名称', trigger: 'blur' }],
        major: [{ required: true, message: '请选择所属专业', trigger: 'change' }],
        teacher: [{ required: true, message: '请输入授课教师', trigger: 'blur' }]
      }
    };
  },
  methods: {
    // 关闭弹窗
    handleClose() {
      //触发set
      this.modalVisible = false;
    },
    // 提交表单
    handleSubmit() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.loading = true;
          const apiType = this.isEdit ? 'courseEdit' : 'courseAdd';

          this.$api({
            apiType: apiType,
            data: {
              role: 'teacher',
              ...this.form
            }
          }).then(() => {
            this.$message.success(this.isEdit ? '课程修改成功' : '课程创建成功');
            this.$emit('success');
          }).catch(error => {
            console.error(error);
            const errorMsg =  (this.isEdit ? '修改失败' : '创建失败');
            this.$message.error(errorMsg);
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