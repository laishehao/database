/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-07 19:47:33
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-16 00:30:35
 * @FilePath: \my-database-project\src\router\index.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AEVue
 */
import Vue from 'vue'
import VueRouter from 'vue-router'
import nProgress from 'nprogress'
import 'nprogress/nprogress.css'

import LayoutPage from '../components/LayoutPage.vue'
import CourseList from '../views/CourseList.vue'
import StudentList from '../views/StudentList.vue'
import HomeworkWrapper from '@/views/HomeworkWrapper.vue';
import HomeworkDetail from '@/views/HomeworkDetail.vue';
import DashBoard from '@/views/DashBoard.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    redirect: '/index',
    component: LayoutPage,
    children: [
      {
        path: '/index',
        name: 'index',
        component: DashBoard
      },
      {
        path: '/homework',
        name: 'homework',
        component: HomeworkWrapper
      },
      {
        path: '/homework/detail/:id',
        name: 'homeworkDetail',
        component: HomeworkDetail,
        meta: {
          title: '作业详情'
        }
      },
      {
        path: '/student',
        name: 'student',
        component: StudentList
      },
      {
        path: '/course',
        name: 'course',
        component: CourseList
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