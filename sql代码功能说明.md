# 作业系统sql整理
## 一、关系表

### 1. Teacher_Info

| 属性名    | 数据类型     | 约束               |
| --------- | ------------ | ------------------ |
| Tno       | INT          | 主键               |
| Tname     | VARCHAR(50)  | 非空               |
| Tpassword | VARCHAR(100) | 非空               |
| Temail    | VARCHAR(100) | 非空且唯一         |
| Tgender   | CHAR(1)      | 值只能为‘男’或‘女’ |
| Tphone    | VARCHAR(20)  | 非空且唯一         |
| Tavatar   | VARCHAR(200) | 唯一               |



### 2. Student_Info

| 属性名    | 数据类型     | 约束               |
| --------- | ------------ | ------------------ |
| Sno       | INT          | 主键               |
| Sname     | VARCHAR(50)  | 非空               |
| Spassword | VARCHAR(100) | 非空               |
| Semail    | VARCHAR(100) | 非空且唯一         |
| Sgender   | CHAR(1)      | 值只能为‘男’或‘女’ |
| Smajor    | VARCHAR(50)  |                    |
| Sphone    | VARCHAR(20)  | 非空且唯一         |
| Savatar   | VARCHAR(200) | 唯一               |



### 3. Course

| 属性名  | 数据类型     | 约束                                                         |
| ------- | ------------ | ------------------------------------------------------------ |
| Cno     | INT          | 主键且自增                                                   |
| Cname   | VARCHAR(100) | 非空                                                         |
| Cmajor  | VARCHAR(50)  |                                                              |
| Ccredit | INT          | 非空且唯一                                                   |
| Ctype   | VARCHAR(20)  | 值只能为‘必修’或‘选修’                                       |
| Tno     | INT          | 参照Teacher_Info(Tno)的外键，且添加(Cname, Tno)作为唯一性约束 |



### 4. SC

| 属性名 | 数据类型 | 约束                                              |
| ------ | -------- | ------------------------------------------------- |
| Cno    | INT      | 参照Course(Cno)的外键                             |
| Sno    | INT      | 参照Student_Info(Sno)的外键，且以(Cno, Sno)为主键 |



### 5. Work

| 属性名    | 数据类型     | 约束                  |
| --------- | ------------ | --------------------- |
| Wno       | INT          | 主键且自增            |
| Wtitle    | VARCHAR(200) | 非空                  |
| Cno       | INT          | 参照Course(Cno)的外键 |
| Wprogress | INT          | 默认值为0             |
| Wcontent  | TEXT         |                       |
| Wstart    | DATETIME     |                       |
| Wover     | DATETIME     |                       |



### 6. Write

| 属性名    | 数据类型     | 约束                                                        |
| --------- | ------------ | ----------------------------------------------------------- |
| Wno       | INT          | 非空，且为参照Work(Wno)的外键                               |
| Sno       | VARCHAR(200) | 非空，且为参照Student_Info(Sno)的外键，以(Wno, Sno)作为主键 |
| State     | INT          |                                                             |
| Wrcontent | INT          |                                                             |
| Score     | TEXT         |                                                             |
| Comment   | DATETIME     |                                                             |



### 7. Title_Image

| 属性名     | 数据类型     | 约束                                                  |
| ---------- | ------------ | ----------------------------------------------------- |
| Wno        | INT          | 非空，且为参照Work(Wno)的外键                         |
| Cno        | INT          | 非空，且为参照Course(Cno)的外键，以(Wno, Cno)作为主键 |
| image_path | VARCHAR(255) |                                                       |



### 7. Answer_Image

| 属性名     | 数据类型     | 约束                                                        |
| ---------- | ------------ | ----------------------------------------------------------- |
| Wno        | INT          | 非空，且为参照Work(Wno)的外键                               |
| Sno        | INT          | 非空，且为参照Student_Info(Sno)的外键，以(Wno, Sno)作为主键 |
| image_path | VARCHAR(255) |                                                             |



## 二、存储过程

### 1. S_Register

