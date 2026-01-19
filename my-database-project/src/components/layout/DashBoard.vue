<template>
  <div class="dashboard-container">
    <!-- 统计卡片 -->
    <StatsCards v-if="isLoggedIn" :stats="stats" :user-role="userRole" />

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
        <TeachingCalendar />
      </el-col>
      <el-col :span="8">
        <NewsTimeline />
      </el-col>
    </el-row>

    <!-- ============== 滚动动画区域 ============== -->

    <!-- 板块 1: 热门课程 -->
    <RecommendCourses :courses="recommendCourses" />

    <!-- 板块 2: 常见问题 FAQ -->
    <FaqSection :faq-list="faqList" :active-faq.sync="activeFaq" />

    <!-- 板块 3: 优秀作业 -->
    <ExcellentWorks :works="excellentWorks" />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import OracleCarouselVue from "@/components/features/OracleCarousel.vue";
import StatsCards from "@/components/features/StatsCards.vue";
import TeachingCalendar from "@/components/features/TeachingCalendar.vue";
import NewsTimeline from "@/components/features/NewsTimeline.vue";
import RecommendCourses from "@/components/features/RecommendCourses.vue";
import FaqSection from "@/components/features/FaqSection.vue";
import ExcellentWorks from "@/components/features/ExcellentWorks.vue";

export default {
  name: "DashBoard",
  components: {
    OracleCarouselVue,
    StatsCards,
    TeachingCalendar,
    NewsTimeline,
    RecommendCourses,
    FaqSection,
    ExcellentWorks,
  },
  data() {
    return {
      currentDate: new Date(),
      stats: {
        studentCount: 0,
        courseCount: 0,
        ongoingHomework: 0,
        pendingGrade: 0,
      },
      carouselItems: [
        //轮播图内容（飞天小女警主题）
        {
          id: 1,
          title: "守护城市的少女力量",
          description:
            "毛毛泡泡和花花，勇敢无畏地保卫飞天镇，每一天都充满冒险！",
          label: "飞天小女警",
          image: require("@/assets/img/carousel/bg1.png"),
          buttonText: "了解更多",
        },
        {
          id: 2,
          title: "团队协作，无法阻挡",
          description: "三位小女警用友情与智慧击退邪恶，为正义而战！",
          label: "梦想团队",
          image: require("@/assets/img/carousel/bg2.png"),
          buttonText: "加入冒险",
        },
        {
          id: 3,
          title: "专属于你的超级时刻",
          description: "快来体验飞天小女警的精彩瞬间，释放你的超级能量！",
          label: "超级时刻",
          image: require("@/assets/img/carousel/bg3.png"),
          buttonText: "开始体验",
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
      excellentWorks: [
        //优秀作业
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
      faqList: [
        //FAQ列表
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
    ...mapGetters(["userRole", "isLoggedIn", "userInfo"]),
  },
  watch: {
    isLoggedIn(newVal) {
      if (newVal) {
        this.fetchDashboardData();
      }
    },
  },
  mounted() {
    if (this.isLoggedIn) {
      this.fetchDashboardData();
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
    //  发起请求获取所需统计数据
    fetchDashboardData() {
      if (!this.isLoggedIn || !this.userInfo) return;

      this.$api({
        apiType: "dashboardStats",
        data: {
          id: this.userInfo.id,
          role: this.userInfo.role,
        },
      })
        .then((res) => {
          // 直接使用后端返回的统计数据
          this.stats = res.stats || res.data.stats;
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

/* 滚动动画相关样式 */
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
</style>