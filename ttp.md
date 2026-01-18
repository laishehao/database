# 存储过程总结 

## 用户管理模块 

### 1. 学生相关 

| 存储过程         | 传入参数                                                     | 返回结果                   |
| ---------------- | ------------------------------------------------------------ | -------------------------- |
| **S_Register**   | p_name, p_phone, p_password, p_email                         | result_type, user_id       |
| **S_Login**      | p_phone, p_password                                          | result_type, user_id       |
| **Edit_Student** | p_sno, p_name, p_password, p_email, p_gender, p_major, p_phone, p_avatar | result_type                |
| **View_Student** | p_sno                                                        | result_type + 学生信息字段 |

### 2. 教师相关 

| 存储过程         | 传入参数                                                     | 返回结果                   |
| ---------------- | ------------------------------------------------------------ | -------------------------- |
| **T_Register**   | p_name, p_phone, p_password, p_email                         | result_type, user_id       |
| **T_Login**      | p_phone, p_password                                          | result_type, user_id       |
| **Edit_Teacher** | p_tno, p_name, p_password, p_email, p_gender, p_phone, p_avatar | result_type                |
| **View_Teacher** | p_tno                                                        | result_type + 教师信息字段 |

## 课程管理模块 

| 存储过程                | 传入参数                                         | 返回结果                      |
| ----------------------- | ------------------------------------------------ | ----------------------------- |
| **Create_Course**       | p_cname, p_major, p_credit, p_type, p_tno        | result_type, course_id        |
| **Edit_Course**         | p_cno, p_cname, p_major, p_credit, p_type, p_tno | result_type                   |
| **Delete_Course**       | p_cno                                            | result_type                   |
| **View_Course**         | p_cno                                            | result_type + 课程信息字段    |
| **Select_Course**       | p_cno, p_sno                                     | result_type                   |
| **View_Course_Student** | p_cno                                            | 学生列表（无result_type字段） |

## 作业管理模块 

### 1. 作业增删改查 

| 存储过程            | 传入参数                                     | 返回结果                   |
| ------------------- | -------------------------------------------- | -------------------------- |
| **Push_homework**   | p_title, p_cname, p_start, p_over, p_content | result_type, Work_id       |
| **Edit_homework**   | p_wno, p_title, p_start, p_over, p_content   | result_type                |
| **Delete_homework** | p_wno                                        | result_type                |
| **View_work**       | p_wno                                        | result_type + 作业信息字段 |
| **View_homework**   | p_sno, p_wno                                 | result_type + 提交信息字段 |

### 2. 文件/答案管理 

| 存储过程                 | 传入参数                         | 返回结果    |
| ------------------------ | -------------------------------- | ----------- |
| **Create_Timage**        | p_wno, p_cno, p_image_path       | result_type |
| **Create_Aimage**        | p_wno, p_sno, p_image_path       | result_type |
| **Submit_Answer**        | p_wno, p_sno, p_content          | result_type |
| **Marking**              | p_wno, p_sno, p_score, p_comment | result_type |
| **Update_Work_Progress** | p_wno                            | result_type |

## 查询统计模块 

### 1. 学生视角查询 

| 存储过程                   | 传入参数         | 返回结果                               |
| -------------------------- | ---------------- | -------------------------------------- |
| **Student_View_Work_List** | p_sno, p_keyword | 作业列表（无result_type字段）          |
| **ScntCourse**             | p_sno            | result_type, student_id, course_count  |
| **ScntWriting**            | p_sno            | result_type, student_id, writing_count |

### 2. 教师视角查询 

| 存储过程                        | 传入参数         | 返回结果                               |
| ------------------------------- | ---------------- | -------------------------------------- |
| **Teacher_View_Student_List**   | p_keyword        | 学生列表（无result_type字段）          |
| **Teacher_View_Course_List**    | p_tno, p_keyword | 课程列表（无result_type字段）          |
| **Teacher_View_Work_List**      | p_tno, p_keyword | 作业列表（无result_type字段）          |
| **Teacher_View_Courses_By_Tno** | p_tno            | 课程列表（无result_type字段）          |
| **Teacher_View_Works_By_Cno**   | p_cno            | 作业列表（无result_type字段）          |
| **Teacher_View_Writes_By_Wno**  | p_wno            | 提交记录列表（无result_type字段）      |
| **Teacher_View_Writes_By_Sno**  | p_sno            | 提交记录列表（无result_type字段）      |
| **TcntCourse**                  | p_tno            | result_type, teacher_id, course_count  |
| **TcntWriting**                 | p_tno            | result_type, teacher_id, writing_count |
| **TcntCorrect**                 | p_tno            | result_type, teacher_id, correct_count |

## 其他功能 

| 存储过程                       | 传入参数     | 返回结果    |
| ------------------------------ | ------------ | ----------- |
| **Delete_Student_From_Course** | p_cno, p_sno | result_type |

------

## 返回结果说明 

### 1. 标准返回格式 

大部分存储过程返回两种格式：

- 

  **单行结果**：包含 `result_type`字段（SUCCESS/ERROR:xxx）

- 

  **多行结果**：直接返回查询结果集，通常用于列表查询

### 2. 常见 result_type 

- 

  **SUCCESS**: 操作成功

- 

  **ERROR:xxx**: 各种错误类型，如：

  - 

    PHONE_EXISTS/EMAIL_EXISTS: 重复注册

  - 

    STUDENT_NOT_EXISTS: 学生不存在

  - 

    PASSWORD_ERROR/PHONE_ERROR: 登录错误

  - 

    COURSE_NOT_EXIST: 课程不存在

  - 

    SYSTEM_ERROR: 系统异常

### 3. 额外返回字段 

部分存储过程在成功时还会返回：

- 

  **user_id**: 用户ID

- 

  **course_id**: 课程ID

- 

  **Work_id**: 作业ID

- 

  各类统计数量

# 大作业验收评分须知

1、大作业验收最晚18周五（2026.01.23）之前完成。
2、大作业验收，要求提交的资料内容：需求分析报告，概要设计，详细设计，系统使用说明书，小班讨论汇报及后期修改说明ppt，程序源码与数据库备份。
3、在验收的时候，组长先介绍系统设计的思路与整体功能，再当场运行程序演示系统功能。

## 评分细则：

### 1）资料撰写50分

需求分析报告：6分
概要设计：6分
详细设计：12分
系统使用说明书：6分
小班讨论汇报及后期修改说明ppt：5分
程序源码与数据库备份：15分

### 2）系统演示和讲解50分

系统演示与讲解（0-10分）：讲解不太清楚0-3分，讲解基本清楚4-7分，讲解清楚，设计熟悉8-10分；
程序运行（0-30分）：不能正常运行0-10分，能部分运行，可完成部分增删改查的操作11-20分，能正常运行，完成大部分的增删改查的操作21-30分；
程序功能（0-10分）：没有完成系统设计的功能0-2分，基本完成系统设计的功能3-6分，完成系统设计的功能，界面美观，功能流畅7-10分。