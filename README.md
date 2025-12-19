# database
这个是正儿八经的数据库大作业！

TUKI

数据库数据库(,,･∀･)

测试 push 功能

<<<<<<< HEAD
# database制表
| 表名     | 属性1     | 属性2        | 属性3           | 属性4                  | 属性5             | 属性6             | 属性7         | 属性8        | 属性9       |
| ------ | ------- | ---------- | ------------- | -------------------- | --------------- | --------------- | ----------- | ---------- | --------- |
| User   | Uno(ID)int | Uname      | Upassword（密码） | Umail                | Uphone          | Uavatar（头像）     | Ugender（性别） | Umajor（专业） | Urole（角色） |
| Course | Cno(ID)int | Cname（课程名） | Uno（教师）       | Cmajor (所属学院)        | Ccredit（学分）int     | Ctype(类型：必修/选修) |             |            |           |
| Work   | Wno(ID)int | Cno（课程号）   | Wtitle (作业名字) | Wprogress（有多少学生完成作业）int | Wstart (作业开始时间)datetime | Wend（作业结束时间）datetime    |             |            |           |
|Write （学生与作业对应表）|Wno（作业号）|Uno (用户ID)|Wstate (作业状态：已完成/未完成)

# 依赖关系
User：Uno → { Uname, Upassword, Uemail, Urole, Ugender, Umajor, Uphone, Uavatar }

Course：Cno → { Cname, Cmajor, Ccredit, Ctype, Uno }

Work：Wno → { Wtitle, Cno, Wprogress, Wstart, Wover }

Write：(Wno, Uno) → State

# database功能
## 游客
1、登录

2、注册
## 学生
1、查看作业

2、提交作业
## 教师
1、发布作业

2、修改作业信息

3、删除作业

4、查看作业

5、查看课程

6、修改课程信息

7、删除课程

8、开课

# database数据库设计
1. 创建 User, Course, Work 和 Write 四张表。

2. 设置主键和外键约束。

3. 为每个表设置合适的索引以提高查询效率。

4. 根据需求为某些字段添加默认值或非空约束。

<<<<<<< HEAD
# 前后端对应表
|角色	|需求	|请求数据格式 (Object Structure)|	返回数据	|url	|方法|
|------|------|------|------|------|------|
|游客	|登录|	username，password|	role, id	|/login	|post|
|   |注册	|role，username，password，name，email	|role, id|	/register|	post|
|学生	|查看作业	|role，studentId，query	|total,list|	/homework|	get|
| | 提交作业|	role，studentId，writecheck	|成功信息(比如"提交成功"这样的)	|/homework/submit	|post|
||   个人信息（待定）|	role	|
|老师|	查看课程	|role，query	|total,list|/course|	get|
| |  增加课程	|role，courseId，courseName，major，credits，type，teacher	|成功信息(比如"创建成功"这样的)	|/course	|post|
|  | 删除课程	|role，courseId	|成功信息(比如"删除成功"这样的)	|/course/:courseId	|delete|
| |  编辑课程	|role，courseId，courseName，major，credits，type，teacher	|成功信息(比如"修改成功"这样的)|	/course|put|
| |  查看学生	|role，query,page,pageSize	|total,list	|/student|	get|
||  增加学生	|role，studentId，name，major，gender，phone，avatar|	成功信息(比如"创建成功"这样的)|	/student	|post|
||   删除学生	|role，studentId	|成功信息(比如"删除成功"这样的)	|/student/:studentId|	delete|
||  编辑学生	|role，studentId，name，major，gender，phone，avatar|	成功信息(比如"修改成功"这样的)|	/student|	put|
||   布置作业	|role，title，course，progress	|成功信息(比如"创建成功"这样的)	|/homework	|post|
||  删除作业	|role，workId|	成功信息(比如"删除成功"这样的)|	/homework/:workId|delete|
||   修改作业	|role，workId|	成功信息(比如"修改成功"这样的)	|/homework	|put|
||  查看作业	|role，query	|total,list	|/homework	|get|
||  个人信息（待定）	|role|
=======
### 前后端 API 接口文档

