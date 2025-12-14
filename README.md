# database
这个是正儿八经的数据库大作业！
TUKI
数据库数据库(,,･∀･)

# database制表
| 表名 | 属性1 | 属性2 | 属性3 | 属性4 | 属性5 |属性6 |属性7 |属性8 |属性9 |
|------|------|------|------|------|------|------|------|------|------|
|User|Uni(ID)|Uname|Upassword（密码）|Umail|Uphone|Uavatar（头像）|Ugender（性别）|Umajor（专业）|Urole（角色）|
|Course|Cno(ID)|Cname（课程名）|Uno（教师）|Cmajor (所属学院)|Ccredit（学分）|Ctype(类型：必修/选修)
Work|Wno(ID)|Cno（课程号）|Wtitle (作业名字)|Wprogress（有多少学生完成作业）|Wstart (作业开始时间)|Wend（作业结束时间）
Write （学生与作业对应表）|Wno（作业号）|Uno (用户ID)|Wstate (作业状态：已完成/未完成)

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