- 功能：

  进行学生用户的注册，在Student表中增加一个条目

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_name     | VARCHAR(50)  |
  | p_phone    | VARCHAR(20)  |
  | p_password | VARCHAR(100) |
  | p_email    | VARCHAR(100) |

- 返回值：

  | result_type | user_id |
  | ----------- | ------- |



### 2. Edit_Student

- 功能：

  更新学生信息

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_sno      | INT          |
  | p_name     | VARCHAR(50)  |
  | p_email    | VARCHAR(100) |
  | p_phone    | VARCHAR(20)  |
  | p_gender   | CHAR(1)      |
  | p_major    | VARCHAR(50)  |
  | p_password | VARCHAR(100) |

- 返回值：

  | result_type |
  | ----------- |



### 3. View_Student

- 功能：

  查看学生信息

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_sno  | INT      |

- 返回值：

  | result_type | Sno  | Sname | Spassword | Semail | Sgender | Smajor | Sphone | Savatar |
  | ----------- | ---- | ----- | --------- | ------ | ------- | ------ | ------ | ------- |



### 4. S_Login

- 功能：

  检查学生传入的登录信息，判断账户密码是否匹配

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_phone    | VARCHAR(20)  |
  | p_password | VARCHAR(100) |

- 返回值：

  | result_type | user_id |
  | ----------- | ------- |



### 5. T_Register

- 功能：

  进行老师用户的注册，在Teacher表中增加一个条目

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_name     | VARCHAR(50)  |
  | p_phone    | VARCHAR(20)  |
  | p_password | VARCHAR(100) |
  | p_email    | VARCHAR(100) |

- 返回值：

  | result_type | user_id |
  | ----------- | ------- |



### 6. Edit_Teacher

- 功能：

  更新老师信息

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_sno      | INT          |
  | p_name     | VARCHAR(50)  |
  | p_email    | VARCHAR(100) |
  | p_phone    | VARCHAR(20)  |
  | p_gender   | CHAR(1)      |
  | p_password | VARCHAR(100) |

- 返回值：

  | result_type |
  | ----------- |



### 7. View_Teacher

- 功能：

  查看老师信息

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值：

  | result_type | Tno  | Tname | Tpassword | Temail | Tgender | Tphone | Tavatar |
  | ----------- | ---- | ----- | --------- | ------ | ------- | ------ | ------- |



### 8. T_Login

- 功能：

  检查老师传入的登录信息，判断账户密码是否匹配

- 传入参数：

  | 参数名     | 数据类型     |
  | ---------- | ------------ |
  | p_phone    | VARCHAR(20)  |
  | p_password | VARCHAR(100) |

- 返回值：

  | result_type | user_id |
  | ----------- | ------- |



### 9. Push_homework

- 功能：

  老师发布对应课程的作业

- 传入参数：

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_title   | VARCHAR(200) |
  | p_cname   | VARCHAR(100) |
  | p_tno     | INT          |
  | p_start   | DATETIME     |
  | p_over    | DATETIME     |
  | p_content | TEXT         |

- 返回值：

  | result_type | Work_id |
  | ----------- | ------- |



### 10. Edit_homework

- 功能：

  老师更新作业的题目的信息

- 传入参数：

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_wno     | INT          |
  | p_title   | VARCHAR(200) |
  | p_start   | DATETIME     |
  | p_over    | DATETIME     |
  | p_content | TEXT         |

- 返回值：

  | result_type |
  | ----------- |



### 11. View_work

- 功能：

  老师查看作业的题目的信息

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_wno  | INT      |

- 返回值：

  | result_type | Wno  | Wtitle | Cno  | Wcontent | Wstart | Wover | Wprogress |
  | ----------- | ---- | ------ | ---- | -------- | ------ | ----- | --------- |



### 12. Delete_homework

- 功能：

  老师删除作业

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_wno  | INT      |

- 返回值：

  | result_type |
  | ----------- |



### 13. View_homework

- 功能：

  查看某个学生写的作业信息

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_sno  | INT      |
  | p_wno  | INT      |

- 返回值：

  | result_type | write_content | Score | State | Comment |
  | ----------- | ------------- | ----- | ----- | ------- |



### 14. Create_Course

