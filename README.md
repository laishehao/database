# database

这个是正儿八经的数据库大作业！

TUKI

数据库数据库(,,･∀･)

测试 push 功能

<<<<<<< HEAD

## 数据库设计

### 表结构总览

|  表名  |    主键    |         描述         |
| :----: | :--------: | :------------------: |
|  Teacher_Info  |    Tno     | 老师表：存储老师信息 |
|  Student_Info  |    Sno     | 老师表：存储老师信息 |
| Course |    Cno     | 课程表：存储课程信息 |
|  Work  |    Wno     | 作业题目表：存储作业信息 |
| Write  | (Wno, Uno) | 提交表：记录完成情况 |
| SC  | (Cno, Sno) | 选课表：记录学生选课情况 |
| Title_Image  | (Wno, Cno) | 题目图片表：记录作业题目的图片 |
| Answer_Image  | (Wno, Sno) | 选课表：记录学生作业的作答图片 |

### 详细表结构

#### 1. Teacher_Info 用户表
|  字段名   |           类型            |    约束     |  描述   |
| :-------: | :-----------------------: | :---------: | :-----: |
|    Tno    |            INT            | PRIMARY KEY | 用户ID  |
|   Tname   |          VARCHAR          |  NOT NULL   | 用户名  |
| Tpassword |          VARCHAR          |  NOT NULL   |  密码   |
|   Tmail   |          VARCHAR          |   UNIQUE    |  邮箱   |
|  Tphone   |          VARCHAR          |NOT NULL UNIQUE |  电话   |
|  Tavatar  |          VARCHAR          |  UNIQUE     | 头像URL |
|  Tgender  |           CHAR            |             |  性别   |
|  Tmajor   |          VARCHAR          |             |  专业   |

#### 2. Course 课程表
| 字段名  |  类型   |    约束     |   描述   |
| :-----: | :-----: | :---------: | :------: |
|   Cno   |   INT   | PRIMARY KEY |  课程ID  |
|  Cname  | VARCHAR |  NOT NULL   | 课程名称 |
|   Uno   |   INT   | FOREIGN KEY |  教师ID  |
| Cmajor  | VARCHAR |             | 所属学院 |
| Ccredit |   INT   |             |   学分   |
|  Ctype  | VARCHAR |             | 课程类型 |

#### 3. Work 作业表
|  字段名   |   类型   |    约束     |   描述   |
| :-------: | :------: | :---------: | :------: |
|    Wno    |   INT    | PRIMARY KEY |  作业ID  |
|    Cno    |   INT    | FOREIGN KEY |  课程ID  |
|  Wtitle   | VARCHAR  |  NOT NULL   | 作业标题 |
| Wprogress |   INT    |  DEFAULT 0  | 完成人数 |
|  Wstart   | DATETIME |             | 开始时间 |
|   Wover   | DATETIME |             | 结束时间 |
| Wcontent  |   TEXT   |             | 作业内容 |

#### 4. Write 作业提交表
|     字段名     | 类型 |           约束           |   描述   |
| :------------: | :--: | :----------------------: | :------: |
|      Wno       | INT  | PRIMARY KEY, FOREIGN KEY |  作业ID  |
|      Uno       | INT  | PRIMARY KEY, FOREIGN KEY |  用户ID  |
|     State      | INT  |        DEFAULT 0         | 提交状态 |
|   WrContent    | TEXT |                          | 提交内容 |
|     Score      | INT  |                          |   成绩   |


## 依赖关系
User：Uno → { Uname, Upassword, Uemail, Urole, Ugender, Umajor, Uphone, Uavatar }

Course：Cno → { Cname, Cmajor, Ccredit, Ctype, Uno }

Work：Wno → { Wtitle, Cno, Wprogress, Wstart, Wover }

Write：(Wno, Uno) → State

## database功能
### 游客
- 登录

- 注册

### 学生
- 查看作业

- 写作业（文本）

- 上传图片

- 提交作业（更改Wstate）

### 教师
- 发布作业

- 修改作业信息

- 删除作业

- 查看作业

- 查看课程
<<<<<<< HEAD
- 编辑课程 - 已完成 ✅
- 删除课程 - 已完成 ✅
- 开课 - 已完成 ✅

- 修改课程信息

