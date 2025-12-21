<template>
  <div class="scroll-section" style="margin-bottom: 80px">
    <h2 class="section-title scroll-hidden">❓ 常见问题 FAQ</h2>
    <div class="faq-container scroll-hidden" style="transition-delay: 200ms">
      <el-card shadow="never" class="faq-card">
        <el-collapse v-model="activeFaqComputed" accordion>
          <el-collapse-item
            v-for="item in faqList"
            :key="item.id"
            :name="item.id"
          >
            <template slot="title">
              <span class="faq-question">
                {{ item.question }}
              </span>
            </template>
            <div class="faq-answer">{{ item.answer }}</div>
          </el-collapse-item>
        </el-collapse>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FaqSection',
  props: {
    faqList: {
      type: Array,
      default: () => []
    },
    activeFaq: {
      type: [String, Array],
      default: () => ['1']
    }
  },
  computed: {
    activeFaqComputed: {
      get() {
        return this.activeFaq;
      },
      set(val) {
        this.$emit('update:activeFaq', val);
      }
    }
  }
};
</script>

<style scoped>
.scroll-section {
  margin-top: 80px;
}

.section-title {
  text-align: center;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
    "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  font-size: 30px;
  font-weight: 600;
  color: #ff69b4;
  margin-bottom: 45px;
  letter-spacing: 1px;
}

.scroll-hidden {
  opacity: 0;
  transform: translateY(50px);
  transition: all 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.scroll-visible {
  opacity: 1;
  transform: translateY(0);
}

.faq-container {
  max-width: 1000px;
  margin: 0 auto;
}
.faq-card {
  border-radius: 12px;
  border: 1px solid #ffe6f0;
}
.faq-question {
  font-weight: bold;
  font-size: 15px;
  color: #303133;
}
.faq-answer {
  color: #666;
  line-height: 2.4;
  padding: 10px 0;
}
::v-deep .el-collapse-item__header {
  height: 80px;
  line-height: 60px;
  font-size: 20px;
}
::v-deep .el-collapse-item__header.is-active {
  color: #ff69b4;
}
</style>