- 功能：

  老师开设新课程

- 传入参数：

  | 参数名   | 数据类型     |
  | -------- | ------------ |
  | p_cname  | VARCHAR(100) |
  | p_major  | VARCHAR(50)  |
  | p_credit | INT          |
  | p_type   | VARCHAR(20)  |
  | p_tno    | INT          |

- 返回值：

  | result_type | course_id |
  | ----------- | --------- |



### 15. Edit_Course

- 功能：

  老师更新课程信息

- 传入参数：

  | 参数名   | 数据类型     |
  | -------- | ------------ |
  | p_cno    | INT          |
  | p_cname  | VARCHAR(100) |
  | p_major  | VARCHAR(50)  |
  | p_credit | INT          |
  | p_type   | VARCHAR(20)  |
  | p_tno    | INT          |

- 返回值：

  | result_type |
  | ----------- |



### 16. Delete_Course

- 功能：

  老师删除课程

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_cno  | INT      |

- 返回值：

  | result_type |
  | ----------- |



### 17. View_Course

- 功能：

  查看某个课程的具体信息

- 传入参数：

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_cno  | INT      |

- 返回值：

  | result_type | Cno  | Cname | Cmajor | Ccredit | Ctype | Tno  |
  | ----------- | ---- | ----- | ------ | ------- | ----- | ---- |



### 18. Create_Timage

- 功能：

  增加题目图片

- 传入参数：

  | 参数名       | 数据类型     |
  | ------------ | ------------ |
  | p_wno        | INT          |
  | p_cno        | INT          |
  | p_image_path | VARCHAR(255) |

- 返回值：

  | result_type |
  | ----------- |



### 19. Create_Aimage

- 功能：

  增加答案图片

- 传入参数：

  | 参数名       | 数据类型     |
  | ------------ | ------------ |
  | p_wno        | INT          |
  | p_sno        | INT          |
  | p_image_path | VARCHAR(255) |

- 返回值：

  | result_type |
  | ----------- |



### 20. Submit_Answer

- 功能：

  学生提交作业答案

- 传入参数：

  | 参数名    | 数据类型 |
  | --------- | -------- |
  | p_wno     | INT      |
  | p_sno     | INT      |
  | p_content | TEXT     |

- 返回值：

  | result_type |
  | ----------- |



### 21. Marking

- 功能：

  老师批改某个作业

- 传入参数：

  | 参数名    | 数据类型 |
  | --------- | -------- |
  | p_wno     | INT      |
  | p_sno     | INT      |
  | p_score   | INT      |
  | p_comment | TEXT     |

- 返回值：

  | result_type |
  | ----------- |



### 22. Select_Course

- 功能：

​	学生选课操作

- 传入参数：

    | 参数名 | 数据类型 |
    | ------ | -------- |
    | p_Cno  | INT      |
    | p_Sno  | INT      |

- 返回值：

    | result_type |
    | ----------- |



### 23.  Update_work_Progress

- 功能

  学生提交作业时，更新对应作业的 `Wprogress` 字段

- 传入参数

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_wno  | INT      |

- 返回值
	| result_type |
    | ----------- |
  



### 24. Delete_Student_From_Course

- 功能

  教师可以将学生从自己的课程中删除

- 传入参数

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_cno  | INT      |
  | p_sno  | INT      |

- 返回值
	| result_type |
    | ----------- |
  



### 25. Student_View_Work_List

- 功能

  学生查询作业列表（支持关键词模糊查询）

- 传入参数

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_sno     | INT          |
  | p_keyword | VARCHAR(200) |

- 返回值

  | Wno  | Wtitle | Cno  | Wcontent | Wstart | Wover | Wprogress | Submission_State | Score |
  | ---- | ------ | ---- | -------- | ------ | ----- | --------- | ---------------- | ----- |

  


### 26. Teacher_View_Student_List

- 功能

  教师查询学生信息（支持关键词模糊查询）

- 传入参数

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_keyword | VARCHAR(100) |

- 返回值

  | Sno  | Sname | Semail | Sgender | Smajor | Sphone | Savatar |
  | ---- | ----- | ------ | ------- | ------ | ------ | ------- |

  

