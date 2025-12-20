<template>
  <div class="dashboard-container">
    <!-- ... 上半部分 (统计卡片、轮播图、日历动态) 保持不变 ... -->
    <el-row :gutter="20" style="margin-bottom: 20px" v-if="isLoggedIn">
      <el-col :span="6" v-if="userRole === 'teacher'">
        <el-card
          shadow="hover"
          class="data-card"
          :style="getCardStyle('student_bg.png', '#409EFF')"
        >
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">{{ stats.student }}</div>
              <div class="card-text">学生总数</div>
            </div>
            <i class="el-icon-user-solid card-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card
          shadow="hover"
          class="data-card"
          :style="getCardStyle('course_bg.png', '#67C23A')"
        >
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">{{ stats.course }}</div>
              <div class="card-text">课程总数</div>
            </div>
            <i class="el-icon-reading card-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card
          shadow="hover"
          class="data-card"
          :style="getCardStyle('homework_bg.png', '#E6A23C')"
        >
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">{{ stats.homework }}</div>
              <div class="card-text">进行中的作业</div>
            </div>
            <i class="el-icon-notebook-1 card-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="userRole === 'student'">
        <el-card
          shadow="hover"
          class="data-card"
          :style="getCardStyle('warning_bg.png', '#F56C6C')"
        >
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">3</div>
              <div class="card-text">预警课程</div>
            </div>
            <i class="el-icon-warning-outline card-icon"></i>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="userRole === 'teacher'">
        <el-card
          shadow="hover"
          class="data-card"
          :style="getCardStyle('mark_bg.png', '#42b983')"
        >
          <div class="card-content">
            <div class="card-left">
              <div class="card-num">8</div>
              <div class="card-text">待批改</div>
            </div>
            <i class="el-icon-edit-outline card-icon"></i>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 轮播图 -->
    <div v-else class="welcome-carousel">
      <OracleCarouselVue
        :items="carouselItems"
        :interval="6000"
      ></OracleCarouselVue>
    </div>

    <!-- 中间部分：日历和动态 -->
    <el-row :gutter="20">
      <el-col :span="16">
        <el-card shadow="never" class="pink-theme-card">
          <div slot="header" class="cute-header"><span>📅 教学日历</span></div>
          <el-calendar v-model="currentDate">
            <template slot="dateCell" slot-scope="{ data }">
              <p :class="data.isSelected ? 'is-selected' : ''">
                {{ data.day.split("-").slice(1).join("-") }}
                <span v-if="data.day === '2025-12-25'">🎄</span>
              </p>
            </template>
          </el-calendar>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="never" class="pink-theme-card">
          <div slot="header" class="cute-header">
            <span>🔔 最新动态</span>
            <el-button
              style="float: right; padding: 3px 0; color: #ff69b4"
              type="text"
              >全部标为已读</el-button
            >
          </div>
          <div style="overflow-y: auto">
            <el-timeline>
              <el-timeline-item
                timestamp="2025/12/01"
                placement="top"
                color="#ff69b4"
              >
                <el-card
                  ><h4>发布了新作业</h4>
                  <p>王老师 发布了《微积分期中测试》</p></el-card
                >
              </el-timeline-item>
              <el-timeline-item
                timestamp="2025/11/28"
                placement="top"
                color="#ffb6c1"
              >
                <el-card
                  ><h4>学生提交提醒</h4>
                  <p>李明 提交了《Java 基础》作业</p></el-card
                >
              </el-timeline-item>
              <el-timeline-item
                timestamp="2025/11/25"
                placement="top"
                color="#ffb6c1"
              >
                <el-card
                  ><h4>发布了新作业</h4>
                  <p>祥老师 发布了《春日影》</p></el-card
                >
              </el-timeline-item>
            </el-timeline>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- ============== 滚动动画区域 ============== -->

    <!-- 板块 1: 热门课程 (简约风重构) -->
    <div class="scroll-section">
      <h2 class="section-title scroll-hidden">✨ 开启您的独享创作之旅</h2>
      <el-row :gutter="50" type="flex" justify="center">
        <el-col
          :span="6"
          v-for="(course, index) in recommendCourses"
          :key="course.id"
          class="scroll-hidden"
          :style="{ transitionDelay: `${index * 100}ms` }"
        >
          <el-card
            shadow="hover"
            class="display-card minimal-course-card"
            :body-style="{
              padding: '40px 30px',
              height: '100%',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
            }"
          >
            <div class="minimal-icon" :style="{ color: course.color }">
              <i :class="course.icon"></i>
            </div>
            <h3 class="minimal-title">{{ course.title }}</h3>
            <p class="mid-desc">{{ course.desc }}</p>
            <p class="minimal-desc">{{ course.minDesc }}</p>
            <el-button type="primary" class="pink-btn-wide"
              >Try Claude</el-button
            >
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 板块 2: 常见问题 FAQ  -->
    <div class="scroll-section" style="margin-bottom: 80px">
      <h2 class="section-title scroll-hidden">❓ 常见问题 FAQ</h2>
      <div class="faq-container scroll-hidden" style="transition-delay: 200ms">
        <el-card shadow="never" class="faq-card">
          <el-collapse v-model="activeFaq" accordion>
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

    <!-- 板块 3: 优秀作业 -->
    <div class="scroll-section">
      <h2 class="section-title scroll-hidden">🏆 优秀作业展示</h2>
      <!-- 
        修改说明：
        1. flex-wrap: wrap 允许换行
        2. gutter 保持 20
      -->
      <el-row :gutter="20" type="flex" justify="center" style="flex-wrap: wrap">
        <!-- 
          修改说明：
          1. span 改为 8 (24/8 = 3个每行)
          2. style 中添加 margin-bottom 以增加行间距
        -->
        <el-col
          :span="8"
          v-for="(work, index) in excellentWorks"
          :key="work.id"
          class="scroll-hidden"
          :style="{ transitionDelay: `${index * 100}ms`, marginBottom: '30px' }"
        >
          <el-card shadow="hover" class="display-card work-card">
            <div class="work-header">
              <el-avatar size="small" :src="work.avatar"></el-avatar>
              <span class="author-name">{{ work.author }}</span>
              <el-tag size="mini" type="danger" effect="plain">A+</el-tag>
            </div>
            <div class="work-content">
              <h4>{{ work.title }}</h4>
              <p>{{ work.comment }}</p>
            </div>
            <div class="work-footer">
              <span><i class="el-icon-view"></i> {{ work.views }}</span>
              <span><i class="el-icon-star-off"></i> {{ work.likes }}</span>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import OracleCarouselVue from "@/components/features/OracleCarousel.vue";

