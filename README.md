# database
这个是正儿八经的数据库大作业！
## 标题 ##
TUKI

数据库数据库(,,･∀･)

<<<<<<< HEAD
# database制表
| 表名 | 属性1 | 属性2 | 属性3 | 属性4 | 属性5 |属性6 |属性7 |属性8 |属性9 |
|------|------|------|------|------|------|------|------|------|------|
|User|Uni(ID)|Uname|Upassword（密码）|Umail|Uphone|Uavatar（头像）|Ugender（性别）|Umajor（专业）|Urole（角色）|
|Course|Cno(ID)|Cname（课程名）|Uno（教师）|Cmajor (所属学院)|Ccredit（学分）|Ctype(类型：必修/选修)|
|Work|Wno(ID)|Cno（课程号）|Wtitle (作业名字)|Wprogress（有多少学生完成作业）|Wstart (作业开始时间)|Wend（作业结束时间）|
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
🦌

# 修改意见
>>>>>>> 1b57c4fc4d57a3a548bd36ac15c160af402828cc