- 删除课程

- 开课
## database数据库存储过程
- S_Register

功能：注册学生账户

输入：
p_name VARCHAR(50)
p_phone VARCHAR(20)
p_password VARCHAR(100)
p_email VARCHAR(100)

正常输出：

|result_type|  user_id |
| :-------: | :------: |
|  SUCCESS  |   Sno    |
错误输出：

|result_type|
| :-------: |
|  ERROR:PHONE_EXISTS  |

|result_type|
| :-------: |
| ERROR:EMAIL_EXISTS |

|result_type|
| :-------: |
| ERROR:SYSTEM_ERROR |

- Edit_Student

功能编辑学生信息

输入：
p_sno INT
p_name VARCHAR(50)
p_password VARCHAR(100)
p_email VARCHAR(100)
p_gender CHAR(1)
p_major VARCHAR(50)
p_phone VARCHAR(20)
p_avatar VARCHAR(200)

正常输出：

|result_type|
| :-------: |
|  SUCCESS  |
错误输出：

|result_type|
| :-------: |
|  ERROR:PHONE_EXISTS  |

|result_type|
| :-------: |
| ERROR:EMAIL_EXISTS |

|result_type|
| :-------: |
| ERROR:AVATAR_EXISTS |

|result_type|
| :-------: |
| ERROR:STUDENT_NOT_EXISTS |

|result_type|
| :-------: |
| ERROR:SYSTEM_ERROR |

- View_Student

功能：查看学生信息

输入：
p_sno INT

正常输出：

|result_type|Tno|Tname|Tpassword|Temail|Tgender|Tphone|Tavatar|
| :-------: |:-:|:---:|:-------:|:----:|:-----:|:----:|:-----:|
|  SUCCESS  |Tno|Tname|Tpassword|Temail|Tgender|Tphone|Tavatar|
错误输出：

|result_type|
| :-------: |
| ERROR:SYSTEM_ERROR |

- S_Login

功能：登录学生账户

输入：
p_phone VARCHAR(20)
p_password VARCHAR(100)

正常输出：

|result_type|  user_id |
| :-------: | :------: |
|  SUCCESS  |   Sno    |
错误输出：

|result_type|
| :-------: |
| ERROR:PASSWORD_ERROR |

|result_type|
| :-------: |
| ERROR:PHONE_ERROR |

|result_type|
| :-------: |
| ERROR:SYSTEM_ERROR |

- T_Register
输入：
p_name VARCHAR(50)
p_phone VARCHAR(20)
p_password VARCHAR(100)
p_email VARCHAR(100)

正常输出：

|result_type|  user_id |
| :-------: | :------: |
|  SUCCESS  |   Tno    |
错误输出：

|result_type|
| :-------: |
|  ERROR:PHONE_EXISTS  |

|result_type|
| :-------: |
| ERROR:EMAIL_EXISTS |

|result_type|
| :-------: |
| ERROR:SYSTEM_ERROR |



## 前后端对应表
|  角色   |       需求       |              请求数据格式 (Object Structure)              |            返回数据            |         url         |  方法  |
| :-----: | :--------------: | :-------------------------------------------------------: | :----------------------------: | :-----------------: | :----: |
|  游客   |       登录       |                    username，password                     |            role, id            |       /login        |  post  |
|         |       注册       |           role，username，password，name，email           |            role, id            |      /register      |  post  |
|  学生   |     查看作业     |                  role，studentId，query                   |           total,list           |      /homework      |  get   |
|         |     提交作业     |                role，studentId，writecheck                | 成功信息(比如"提交成功"这样的) |  /homework/submit   |  post  |
|         | 个人信息（待定） |                           role                            |                                |                     |        |
|  老师   |     查看课程     |                        role，query                        |           total,list           |       /course       |  get   |
|         |     增加课程     | role，courseId，courseName，major，credits，type，teacher | 成功信息(比如"创建成功"这样的) |       /course       |  post  |
|         |     删除课程     |                      role，courseId                       | 成功信息(比如"删除成功"这样的) |  /course/:courseId  | delete |
|         |     编辑课程     | role，courseId，courseName，major，credits，type，teacher | 成功信息(比如"修改成功"这样的) |       /course       |  put   |
|         |     查看学生     |                 role，query,page,pageSize                 |           total,list           |      /student       |  get   |
|         |     增加学生     |    role，studentId，name，major，gender，phone，avatar    | 成功信息(比如"创建成功"这样的) |      /student       |  post  |
|         |     删除学生     |                      role，studentId                      | 成功信息(比如"删除成功"这样的) | /student/:studentId | delete |
|         |     编辑学生     |    role，studentId，name，major，gender，phone，avatar    | 成功信息(比如"修改成功"这样的) |      /student       |  put   |
|         |     布置作业     |               role，title，course，progress               | 成功信息(比如"创建成功"这样的) |      /homework      |  post  |
|         |     删除作业     |                       role，workId                        | 成功信息(比如"删除成功"这样的) |  /homework/:workId  | delete |
|         |     修改作业     |                       role，workId                        | 成功信息(比如"修改成功"这样的) |      /homework      |  put   |
|         |     查看作业     |                        role，query                        |           total,list           |      /homework      |  get   |
|         | 个人信息（待定） |                           role                            |                                |                     |        |
| ======= |                  |                                                           |                                |                     |        |
### 前后端 API 接口文档

