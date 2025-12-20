<template>
  <div class="oracle-carousel" @mouseenter="pause" @mouseleave="play">
    <!-- 1. 幻灯片区域 -->
    <div class="slides-container">
      <transition-group name="fade" tag="div">
        <!-- v-for循环遍历items数组，v-show根据currentIndex判断是否显示 -->
        <div 
          v-for="(item, index) in items" 
          :key="item.id" 
          v-show="currentIndex === index" 
          class="slide-item"
        >
          <!-- 
            修改点 1：独立的图片容器 (左上)
          -->
          <div class="slide-image-box" :style="{ backgroundImage: `url(${item.image})` }"></div>

          <!-- 
            修改点 2：内容卡片 (右下)
            尺寸现在与图片容器一致，形成错位重叠
          -->
          <div class="slide-card">
            <div class="card-inner">
              <h2 class="slide-title">{{ item.title }}</h2>
              <div class="divider"></div>
              <p class="slide-desc">{{ item.description }}</p>
              <div class="slide-actions">
                <el-button round class="cta-btn">
                  {{ item.buttonText || '了解更多' }} 
                  <i class="el-icon-right"></i>
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </transition-group>
    </div>

    <!-- 2. 底部指示条 -->
    <div class="indicators-wrapper">
      <div 
        v-for="(item, index) in items" 
        :key="index"
        class="indicator-item"
        :class="{ active: currentIndex === index }"
        @click="switchSlide(index)"
      >
        <div class="progress-bar-bg">
          <div 
            class="progress-bar-fill" 
            :style="getProgressStyle(index)"
          ></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OracleCarousel',
  props: {
    //轮播项
    items: {
      type: Array,
      required: true,
      default: () => []
    },
    //轮播间隔时间
    interval: {
      type: Number,
      default: 5000
    }
  },
  data() {
    return {
      currentIndex: 0,
      timer: null,
      isPaused: false
    };
  },
  mounted() {
    this.play();
  },
  beforeDestroy() {
    this.pause();
  },
  methods: {
    play() {
      this.isPaused = false;
      this.stopTimer();
      //设置定时器，每隔interval时间执行一次next()
      this.timer = setInterval(() => {
        this.next();
      }, this.interval);
    },
    pause() {
      this.isPaused = true;
      this.stopTimer();
    },
    stopTimer() {
      if (this.timer) {
        clearInterval(this.timer);
        this.timer = null;
      }
    },
    next() {
      //计算当前索引，如果到达最后一个，则返回第一个
      this.currentIndex = (this.currentIndex + 1) % this.items.length;
    },
    switchSlide(index) {
      this.currentIndex = index;
      if (!this.isPaused) {
        this.play();
      }
    },
    getProgressStyle(index) {
      if (index === this.currentIndex) {
        return this.isPaused 
          ? { width: '100%', transition: 'none' } 
          : { animation: `progress ${this.interval}ms linear forwards` };
      } else {
        return { width: '0', transition: 'none' };
      }
    }
  }
};
</script>

<style scoped>
/* 引入可爱字体 */
@import url("https://fonts.font.im/css2?family=ZCOOL+KuaiLe&display=swap");

.oracle-carousel {
  position: relative;
  width: 100%;
  height: 500px; /* 增加高度以适应错位布局 */
  overflow: hidden;
  background-color: transparent; /* 背景透明，透出页面背景 */
  /* 如果希望组件自身有背景，可以用下面这行 */
  /* background-color: #fceef5; */
}

/* --- 幻灯片区域 --- */
.slides-container {
  width: 100%;
  height: 100%;
  position: relative;
  /* 增加内边距，给错位留出呼吸空间 */
  padding: 20px; 
  box-sizing: border-box;
}

.slide-item {
  position: absolute;
  top: 20px;
  left: 20px;
  right: 20px;
  bottom: 20px;
}