export default {
  name: "DashBoard",
  components: {
    OracleCarouselVue,
  },
  data() {
    return {
      currentDate: new Date(),
      stats: { student: 0, course: 0, homework: 0 },
      carouselItems: [  //轮播图内容
        {
          id: 1,
          title: "构建未来的云基础设施",
          description: "通过我们的下一代云技术，加速您的数字化转型。",
          label: "云基础设施",
          image: require("@/assets/img/carousel/bg1.png"),
          buttonText: "探索解决方案",
        },
        {
          id: 2,
          title: "智能数据分析平台",
          description: "利用 AI 驱动的分析工具挖掘价值。",
          label: "数据分析",
          image: require("@/assets/img/carousel/bg2.png"),
          buttonText: "免费试用",
        },
        {
          id: 3,
          title: "全新开发者生态系统",
          description: "加入全球数百万开发者的行列。",
          label: "开发者社区",
          image: require("@/assets/img/carousel/bg3.png"),
          buttonText: "立即加入",
        },
      ],
      recommendCourses: [ 
        {
          id: 1,
          title: "Pro",
          desc: "Claude Code is included in your Pro plan. Perfect for short coding sprints in small codebases with access to both Sonnet 4.5 and Opus 4.5.",
          minDesc:
            "Per month with annual subscription discount ($200 billed up front). $20 if billed monthly.",
          icon: "el-icon-s-data",
          color: "#ff9a9e",
        },
        {
          id: 2,
          title: "Plus",
          desc: "Claude Code is included in your Max plan. Great value for everyday use in larger codebases.",
          minDesc: "Per person billed monthly.",
          icon: "el-icon-monitor",
          color: "#a18cd1",
        },
        {
          id: 3,
          title: "Max",
          desc: "Even more Claude Code included in your Max plan. Great value for power users with the most access to Claude models.",
          minDesc: "Per person billed monthly.",
          icon: "el-icon-cpu",
          color: "#fad0c4",
        },
      ],
      excellentWorks: [   //优秀作业
        {
          id: 1,
          title: "图书馆管理系统",
          author: "张三",
          comment: "逻辑清晰，代码规范，界面美观。",
          views: 120,
          likes: 45,
          avatar: "",
        },
        {
          id: 2,
          title: "个人博客搭建",
          author: "李四",
          comment: "使用了最新的技术栈，部署完善。",
          views: 89,
          likes: 32,
          avatar: "",
        },
        {
          id: 3,
          title: "校园导航小程序",
          author: "王五",
          comment: "解决了实际痛点，交互体验极佳。",
          views: 230,
          likes: 88,
          avatar: "",
        },
        {
          id: 4,
          title: "数据可视化大屏",
          author: "赵六",
          comment: "色彩搭配和谐，数据展示直观。",
          views: 156,
          likes: 60,
          avatar: "",
        },
        {
          id: 5,
          title: "学生考勤系统",
          author: "钱七",
          comment: "功能完整，后台管理方便高效。",
          views: 110,
          likes: 50,
          avatar: "",
        },
        {
          id: 6,
          title: "在线点餐平台",
          author: "孙八",
          comment: "前端交互流畅，购物车逻辑严谨。",
          views: 198,
          likes: 72,
          avatar: "",
        },
      ],
      activeFaq: ["1"],
      faqList: [      //FAQ列表
        {
          id: "1",
          question: "如何修改我的个人信息？",
          answer:
            '登录后，点击右上角头像进入"个人中心"，点击"编辑资料"按钮即可修改姓名、邮箱和电话。',
        },
        {
          id: "2",
          question: "作业提交后还能修改吗？",
          answer:
            '在作业截止日期之前，您可以随时进入作业详情页，点击"撤销提交"后重新编辑并提交您的作业。',
        },
        {
          id: "3",
          question: "如果忘记密码怎么办？",
          answer:
            "目前系统暂不支持自助找回密码，请联系教务处管理员或您的辅导员进行密码重置。",
        },
        {
          id: "4",
          question: '为什么看不到"添加课程"的按钮？',
          answer:
            '只有"教师"角色的账号才拥有课程管理权限。如果您是老师但无法操作，请联系管理员核实权限。',
        },
        {
          id: "5",
          question: "如何查看我的作业成绩？",
          answer:
            '进入"作业列表"页面，找到已批改的作业，点击进入详情页即可查看您的分数和教师评语。已批改的作业会在状态栏显示"已批改"标签。',
        },
        {
          id: "6",
          question: "作业提交时可以使用哪些格式？",
          answer:
            "系统支持富文本编辑，您可以添加文字、图片、代码块等内容。建议使用清晰的格式，方便老师批改。提交前请仔细检查内容是否完整。",
        },
        {
          id: "7",
          question: "教师如何批改学生作业？",
          answer:
            '教师进入"作业批改"页面，可以看到所有学生的提交情况。点击"批改作业"按钮，查看学生提交内容后，输入分数和评语即可完成批改。',
        },
        {
          id: "8",
          question: "如何查看作业的统计信息？",
          answer:
            "在作业批改页面，系统会自动显示已提交人数、已批改人数、平均分、最高分和最低分等统计信息，帮助教师了解整体作业完成情况。",
        },
        {
          id: "9",
          question: "学生可以看到其他同学的作业吗？",
          answer:
            "不可以。每个学生只能查看和编辑自己的作业内容，无法查看其他同学的提交情况，保护学生隐私和作业独立性。",
        },
        {
          id: "10",
          question: "作业截止后还能提交吗？",
          answer:
            "作业截止后系统将关闭提交功能。如遇特殊情况需要补交，请联系任课教师，由教师在后台为您开放补交权限。",
        },
      ],
      observer: null,
    };
  },
  computed: {
    ...mapGetters(["userRole", "isLoggedIn"]),
  },
  watch: {
    isLoggedIn(newVal) {
      if (newVal) {
        //this.fetchDashboardData();
      }
    },
  },
  mounted() {
    if (this.isLoggedIn) {
      //this.fetchDashboardData();
    }
    this.initScrollObserver();
  },
  beforeDestroy() {
    if (this.observer) {
      this.observer.disconnect();
    }
  },
  methods: {
    initScrollObserver() {
      this.observer = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              entry.target.classList.add("scroll-visible");
              this.observer.unobserve(entry.target);
            }
          });
        },
        {
          threshold: 0.1,
          rootMargin: "0px 0px -50px 0px",
        }
      );

      this.$nextTick(() => {
        const elements = document.querySelectorAll(".scroll-hidden");
        elements.forEach((el) => {
          this.observer.observe(el);
        });
      });
    },

    getCardStyle(imageName, fallbackColor) {
      try {
        const imgUrl = require(`@/assets/img/dashboard/${imageName}`);
        const maskColor = fallbackColor + "CC";
        return {
          backgroundImage: `linear-gradient(${maskColor}, ${maskColor}), url(${imgUrl})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
          color: "white",
          border: "none",
        };
      } catch (e) {
        return { background: fallbackColor, color: "white", border: "none" };
      }
    },
    //  发起请求获得所需的三个total
    fetchDashboardData() {
      if (!this.isLoggedIn) return;
      Promise.all([
        this.$api({ apiType: "student", data: { page: 1, pageSize: 1 } }),
        this.$api({ apiType: "course", data: { page: 1, pageSize: 1 } }),
        this.$api({ apiType: "homework", data: { page: 1, pageSize: 1 } }),
      ])
        .then(([s, c, h]) => {
          this.stats.student = s.total || 0;
          this.stats.course = c.total || 0;
          this.stats.homework = h.total || 0;
        })
        .catch((err) => {
          console.error("获取看板数据失败:", err);
        });
    },
  },
};
</script>

<style scoped>
@import url("https://fonts.font.im/css2?family=ZCOOL+KuaiLe&display=swap");

.data-card {
  cursor: pointer;
  transition: transform 0.3s;
  overflow: hidden;
}
.data-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}
.card-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80px;
  padding: 20px;
}
.card-num {
  font-size: 32px;
  font-weight: bold;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}
.card-text {
  font-size: 14px;
  opacity: 0.9;
  margin-top: 5px;
}
.card-icon {
  font-size: 48px;
  opacity: 0.8;
}

.cute-header span {
  font-family: "ZCOOL KuaiLe", cursive, sans-serif;
  font-size: 20px;
  color: #ff69b4;
}
::v-deep .el-calendar__header {
  border-bottom: 1px solid #ffe6f0;
}
::v-deep .el-calendar__title,
::v-deep .el-calendar-table thead th {
  color: #ff69b4;
}
::v-deep .el-calendar-table .el-calendar-day:hover {
  background-color: #fff0f5;
}
::v-deep .el-calendar-table td.is-selected .el-calendar-day {
  background-color: #ffe6f0;
  color: #ff69b4;
}
::v-deep .el-calendar-table td.is-today,
.is-selected {
  color: #ff69b4;
  font-weight: bold;
}
::v-deep .el-timeline-item__timestamp {
  color: #909399;
}

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

.display-card {
  border: none;
  border-radius: 16px;
  transition: transform 0.3s, box-shadow 0.3s;
  overflow: hidden;
  height: 100%;
}

.display-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 30px rgba(255, 105, 180, 0.15);
}

.minimal-course-card {
  min-height: 420px;
  border: 1px solid #fff0f5;
}

.minimal-icon {
  font-size: 56px;
  margin-bottom: 25px;
  transition: transform 0.3s;
}
.minimal-course-card:hover .minimal-icon {
  transform: scale(1.1);
}

.minimal-title {
  margin: 0 0 15px 0;
  font-size: 30px;
  font-weight: bold;
  color: #333;
  text-align: left;
  width: 100%;
}

.mid-desc {
  color: #666;
  font-size: 18px;
  line-height: 1.6;
  text-align: left;
  margin-bottom: 20px;
  overflow: hidden;
  height: 120px;
}

.minimal-desc {
  color: #666;
  font-size: 12px;
  font-weight: normal;
  text-align: left;
  width: 100%;
  margin-bottom: 20px;
  overflow: hidden;
  height: 48px;
}

.minimal-rating {
  margin-bottom: 25px;
}

.pink-btn-wide {
  width: 100%;
  margin-bottom: 6px;
  font-size: 16px;
  font-weight: 600;
  background: linear-gradient(90deg, #ff9a9e 0%, #ff69b4 100%);
  border: none;
  box-shadow: 0 4px 10px rgba(255, 105, 180, 0.3);
  transition: all 0.3s;
}
.pink-btn-wide:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(255, 105, 180, 0.4);
}

.work-card .el-card__body {
  margin: 20px 0;
  padding: 20px;
}
.work-header {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}
.author-name {
  margin-left: 10px;
  margin-right: auto;
  font-size: 14px;
  font-weight: bold;
  color: #606266;
}
.work-content h4 {
  margin: 10px 0;
  color: #303133;
}
.work-content p {
  font-size: 13px;
  color: #606266;
  background: #fff0f5;
  padding: 10px;
  border-radius: 6px;
  margin-bottom: 15px;
}
.work-footer {
  display: flex;
  justify-content: space-between;
  color: #909399;
  font-size: 12px;
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