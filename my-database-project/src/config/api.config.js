/*
 * @Author: Garyonit 3253975221@qq.com
 * @Date: 2025-12-11 00:16:43
 * @LastEditors: kusachan 3253975221@qq.com
 * @LastEditTime: 2025-12-15 16:25:29
 * @FilePath: \my-database-project\src\config\api.config.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
export default {
  // ==========================
  // 用户认证 (Auth)
  // ==========================
  'register': {
    url: '/register',
    method: 'POST',
    rsaKey: 'password',
    setToken: true,
  },
  'login': {
    url: '/login',
    method: 'POST',
    rsaKey: 'password', // 登录时对密码加密
    setToken: true
  },

  // ==========================
  // 学生模块 (Student)
  // RESTful: /student
  // ==========================
  'student': {
    url: '/student',      // 获取列表
    method: 'GET'
  },
  'studentAdd': {
    url: '/student',      // 新增学生使用 POST 请求，URL 与获取列表相同
    method: 'POST'
  },
  'studentDelete': {
    url: '/student/:studentId',  // 删除通常使用 DELETE 请求，需要在 URL 中携带 ID
    method: 'DELETE',
    rest: true            // 开启 RESTful 替换模式 (你的 Http 封装需要这个标记)
  },
  'studentEdit': {        // 修改功能
    url: '/student/:studentId',
    method: 'PUT',
    rest: true
  },

  // ==========================
  // 课程模块 (Course)
  // RESTful: /course
  // ==========================
  'course': {
    url: '/course',
    method: 'GET'
  },
  'courseAdd': {
    url: '/course',
    method: 'POST'
  },
  'courseDelete': {
    url: '/course/:courseId', 
    method: 'DELETE',
    rest: true
  },
  'courseEdit':   { 
    url: '/course', 
    method: 'PUT' ,
  },

  // ==========================
  // 作业模块 (Homework)
  // RESTful: /homework
  // ==========================
  'homework': {
    url: '/homework',
    method: 'GET'
  },
  'homeworkAdd': {
    url: '/homework',
    method: 'POST'
  },
  'homeworkDelete': {
    url: '/homework/:courseId',
    method: 'DELETE',
    rest: true
  },
  'homeworkSubmit': {
    url: '/homework/submit/:id',
    method: 'POST',
    rest: true
  }
}