<template>
  <div class="expandable-search" :class="{ 'is-expanded': isExpanded }">
    <el-button 
      type="text" 
      icon="el-icon-search" 
      @click="handleSearchClick"
      class="search-btn"
    ></el-button>
    
    <!-- 可伸缩输入框 -->
    <el-input
      ref="searchInput"
      v-model="modelValue"
      :placeholder="placeholder"
      class="search-input"
      clearable
      @keyup.enter.native="handleSearch"
      @blur="handleBlur"
      @clear="handleSearch"
    >
      <!-- 新增右侧收缩箭头 -->
      <i 
        slot="suffix" 
        class="el-input__icon el-icon-arrow-right collapse-btn" 
        @mousedown.prevent
        @click="handleCollapse"
      ></i>
    </el-input>
  </div>
</template>

<script>
export default {
  name: 'ExpandableSearch',
  props: {
    // 双向绑定值
    value: {
      type: String,
      default: ''
    },
    // 占位符
    placeholder: {
      type: String,
      default: '请输入关键字...'
    }
  },
  data() {
    return {
      isExpanded: false   //是否展开
    };
  },
  computed: {
    // 保持第一版的逻辑：处理 v-model 双向绑定
    modelValue: {
      get() {
        return this.value;
      },
      set(val) {
        this.$emit('input', val);  //向父组件传递输入值
      }
    }
  },
  methods: {
    //点击放大镜按钮
    handleSearchClick() {
      //如果未展开，则展开
      if (!this.isExpanded) {  
        // 展开并聚焦
        this.isExpanded = true;
        this.$nextTick(() => {
          this.$refs.searchInput.focus();
        });
      } else {
        // 已展开状态下点击，触发搜索
        this.handleSearch();
      }
    },
    //失去焦点事件
    handleBlur() {
      // 失去焦点且内容为空时，自动收起
      // 如果内容不为空，保持展开状态，等待用户点击箭头收起
      if (!this.modelValue) {
        this.isExpanded = false;
      }
    },
    // 手动收起
    handleCollapse() {
      this.isExpanded = false;
    },
    //搜索事件
    handleSearch() {
      // 通知父组件执行搜索逻辑
      this.$emit('search');
    }
  }
};
</script>

<style scoped>
.expandable-search {
  display: flex;
  align-items: center;
  position: relative;
  height: 40px; 
}

.search-btn {
  z-index: 2;
  position: relative;
  transition: all 0.3s;
  /* 修改点：放大镜样式调整 */
  font-size: 20px !important; /* 图标大一点 */
  font-weight: bold !important; /* 加粗 */
  color: #606266; /* 深灰色，去掉原来的白色 */
  padding: 8px; /* 调整点击区域 */
}

/* 悬停时稍微变色 */
.search-btn:hover {
  color: #409EFF;
}

.search-input {
  width: 0;
  opacity: 0;
  margin-left: -10px; /* 调整初始位置 */
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.18, 0.89, 0.32, 1.28);
}

.expandable-search.is-expanded .search-input {
  width: 320px;
  opacity: 1;
  margin-left: 5px;
}

/* 收缩箭头样式 */
.collapse-btn {
  cursor: pointer;
  font-weight: bold;
  color: #909399;
  transition: color 0.3s;
}
.collapse-btn:hover {
  color: #409EFF;
}

::v-deep .search-input .el-input__inner {
  border-radius: 4px;
  padding-left: 15px;
  background-color: #f5f7fa;
  border: 1px solid #dcdfe6;
}

::v-deep .search-input .el-input__inner:focus {
  background-color: #fff;
  border-color: #409EFF;
}
</style>