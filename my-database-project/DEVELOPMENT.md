开发文档 — my-database-project

项目概述
----------
这是一个面向教学/教务场景的前端示例项目，包含学生、课程、作业等模块的管理界面与演示功能。前端使用 Vue 2 + Element UI 进行构建，代码组织清晰，便于扩展真实后端 API。

主要文件说明（按仓库根目录与 `src/` 结构归类）
----------------------------------------------------------------

- `src/main.js`：应用入口，Vue 实例创建、全局插件注册（Element、HTTP 封装等）。
- `src/App.vue`：根组件，应用全局布局的外壳。

- `src/router/index.js`：前端路由配置，定义页面路由与导航守卫。
- `src/store/index.js`：Vuex 全局状态管理入口（用户信息、认证状态等）。

- `src/config/base.config.js`：基础配置（如常量、环境相关设置）。
- `src/config/api.config.js`：后端 API 列表配置。

- `src/plugins/element.js`：Element UI 按需/全局注册与配置。
- `src/plugins/http.js`：HTTP 客户端封装（基于 `src/config/api.config.js` 提供统一调用方式）。

- `src/api/common.js`、`src/api/http.js`：底层与公共 API 调用封装（Http wrapper、错误处理、请求中间件等）。

- `src/components/layout/`：
  - `AppHeader.vue`：应用顶部导航/用户信息展示。
  - `DashBoard.vue`：主面板（仪表盘），包含统计卡片、轮播、日历、动态等。
  - `SideMenu.vue`：侧边导航菜单组件。

- `src/components/features/`（各类 UI 小部件 / 页面片段）：
  - `OracleCarousel.vue`：项目轮播组件。
  - `StatsCards.vue`：统计卡（学生/课程/作业计数等）。
  - `TeachingCalendar.vue`：教学日历视图。
  - `NewsTimeline.vue`：消息/动态时间轴。
  - 其它（RecommendCourses、FaqSection、ExcellentWorks 等）为页面模块化展示组件。

- `src/components/modals/`：弹窗模态组件（用户登录/档案/课程/作业/学生相关表单模态）。
  - `AuthModal.vue`、`ProfileModal.vue`、`CourseModal.vue`、`HomeworkModal.vue`、`HomeworkGradeModal.vue`、`StudentModal.vue`

- `src/views/`（页面视图）：
  - `HomePage.vue`：主页/登陆后欢迎页（显示仪表盘等）。
  - `CourseList.vue`、`StudentList.vue`：课程/学生列表页。
  - `HomeworkList.vue`、`HomeworkDetail.vue`、`HomeworkGrading.vue`、`HomeworkCheckList.vue`：作业相关页面。
  - `ProfilePage.vue`：个人资料页。
  - `HomeworkWrapper.vue`：根据role的不同渲染作业管理页面/作业查看页面。

API（来自 `src/config/api.config.js`）
----------------------------------------------------------------
下面按 `api.config.js` 中的 key 列出本项目已配置的 API 映射（字段：key → URL → HTTP 方法 → 备注）：

- **register** → `/register` → `POST`  
  备注：用于用户注册，`rsaKey: 'password'` 指明发送前会对 password 做 RSA 加密，`setToken: true` 表示成功后会保存 token。

- **login** → `/login` → `POST`  
  备注：登录接口，`rsaKey: 'password'`、`setToken: true`（登录后存 token）。

- **profileSubmit** → `/api/user` → `POST`  
  备注：提交/更新用户个人信息。

学生（Student 模块）
- **student** → `/student` → `GET`  
  备注：获取学生列表。
- **studentAdd** → `/student` → `POST`  
  备注：新增学生。
- **studentDelete** → `/student/:studentId` → `DELETE`（rest: true）  
  备注：按 ID 删除学生，`rest: true` 表示框架会把 `:studentId` 替换为传入参数。
- **studentEdit** → `/student/:studentId` → `PUT`（rest: true）  
  备注：更新学生信息（RESTful 风格）。

课程（Course 模块）
- **course** → `/course` → `GET`  
  备注：获取课程列表。
- **courseAdd** → `/course` → `POST`  
  备注：新增课程。
- **courseDelete** → `/course/:courseId` → `DELETE`（rest: true）  
  备注：按 ID 删除课程。
- **courseEdit** → `/course/:courseId` → `PUT`（rest: true）    
  备注：更新课程。

作业（Homework 模块）
- **homework** → `/homework` → `GET`  
  备注：获取作业列表。
- **homeworkAdd** → `/homework` → `POST`  
  备注：新增作业。
- **homeworkEdit** → `/homework/:workId` → `PUT`（rest: true）    
  备注：编辑作业。
- **homeworkDelete** → `/homework/:workId` → `DELETE`（rest: true）  
  备注：按作业 ID 删除。
- **homeworkDetail** → `/homework/:workId` → `GET`（rest: true）  
  备注：获取单个作业详情。
- **homeworkSubmit** → `/homework/submit/:workId` → `POST`（rest: true）  
  备注：学生提交作业（提交到具体作业 ID）。
- **homeworkSubmissions** → `/homework/submissions` → `GET`  
  备注：获取作业提交列表（用于老师查看提交）。
- **homeworkGrade** → `/homework/grade` → `POST`  
  备注：提交作业批改结果（评分等）。

使用示例（客户端调用约定）
----------------------------------------------------------------
项目内的注释与插件提示典型的调用方式为（示例）：

```js
// 假设 http 插件把 api.config 的 key 映射到 this.$api
this.$api({
  apiType: 'homeworkSubmissions',
  data: { homeworkId: 1 }
})

// 或带 REST 替换的用法（框架会替换 :workId）
this.$api({
  apiType: 'homeworkDetail',
  rest: { workId: 123 }
})
```

建议与注意事项
----------------------------------------------------------------
- 检查 `src/plugins/http.js` 的实现以确认 `rest: true`、`rsaKey`、`setToken` 等字段的实际行为（是否自动替换、加密或存 token）。
- `courseEdit` 定义为 PUT 到 `/course`，请核实后端是否期待 ID 在 body 中或 RESTful 路径（如 `/course/:id`）。
- 若要新增 API，请在 `src/config/api.config.js` 添加映射，并在 `src/plugins/http.js` 中确认调用约定。

变更记录
----------------------------------------------------------------
- 2025-12-21: 创建初版开发文档，包含项目文件说明与 API 列表（由 `src/config/api.config.js` 提取）。

维护者
----------------------------------------------------------------
- 如果需要更新文档，请编辑仓库根目录的 `DEVELOPMENT.md`，或在代码调整 API 后同步更新 `src/config/api.config.js` 并重新生成文档。


