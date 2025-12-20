<template>
  <div class="music-app-container">
    <!-- 1. 顶级艺术播放器卡片 -->
    <transition name="music-super-pop">
      <!-- 
        🔴 修复核心：将 v-show 改为 v-if 
        这样点击关闭时，iframe 会被销毁，音乐就会停止播放。
      -->
      <div v-if="isExpanded" class="premium-player-card">
        <!-- 装饰性光斑 -->
        <div class="glass-light top-light"></div>
        <div class="glass-light bottom-light"></div>

        <!-- 头部导航栏 -->
        <div class="player-header">
          <div class="brand">
            <div class="live-indicator">
              <span class="dot"></span>
              <span class="pulse"></span>
            </div>
            <span class="brand-text">AURORA AUDIO</span>
          </div>
          <div class="close-action" @click="togglePlayer">
            <i class="el-icon-close"></i>
          </div>
        </div>

        <!-- 唱片与信息聚合区 -->
        <div class="player-body">
          <div class="vinyl-display">
            <div class="mini-vinyl" :class="{ rotating: isExpanded }">
              <!-- 修改点：使用本地封面图片，防止网络加载失败 -->
              <img :src="localCover" alt="cover" />
            </div>
          </div>
          
          <div class="player-meta">
            <div class="scrolling-title">
              <span class="text">正在播放 - Lofi Girl: beats to relax/study to (Spotify Embed)</span>
            </div>
            <div class="visualizer">
              <div v-for="i in 12" :key="i" class="bar" :style="{ animationDelay: `${i * 0.1}s` }"></div>
            </div>
          </div>
        </div>

        <!-- 播放器插槽 -->
        <div class="iframe-glass-slot">
          <!-- 
            注意：Spotify 嵌入播放器在中国大陆直连环境下可能无法播放音频。
          -->
          <iframe 
            style="border-radius:12px" 
            src="https://open.spotify.com/embed/playlist/0vvXsWCC9xrXsKd4FyS8kM?utm_source=generator&theme=0" 
            width="100%" 
            height="80" 
            frameBorder="0" 
            allowfullscreen="" 
            allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" 
            loading="lazy">
          </iframe>
        </div>

        <div class="player-footer">
          <span>POWERED BY SPOTIFY</span>
          <i class="el-icon-more-outline"></i>
        </div>
      </div>
    </transition>

    <!-- 2. 磁感悬浮球 -->
    <transition name="ball-pop">
      <div 
        v-show="!isExpanded"
        class="magnetic-ball" 
        @click="togglePlayer"
      >
        <div class="ball-inner">
          <!-- 修改点：悬浮球封面也同步使用本地图片 -->
          <img :src="localCover" alt="cover" />
          <div class="play-overlay">
            <i class="el-icon-video-play"></i>
          </div>
        </div>
        <div class="orbit"></div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'MusicPlayer',
  data() {
    return {
      isExpanded: false,
      localCover: require('@/assets/img/flower.png')
    };
  },
  methods: {
    togglePlayer() {
      this.isExpanded = !this.isExpanded;
    }
  }
};
</script>

<style scoped>
.music-app-container {
  position: fixed;
  bottom: 30px; 
  right: 30px;  
  z-index: 10000;
  width: 70px;
  height: 70px;
}

/* --- 1. 顶级玻璃卡片样式 --- */
.premium-player-card {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 380px;
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(35px) saturate(200%) contrast(110%);
  -webkit-backdrop-filter: blur(35px) saturate(200%);
  border-radius: 30px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 
    0 25px 50px rgba(0, 0, 0, 0.15),
    inset 0 0 20px rgba(255, 255, 255, 0.2);
  padding: 20px;
  overflow: hidden;
  transform-origin: bottom right; 
}