/* --- 核心布局：图片容器 (左上) --- */
.slide-image-box {
  position: absolute;
  top: 0;
  left: 0;
  width: 65%; /* 宽 65% */
  height: 80%; /* 高 80% */
  background-size: cover;
  background-position: center;
  border-radius: 20px;
  box-shadow: 0 15px 35px rgba(0,0,0,0.1);
  z-index: 1; /* 底层 */
}

/* --- 核心布局：卡片容器 (右下) --- */
.slide-card {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 65%;  /* 与图片尺寸相同 */
  height: 80%; /* 与图片尺寸相同 */
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  box-shadow: -10px -10px 40px rgba(255, 105, 180, 0.15); /* 粉色光晕 */
  z-index: 2; /* 顶层，覆盖图片右下角 */
  display: flex;
  flex-direction: column;
  justify-content: center; /* 内容垂直居中 */
  border: 1px solid rgba(255,255,255,0.8);
  
  /* 进场动画 */
  animation: slideInRight 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.card-inner {
  padding: 40px 60px; /* 增加内边距 */
  /* 因为卡片和图片重叠了，文字如果太靠左会挡住图片太多的美感 
    所以我们可以让文字稍微靠右一些，或者保持左对齐
  */
  max-width: 100%;
}

.slide-title {
  font-family: 'ZCOOL KuaiLe', cursive, sans-serif;
  font-size: 42px;
  color: #333;
  margin-bottom: 20px;
  line-height: 1.2;
}

.divider {
  width: 60px;
  height: 6px;
  background: linear-gradient(90deg, #ff69b4, #ffb6c1);
  margin-bottom: 25px;
  border-radius: 3px;
}

.slide-desc {
  font-size: 18px;
  color: #666;
  margin-bottom: 40px;
  line-height: 1.8;
  max-width: 90%;
}

.cta-btn {
  background: linear-gradient(90deg, #ff69b4, #ff85c2);
  border: none;
  color: white;
  font-weight: bold;
  padding: 14px 36px;
  font-size: 16px;
  transition: all 0.3s;
  box-shadow: 0 6px 20px rgba(255, 105, 180, 0.3);
}

.cta-btn:hover {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 10px 25px rgba(255, 105, 180, 0.4);
}

/* --- 底部指示条 --- */
.indicators-wrapper {
  position: absolute;
  bottom: 40px; /* 抬高一点，放在卡片内部或上方 */
  left: 50%; /* 也可以改为 right: 40px 跟随卡片 */
  transform: translateX(-50%);
  z-index: 10;
  display: flex;
  gap: 12px;
}

/* 如果想把指示器放在卡片右下角，可以用这段覆盖上面的
.indicators-wrapper {
  bottom: 40px;
  left: auto;
  right: 60px;
  transform: none;
}
*/

.indicator-item {
  width: 40px; 
  height: 20px; 
  cursor: pointer;
  display: flex;
  align-items: center;
}

/* 进度条背景 - 深色一点以便在白色卡片上可见 */
.progress-bar-bg {
  width: 100%;
  height: 4px; 
  background-color: #e0e0e0; /* 浅灰 */
  border-radius: 2px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  background-color: #ff69b4; 
  width: 0;
  box-shadow: 0 0 8px rgba(255, 105, 180, 0.6);
}

@keyframes progress {
  from { width: 0; }
  to { width: 100%; }
}

@keyframes slideInRight {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}

/* 移动端适配 */
@media (max-width: 768px) {
  .oracle-carousel { height: 600px; }
  .slide-image-box {
    width: 100%;
    height: 45%;
    top: 0;
    left: 0;
    border-radius: 12px 12px 0 0;
  }
  .slide-card {
    width: 100%;
    height: 60%;
    bottom: 0;
    right: 0;
    border-radius: 0 0 12px 12px;
    background: white;
  }
  .card-inner { padding: 30px; }
  .slide-title { font-size: 28px; }
  .indicators-wrapper { bottom: 20px; }
}

/* Vue 过渡动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.8s ease;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>