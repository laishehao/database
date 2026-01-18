/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 19:47:33
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2026-01-19 01:30:39
 * @FilePath: \my-database-project\src\router\index.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AEVue
 */
import Vue from 'vue'
import VueRouter from 'vue-router'
import nProgress from 'nprogress'
import 'nprogress/nprogress.css'

import HomePage from '../views/HomePage.vue'
import CourseList from '../views/CourseList.vue'
import StudentList from '../views/StudentList.vue'
import HomeworkWrapper from '@/views/HomeworkWrapper.vue';
import HomeworkDetail from '@/views/HomeworkDetail.vue';
import DashBoard from '@/components/layout/DashBoard.vue'
import ProfilePage from '@/views/ProfilePage.vue'
import HomeworkGrading from '@/views/HomeworkGrading.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    cname: '主页',
    redirect: '/index',
    component: HomePage,
    children: [
      {
        path: '/index',
        name: 'index',
        cname: '主页',
        component: DashBoard
      },
      {
        path: '/homework',
        name: 'homework',
        cname: '作业列表',
        component: HomeworkWrapper
      },
      {
        path: '/homework/detail/:id',
        name: 'homeworkDetail',
        cname: '作业详情',
        component: HomeworkDetail,
        meta: {
          title: '作业详情'
        }
      },
      {
        path: '/homework/grade/:id',
        name: 'homeworkGrading',
        cname: '作业批改',
        component: HomeworkGrading,
        meta: { title: '作业批改' }
      },
      {
        path: '/student',
        name: 'student',
        cname: '学生列表',
        component: StudentList
      },
      {
        path: '/course',
        name: 'course',
        cname: '课程列表',
        component: CourseList
      },
      {
        path:'/profile',
        name: 'profile',
        cname: '个人主页',
        component: ProfilePage
      }
    ]
  }
]

const router = new VueRouter({
  routes
})

router.beforeEach((to, from, next) => {
  nProgress.start()
  next()
})
router.afterEach(() => {
  nProgress.done()
})

export default router