/* 装饰性光斑 */
.glass-light {
  position: absolute;
  width: 150px;
  height: 150px;
  border-radius: 50%;
  filter: blur(50px);
  z-index: 0;
  opacity: 0.4;
  pointer-events: none; 
}
.top-light { top: -50px; left: -50px; background: #ff69b4; }
.bottom-light { bottom: -50px; right: -50px; background: #00dbde; }

/* 头部 */
.player-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  position: relative;
  z-index: 1; 
}
.brand { display: flex; align-items: center; gap: 8px; }
.brand-text { font-size: 10px; font-weight: 900; letter-spacing: 2px; color: #555; }

.live-indicator { position: relative; width: 10px; height: 10px; }
.dot { position: absolute; width: 6px; height: 6px; background: #ff69b4; border-radius: 50%; top: 2px; left: 2px; }
.pulse { position: absolute; width: 10px; height: 10px; border: 2px solid #ff69b4; border-radius: 50%; animation: pulse-ring 2s infinite; }

.close-action {
  cursor: pointer;
  width: 28px;
  height: 28px;
  background: rgba(255,255,255,0.4);
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: 0.3s;
}
.close-action:hover { background: #fff; color: #ff69b4; transform: rotate(90deg); }

/* 主体内容 */
.player-body {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
  position: relative;
  z-index: 1;
}

.mini-vinyl {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background: #222;
  padding: 4px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}
.mini-vinyl img { width: 100%; height: 100%; border-radius: 50%; border: 2px solid #333; object-fit: cover; }
.rotating { animation: rotate 12s linear infinite; }

.player-meta { flex: 1; display: flex; flex-direction: column; justify-content: center; }

.scrolling-title {
  width: 200px;
  overflow: hidden;
  white-space: nowrap;
  font-size: 14px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
}
.scrolling-title .text {
  display: inline-block;
  padding-left: 100%;
  animation: scroll-text 15s linear infinite;
}

/* 律动条 */
.visualizer { display: flex; align-items: flex-end; gap: 3px; height: 20px; }
.bar { width: 3px; height: 5px; background: #ff69b4; border-radius: 2px; animation: bar-rise 0.8s ease-in-out infinite; }

/* Iframe 槽位 */
.iframe-glass-slot {
  background: rgba(255, 255, 255, 0.4);
  border-radius: 12px;
  padding: 0;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: inset 0 2px 10px rgba(0,0,0,0.05);
  position: relative;
  z-index: 2; 
  overflow: hidden;
  height: 82px;
  display: flex;
  align-items: center;
}

.player-footer {
  margin-top: 15px;
  display: flex;
  justify-content: space-between;
  font-size: 9px;
  color: #888;
  letter-spacing: 1px;
  font-weight: bold;
}

/* --- 2. 磁感悬浮球样式 --- */
.magnetic-ball {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 70px;
  height: 70px;
  cursor: pointer;
  transition: 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.magnetic-ball:hover { transform: scale(1.1); }

.ball-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  padding: 3px;
  background: linear-gradient(135deg, #ff69b4, #00dbde);
  position: relative;
  z-index: 2;
  box-shadow: 0 10px 25px rgba(255, 105, 180, 0.4);
}
.ball-inner img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; border: 2px solid white; }

.play-overlay {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(255, 105, 180, 0.4);
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-size: 24px;
  opacity: 0;
  transition: 0.3s;
}
.magnetic-ball:hover .play-overlay { opacity: 1; }

.orbit {
  position: absolute;
  top: -10px; left: -10px; right: -10px; bottom: -10px;
  border: 1px dashed rgba(255, 105, 180, 0.3);
  border-radius: 50%;
  animation: rotate 20s linear infinite;
}

/* --- 动画序列 --- */
@keyframes pulse-ring {
  0% { transform: scale(0.5); opacity: 1; }
  100% { transform: scale(1.5); opacity: 0; }
}

@keyframes bar-rise {
  0%, 100% { height: 4px; }
  50% { height: 18px; }
}

@keyframes scroll-text {
  0% { transform: translateX(0); }
  100% { transform: translateX(-100%); }
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 进场动画 */
.music-super-pop-enter-active {
  animation: super-pop-in 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.music-super-pop-leave-active {
  animation: super-pop-out 0.4s cubic-bezier(0.6, -0.28, 0.735, 0.045) forwards;
}

@keyframes super-pop-in {
  0% { opacity: 0; transform: scale(0.2); filter: blur(20px); }
  100% { opacity: 1; transform: scale(1); filter: blur(0); }
}

@keyframes super-pop-out {
  0% { opacity: 1; transform: scale(1); filter: blur(0); }
  100% { opacity: 0; transform: scale(0.1); filter: blur(15px); }
}

/* 悬浮球恢复动画 */
.ball-pop-enter-active {
  animation: ball-pop-in 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}
.ball-pop-leave-active {
  animation: ball-pop-out 0.3s ease-in forwards;
}

@keyframes ball-pop-in {
  0% { opacity: 0; transform: scale(0); }
  60% { transform: scale(1.15); }
  100% { opacity: 1; transform: scale(1); }
}

@keyframes ball-pop-out {
  from { opacity: 1; transform: scale(1); }
  to { opacity: 0; transform: scale(1.5); }
}
</style>