|   角色    |             需求             |                         请求数据格式                         |                         成功返回数据                         |              URL               |    方法    |
| :-------: | :--------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------: | :--------: |
| **游客**1 |           **登录**           |             `phone`:string<br>`password`: string             | `msg`: string('登录成功')<br>`user`:object<br>_包含:`id`:string, `phone`:string, `name`:string, `role`:string, `avatar`:string, `email`:string_ |          `/api/login`          |  **POST**  |
|     1     |           **注册**           | `role`: string<br>`phone`:string<br>`password`:string<br>`name`:string<br>`email`: string | `msg`: string('注册成功')<br>`user`:object<br>包含: `id`:string, `phone`:string, `name`:string, `role`:string, `avatar`:string<br/>`email`:string |        `/api/register`         |  **POST**  |
| **用户**1 |     **提交用户信息修改**     |     `phone`:string<br>`name`: string<br />`email`:string     | `msg`: string('修改成功')<br>`user`:object<br>_包含(更新后的用户信息 ): `phone`:string, `name`:string, `role`:string, `avatar`:string, `email`:string_ |          `/api/user`           |  **POST**  |
| **学生**1 |       **查看作业列表**       | `query`: string (搜索关键词)<br>`page`:number<br>`pageSize`:number |               `total`:number<br>`list`: Array                |          `/homework`           |  **GET**   |
|     1     |         **提交作业**         | `role`: string<br />`userId`:string<br/>`workId`:string<br>`writecheck`: string ('true' 或 'false')<br> `content`:string |           `code`: 200<br>`msg`: string('提交成功')           |   `/homework/submit/:workId`   |  **POST**  |
|           |      **查看某一项作业**      |            `workId`: string<br />`userId`: string            | `code`: 200<br />`msg`: string<br />`detail`: object {<br />&nbsp;&nbsp;`id`: string,<br />&nbsp;&nbsp;`title`: string,<br />&nbsp;&nbsp;`course`: string,<br />&nbsp;&nbsp;`completed`: boolean,<br />&nbsp;&nbsp;`content`: string,<br />&nbsp;&nbsp;`score`: number \| null,<br />&nbsp;&nbsp;`teacherComment`: string<br />}<br />`studentAnswer`: string |      `/homework/:workId`       |  **GET**   |
| **老师**1 |       **查看课程列表**       |    `query`: string <br>`page`:number<br>`pageSize`:number    |               `total`:number<br>`list`: Array                |           `/course`            |  **GET**   |
|     1     |         **增加课程**         | `courseId`:string<br>`courseName`:string<br>`major`:string<br>`credits`: number<br>`type`:string<br>`teacher`: string |           `code`: 200<br>`msg`: string('创建成功')           |           `/course`            |  **POST**  |
|     1     |         **删除课程**         |                      `courseId`: string                      |           `code`: 200<br>`msg`: string('删除成功')           |      `/course/:courseId`       | **DELETE** |
|     1     |         **编辑课程**         | `courseId`: string<br>`courseName`:string<br>_`credits`:number<br/>_`major`:string<br />`teacher`:string<br />`type`:string('必修'或者'选修') |           `code`: 200<br>`msg`: string('修改成功')           |      `/course/:courseId`       |  **PUT**   |
|     1     |       **查看学生列表**       |   `query`: string<br>`page`: number<br>`pageSize`: number    |               `total`:number<br>`list`: Array                |           `/student`           |  **GET**   |
|     1     |         **增加学生**         | `studentId`: string<br>`name`: string<br>`major`: string<br>`gender`: string<br>`phone`: string |           `code`: 200<br>`msg`: string('创建成功')           |           `/student`           |  **POST**  |
|     1     |         **删除学生**         |                     ``studentId`: string                     |           `code`: 200<br>`msg`: string('删除成功')           |     `/student/:studentId`      | **DELETE** |
|     1     |         **编辑学生**         | `studentId`: string<br>`name`: string<br>`major`: string<br>`gender`: string<br>`phone`: string |           `code`: 200<br>`msg`: string('修改成功')           |     `/student/:studentId`      |  **PUT**   |
|     1     |       **查看作业列表**       |    `query`: string<br>`pageSize`:number<br>`page`:number     |                `total`:number<br>`list`:Array                |          `/homework`           |  **GET**   |
|     1     | **查看某一个作业的提交情况** |                       `workId`: string                       | `title`:string <br>`list`:Array 每一项包含`workId`:string<br>`userId`:string<br>`name`: string<br>`status`:string(unsubmitted或者submitted或者graded) <br>`score`:number<br>`content`:string<br>`teacherComment`:string(教师评语) | `/homework/submissions:workId` |  **GET**   |
|     1     | **提交某一个作业的批改情况** | `workId`: string <br> `userId`: string <br> `score`:string <br> `teacherComment`:string | `msg`:string('批改成功') <br>`userId`: string <br>`workId`: string <br>`status`:string(unsubmitted或者submitted或者graded)<br> `score`:string <br> `teacherComment`:string |       `/homework/grade`        |  **POST**  |
|     1     |         **发布作业**         | `title`: string<br>`course`: string<br>`progress`: string<br>`content`: string |           `code`: 200<br>`msg`: string('发布成功')           |          `/homework`           |  **POST**  |
|     1     |         **删除作业**         |                       `workId`: string                       |           `code`: 200<br>`msg`: string('删除成功')           |      `/homework/:workId`       | **DELETE** |
|     1     |         **编辑作业**         |   `workId`: string<br>`title`: string<br>`content`: string   |           `code`: 200<br>`msg`: string('修改成功')           |      `/homework/:workId`       |  **PUT**   |

>>>>>>> 8dffd5ec9018f01c1ebe7ca80f1495add3dc4a9f

=======
🦌
## 前后端数据对应表



## 服务器资源说明

### **资源文件命名**

#### 头像文件命名

教师头像：`Tno` 为 $x$ 的教师头像

```text
Teacher_x.[jpg/png/jpeg]
```

学生头像：`Sno` 为 $x$ 的学生头像

```text
Student_x.[jpg/png/jpeg]
```

#### 作业文件命名

问题图片：`Wno` 为 $x$ 的作业所对应的第 $y$ 张问题图片

```text
Work[x]_problem[y].[jpg/png/jpeg]		# [x]表示序号为x，这里为了方便表示，故添加括号
```

答案图片：`Sno` 为 $y$ 的学生提交的 `Wno` 为 $x$ 的作业，其答案图片序号为 $z$

```text
Work[x]_Student[y]_z.[jpg/png/jpeg]
```

### **服务器资源文件树**

```text
/database_src
└───/photos
|	├───/avatar
|	|	├───Teacher_1.jpg
|	|	...
|	|	├───Teacher_n.jpg
|	|	├───Student_1.jpg
|	|	...
|	|	└───Student_n.jpg
|	└───/homeworks
|		├───Work1_problem1.jpg
|		...
|		├───Work[m]_problem[n].jpg
|		├───Work1_Student1_1.jpg
|		...
|		└───Work[m]_Student[x]_1.jpg
|
└───/database_code
	├───init.sql
	├───triggers.sql
	├───database.sql
	└───schema.sql
```


## 修改意见

球球各位大跌，文件尽量用英文命名，要不然我的git会出问题😭😭😭