### 27. Teacher_View_Course_List

- 功能

  教师查询课程信息（支持关键词模糊查询）

- 参数列表

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_tno     | INT          |
  | p_keyword | VARCHAR(100) |

- 返回值

  | Cno  | Cname | Cmajor | Ccredit | Ctype | Tno  |
  | ---- | ----- | ------ | ------- | ----- | ---- |

  

### 28. Teacher_View_Work_List

- 功能

  教师查询作业列表（支持关键词模糊查询）

- 参数列表

  | 参数名    | 数据类型     |
  | --------- | ------------ |
  | p_tno     | INT          |
  | p_keyword | VARCHAR(200) |

- 返回值

  | Wno  | Wtitle | Cno  | Wcontent | Wstart | Wover | Wprogress | Cname |
  | ---- | ------ | ---- | -------- | ------ | ----- | --------- | ----- |

  

### 29. Teacher_View_Courses_By_Tno

- 功能

  通过 `Tno` 精确查询教师所教的所有课程

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值

  | Cno  | Cname | Cmajor | Ccredit | Ctype | Tno  |
  | ---- | ----- | ------ | ------- | ----- | ---- |

  

### 30. Teacher_View_Works_By_Cno

- 功能

  通过 `Cno` 字段精确查询该课程下的所有作业。

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_cno  | INT      |

- 返回值

  | Wno  | Wtitle | Cno  | Wcontent | Wstart | Wover | Wprogress |
  | ---- | ------ | ---- | -------- | ------ | ----- | --------- |

  

### 31. Teacher_View_Writes_By_Wno

- 功能

  通过 `Wno` 字段精确查询某作业下的所有提交记录

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_wno  | INT      |

- 返回值

  | Sno  | Wno  | Wrcontent | Score | State |
  | ---- | ---- | --------- | ----- | ----- |



### 32. Teacher_View_Writes_By_Sno

- 功能

  通过 `Sno` 字段精确查询该学生的所有提交记录

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_sno  | INT      |

- 返回值

  | Sno  | Wno  | Wrcontent | Score | State |
  | ---- | ---- | --------- | ----- | ----- |

  

### 33. TcntCourse

- 功能

  根据 `Tno` 字段查看老师管理的课程总数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值

  | result_type | teacher_id | course_count |
  | ----------- | ---------- | ------------ |



### 34. ScntCourse

- 功能

  根据 `Sno` 字段查看学生所选课程总数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_sno  | INT      |

- 返回值

  | result_type | teacher_id | course_count |
  | ----------- | ---------- | ------------ |



### 35. ScntWriting

- 功能

​	根据 `Sno` 字段查看学生当前未截止的作业数量

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_sno  | INT      |

- 返回值

  | result_type | teacher_id | course_count |
  | ----------- | ---------- | ------------ |



### 36. TcntWriting

- 功能

  根据 `Tno` 字段查看老师管理的未截止作业数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值

  | result_type | teacher_id | writing_count |
  | ----------- | ---------- | ------------- |



### 37. TcntCorrect

- 功能

  根据 `Tno` 字段查看老师待批改作业数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值

  | result_type | teacher_id | correct_count |
  | ----------- | ---------- | ------------- |



### 38. TcntStudent

- 功能

  根据 `Tno` 字段查看老师所管理学生数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_tno  | INT      |

- 返回值

  | result_type | teacher_id | student_count |
  | ----------- | ---------- | ------------- |



### 39. View_Course_Student

- 功能

  根据 `Cno` 字段课程下的学生总数

- 参数列表

  | 参数名 | 数据类型 |
  | ------ | -------- |
  | p_cno  | INT      |

- 返回值

  | Sno  | Sname | Semail | Sgender | Smajor | Savatar |
  | ---- | ----- | ------ | ------- | ------ | ------- |



## 三、触发器

### 1. trg_after_work_insert

- 功能：一旦发布新的题目，就为选课学生创建write记录，初始状态为未完成

### 2. trg_after_sc_insert

- 功能：学生选课后，为该学生创建所有已发布作业的write记录