| 角色     | 需求         | 请求数据格式                                   | 成功返回数据                                   | URL                       | 方法         |
| :----- | :--------- | :--------------------------------------- | :--------------------------------------- | :------------------------ | :--------- |
| **游客** | **登录**     | `username`:string<br>`password`: string  | `msg`: string('登录成功')<br>`user`:object<br>_包含: `username`:string, `name`:string, `role`:string, `avatar`:string_ | `/api/login`              | **POST**   |
|        | **注册**     | `role`: string<br>`username`:string<br>`password`:string<br>`name`:string<br>`email`: string | `msg`: string('注册成功')<br>`user`:object<br>包含: `username`:string, `name`:string, `role`:string, `avatar`:string | `/api/register`           | **POST**   |
| **学生** | **查看作业列表** | `query`: string (搜索关键词)<br>`page`:number<br>`pageSize`:number | `total`:number<br>`list`: Array          | `/homework`               | **GET**    |
|        | **提交作业**   | `role`: string<br />`studentId`:string<br/>`workId`:string<br>`writecheck`: string ('true' 或 'false') | `code`: 200<br>`msg`: string('提交成功')     | `/homework/submit:workId` | **POST**   |
| **老师** | **查看课程列表** | `query`: string <br>`page`:number<br>`pageSize`:number | `total`:number<br>`list`: Array          | `/course`                 | **GET**    |
|        | **增加课程**   | `courseId`:string<br>`courseName`:string<br>`major`:string<br>`credits`: number<br>`type`:string<br>`teacher`: string | `code`: 200<br>`msg`: string('创建成功')     | `/course`                 | **POST**   |
|        | **删除课程**   | `courseId`: string                       | `code`: 200<br>`msg`: string('删除成功')     | `/course/:courseId`       | **DELETE** |
|        | **编辑课程**   | `courseId`: string<br>`courseName`:string<br>_`credits`:number<br/>_`major`:string<br />`teacher`:string<br />`type`:string('必修'或者'选修') | `code`: 200<br>`msg`: string('修改成功')     | `/course`                 | **PUT**    |
|        | **查看学生列表** | `query`: string<br>`page`: number<br>`pageSize`: number | `total`:number<br>`list`: Array          | `/student`                | **GET**    |
|        | **增加学生**   | `studentId`: string<br>`name`: string<br>`major`: string<br>`gender`: string<br>`phone`: string | `code`: 200<br>`msg`: string('创建成功')     | `/student`                | **POST**   |
|        | **删除学生**   | ``studentId`: string                     | `code`: 200<br>`msg`: string('删除成功')     | `/student/:studentId`     | **DELETE** |
|        | **编辑学生**   | `studentId`: string<br>`name`: string<br>`major`: string<br>`gender`: string<br>`phone`: string | `code`: 200<br>`msg`: string('修改成功')     | `/student`                | **PUT**    |
|        | **查看作业**列表 | `query`: string<br>`pageSize`:number<br>`page`:number | `total`:number<br>`list`:Array           | `/homework`               | **GET**    |
|        | **发布作业**   | `title`: string<br>`course`: string<br>`progress`: string<br>`content`: string | `code`: 200<br>`msg`: string('发布成功')     | `/homework`               | **POST**   |
|        | **删除作业**   | `workId`: string                         | `code`: 200<br>`msg`: string('删除成功')     | `/homework/:workId`       | **DELETE** |
|        | **修改作业**   | `workId`: string<br>`title`: string<br>`content`: string | `code`: 200<br>`msg`: string('修改成功')     | `/homework`               | **PUT**    |

>>>>>>> 8dffd5ec9018f01c1ebe7ca80f1495add3dc4a9f

=======
🦌
# 前后端数据对应表
||


# 修改意见
1. 


