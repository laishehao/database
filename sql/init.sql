-- 设置变量
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- 临时禁用自动提交
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- ============================================
-- 第一步: 删除所有现有对象
-- ============================================

-- 按依赖顺序删除表（从最底层的子表开始）
DROP TABLE IF EXISTS Answer_Image;
DROP TABLE IF EXISTS Title_Image;
DROP TABLE IF EXISTS `Write`;
DROP TABLE IF EXISTS Work;
DROP TABLE IF EXISTS SC;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student_Info;
DROP TABLE IF EXISTS Teacher_Info;

-- 删除所有存储过程（从 procedures.sql 文件中列出的）
DROP PROCEDURE IF EXISTS S_Register;
DROP PROCEDURE IF EXISTS Edit_Student;
DROP PROCEDURE IF EXISTS View_Student;
DROP PROCEDURE IF EXISTS S_Login;
DROP PROCEDURE IF EXISTS T_Register;
DROP PROCEDURE IF EXISTS Edit_Teacher;
DROP PROCEDURE IF EXISTS View_Teacher;
DROP PROCEDURE IF EXISTS T_Login;
DROP PROCEDURE IF EXISTS Push_homework;
DROP PROCEDURE IF EXISTS Edit_homework;
DROP PROCEDURE IF EXISTS View_work;
DROP PROCEDURE IF EXISTS Delete_homework;
DROP PROCEDURE IF EXISTS View_homework;
DROP PROCEDURE IF EXISTS Create_Course;
DROP PROCEDURE IF EXISTS Edit_Course;
DROP PROCEDURE IF EXISTS Delete_Course;
DROP PROCEDURE IF EXISTS View_Course;
DROP PROCEDURE IF EXISTS Create_Timage;
DROP PROCEDURE IF EXISTS Create_Aimage;
DROP PROCEDURE IF EXISTS Submit_Answer;
DROP PROCEDURE IF EXISTS Marking;
DROP PROCEDURE IF EXISTS Select_Course;
DROP PROCEDURE IF EXISTS Update_Work_Progress;
DROP PROCEDURE IF EXISTS Delete_Student_From_Course;
DROP PROCEDURE IF EXISTS Student_View_Work_List;
DROP PROCEDURE IF EXISTS Teacher_View_Student_List;
DROP PROCEDURE IF EXISTS Teacher_View_Course_List;
DROP PROCEDURE IF EXISTS Teacher_View_Work_List;
DROP PROCEDURE IF EXISTS Teacher_View_Courses_By_Tno;
DROP PROCEDURE IF EXISTS Teacher_View_Works_By_Cno;
DROP PROCEDURE IF EXISTS Teacher_View_Writes_By_Wno;
DROP PROCEDURE IF EXISTS Teacher_View_Writes_By_Sno;
DROP PROCEDURE IF EXISTS TcntCourse;
DROP PROCEDURE IF EXISTS ScntCourse;
DROP PROCEDURE IF EXISTS ScntWriting;

-- 删除所有触发器
DROP TRIGGER IF EXISTS trg_after_work_insert;
DROP TRIGGER IF EXISTS trg_after_sc_insert;

-- ============================================
-- 第二步: 导入所有文件
-- ============================================

-- 导入表结构
SOURCE /database_src/database_code/schema.sql

-- 导入存储过程
SOURCE /database_src/database_code/procedures.sql

-- 导入触发器
SOURCE /database_src/database_code/triggers.sql

-- ============================================
-- 第三步: 提交事务并恢复设置
-- ============================================

COMMIT;

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

-- 恢复自动提交
SET AUTOCOMMIT = 1;

-- ============================================
-- 第四步: 验证初始化结果
-- ============================================

SELECT '数据库初始化完成!' AS Message;

-- 显示所有表
SHOW TABLES;

-- 显示存储过程数量
SELECT COUNT(*) AS Procedure_Count 
FROM information_schema.routines 
WHERE routine_schema = DATABASE() 
AND routine_type = 'PROCEDURE';

-- 显示触发器数量
SELECT COUNT(*) AS Trigger_Count 
FROM information_schema.triggers 
WHERE trigger_schema = DATABASE();

-- ============================================
-- 数据库测试数据创建
-- ============================================

-- 使用T_Register注册教师（只包含基础信息）
CALL T_Register('张明', '13800138001', 'teacher123', 'zhangming@univ.edu');
CALL T_Register('李华', '13800138002', 'teacher456', 'lihua@univ.edu');
CALL T_Register('王伟', '13800138003', 'teacher789', 'wangwei@univ.edu');
CALL T_Register('刘芳', '13800138004', 'teacher101', 'liufang@univ.edu');
CALL T_Register('陈强', '13800138005', 'teacher202', 'chenqiang@univ.edu');

-- 通过Edit_Teacher更新完整信息
CALL Edit_Teacher(1, '张明', 'teacher123', 'zhangming@univ.edu', '男', '13800138001', '/avatars/teacher1.jpg');
CALL Edit_Teacher(2, '李华', 'teacher456', 'lihua@univ.edu', '女', '13800138002', '/avatars/teacher2.jpg');
CALL Edit_Teacher(3, '王伟', 'teacher789', 'wangwei@univ.edu', '男', '13800138003', '/avatars/teacher3.jpg');
CALL Edit_Teacher(4, '刘芳', 'teacher101', 'liufang@univ.edu', '女', '13800138004', '/avatars/teacher4.jpg');
CALL Edit_Teacher(5, '陈强', 'teacher202', 'chenqiang@univ.edu', '男', '13800138005', '/avatars/teacher5.jpg');

SELECT '教师数据创建完成' AS Status;

-- 使用S_Register注册学生
CALL S_Register('张三', '13900139001', 'student123', 'zhangsan@stu.univ.edu');
CALL S_Register('李四', '13900139002', 'student456', 'lisi@stu.univ.edu');
CALL S_Register('王五', '13900139003', 'student789', 'wangwu@stu.univ.edu');
CALL S_Register('赵六', '13900139004', 'student101', 'zhaoliu@stu.univ.edu');
CALL S_Register('钱七', '13900139005', 'student202', 'qianqi@stu.univ.edu');
CALL S_Register('孙八', '13900139006', 'student303', 'sunba@stu.univ.edu');
CALL S_Register('周九', '13900139007', 'student404', 'zhoujiu@stu.univ.edu');
CALL S_Register('吴十', '13900139008', 'student505', 'wushi@stu.univ.edu');
CALL S_Register('郑十一', '13900139009', 'student606', 'zhengshiyi@stu.univ.edu');
CALL S_Register('王十二', '13900139010', 'student707', 'wangshier@stu.univ.edu');

-- 通过Edit_Student更新完整信息
CALL Edit_Student(1, '张三', 'student123', 'zhangsan@stu.univ.edu', '男', '计算机科学', '13900139001', '/avatars/student1.jpg');
CALL Edit_Student(2, '李四', 'student456', 'lisi@stu.univ.edu', '女', '计算机科学', '13900139002', '/avatars/student2.jpg');
CALL Edit_Student(3, '王五', 'student789', 'wangwu@stu.univ.edu', '男', '软件工程', '13900139003', '/avatars/student3.jpg');
CALL Edit_Student(4, '赵六', 'student101', 'zhaoliu@stu.univ.edu', '女', '软件工程', '13900139004', '/avatars/student4.jpg');
CALL Edit_Student(5, '钱七', 'student202', 'qianqi@stu.univ.edu', '男', '人工智能', '13900139005', '/avatars/student5.jpg');
CALL Edit_Student(6, '孙八', 'student303', 'sunba@stu.univ.edu', '女', '人工智能', '13900139006', '/avatars/student6.jpg');
CALL Edit_Student(7, '周九', 'student404', 'zhoujiu@stu.univ.edu', '男', '计算机科学', '13900139007', '/avatars/student7.jpg');
CALL Edit_Student(8, '吴十', 'student505', 'wushi@stu.univ.edu', '女', '软件工程', '13900139008', '/avatars/student8.jpg');
CALL Edit_Student(9, '郑十一', 'student606', 'zhengshiyi@stu.univ.edu', '男', '人工智能', '13900139009', '/avatars/student9.jpg');
CALL Edit_Student(10, '王十二', 'student707', 'wangshier@stu.univ.edu', '女', '计算机科学', '13900139010', '/avatars/student10.jpg');

SELECT '学生数据创建完成' AS Status;

-- 使用Create_Course创建课程
CALL Create_Course('数据库原理', '计算机科学', 4, '必修', 1);
CALL Create_Course('数据结构', '计算机科学', 4, '必修', 2);
CALL Create_Course('操作系统', '计算机科学', 4, '必修', 3);
CALL Create_Course('软件工程导论', '软件工程', 3, '必修', 4);
CALL Create_Course('人工智能基础', '人工智能', 3, '必修', 5);
CALL Create_Course('机器学习', '人工智能', 3, '选修', 1);
CALL Create_Course('计算机网络', '计算机科学', 4, '必修', 2);
CALL Create_Course('算法设计与分析', '计算机科学', 3, '选修', 3);

SELECT '课程数据创建完成' AS Status;

-- 使用Select_Course进行选课
CALL Select_Course(1, 1);
CALL Select_Course(2, 1);
CALL Select_Course(3, 1);

CALL Select_Course(1, 2);
CALL Select_Course(2, 2);
CALL Select_Course(4, 2);
CALL Select_Course(6, 2);

CALL Select_Course(3, 3);
CALL Select_Course(4, 3);
CALL Select_Course(5, 3);

CALL Select_Course(1, 4);
CALL Select_Course(6, 4);

CALL Select_Course(2, 5);
CALL Select_Course(5, 5);
CALL Select_Course(6, 5);

CALL Select_Course(3, 6);
CALL Select_Course(4, 6);

CALL Select_Course(1, 7);
CALL Select_Course(2, 7);
CALL Select_Course(3, 7);
CALL Select_Course(6, 7);

CALL Select_Course(4, 8);
CALL Select_Course(5, 8);
CALL Select_Course(6, 8);

CALL Select_Course(1, 9);
CALL Select_Course(5, 9);

CALL Select_Course(2, 10);
CALL Select_Course(3, 10);
CALL Select_Course(4, 10);

SELECT '选课关系数据创建完成' AS Status;

-- 创建作业测试数据

CALL Push_homework('数据库设计作业1', '数据库原理', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('数据库设计作业2', '数据库原理', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('数据库设计作业3', '数据库原理', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('数据结构设计作业1', '数据结构', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('数据结构设计作业2', '数据结构', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('数据结构设计作业3', '数据结构', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '操作系统', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '操作系统', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '操作系统', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '软件工程导论', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '软件工程导论', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '软件工程导论', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '人工智能基础', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '人工智能基础', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '人工智能基础', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '机器学习', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '机器学习', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '机器学习', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '计算机网络', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '计算机网络', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '计算机网络', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

CALL Push_homework('测试作业1', '算法设计与分析', '2026-1-18 00:00:00', '2026-1-20 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业2', '算法设计与分析', '2026-1-21 00:00:00', '2026-1-23 00:00:00', 'TESTWORK...');
CALL Push_homework('测试作业3', '算法设计与分析', '2026-1-24 00:00:00', '2026-1-27 00:00:00', 'TESTWORK...');

SELECT '作业数据创建完成' AS Status;

-- 提交记录创建
CALL Submit_Answer(1, 1, '数据库设计文档.pdf');
CALL Submit_Answer(1, 2, '数据库设计.zip');
CALL Submit_Answer(1, 4, '数据库设计报告.doc');
CALL Submit_Answer(1, 7, '设计文档.pdf');
CALL Submit_Answer(1, 9, '数据库设计.rar');

CALL Submit_Answer(2, 1, 'SQL练习答案.sql');
CALL Submit_Answer(2, 2, '查询练习.zip');
CALL Submit_Answer(2, 4, 'SQL作业.sql');

-- 评分记录创建
CALL Marking(1, 1, 85, '设计合理，关系模式转换正确');
CALL Marking(1, 2, 90, '优秀，ER图设计清晰');
CALL Marking(1, 4, 78, '基本符合要求，可以更详细一些');
CALL Marking(1, 7, 92, '非常优秀，设计考虑周全');
CALL Marking(1, 9, 80, '良好，但缺少一些细节');

CALL Marking(2, 1, 88, NULL);
CALL Marking(2, 2, 95, '完成得很好，查询效率高');
CALL Marking(2, 4, 76, NULL);

-- 更多记录创建
CALL Submit_Answer(3, 1, '链表实现.c');
CALL Marking(3, 1, 82, '代码规范，但内存管理可以改进');

CALL Submit_Answer(3, 2, '数据结构作业.zip');
CALL Marking(3, 2, 88, NULL);

CALL Submit_Answer(3, 5, '链表程序.c');
CALL Marking(3, 5, 79, '功能实现，但代码注释不足');

CALL Submit_Answer(3, 7, '链表实现项目.rar');
CALL Marking(3, 7, 91, '优秀，测试用例全面');

CALL Submit_Answer(3, 10, '链表实验.c');
CALL Marking(3, 10, 85, '良好，算法实现正确');

SELECT '学生作业提交数据创建完成' AS Status;

-- 题目图片测试数据创建
CALL Create_Timage(1, 1, '/images/title/db_design_1.jpg');
CALL Create_Timage(1, 1, '/images/title/db_design_2.png');
CALL Create_Timage(2, 1, '/images/title/sql_exercise_1.jpg');
CALL Create_Timage(3, 2, '/images/title/linked_list_diagram.png');
CALL Create_Timage(4, 2, '/images/title/sort_algorithm.jpg');
CALL Create_Timage(5, 3, '/images/title/process_scheduling.jpg');
CALL Create_Timage(6, 4, '/images/title/requirements_diagram.png');
CALL Create_Timage(7, 5, '/images/title/neural_network.jpg');
CALL Create_Timage(8, 6, '/images/title/linear_regression.jpg');

SELECT '题目图片数据创建完成' AS Status;

-- 答案图片测试数据创建
CALL Create_Aimage(1, 1, '/images/answer/db_design_stu1_1.jpg');
CALL Create_Aimage(1, 1, '/images/answer/db_design_stu1_2.jpg');
CALL Create_Aimage(1, 2, '/images/answer/db_design_stu2_1.png');
CALL Create_Aimage(2, 2, '/images/answer/sql_stu2_1.jpg');
CALL Create_Aimage(3, 1, '/images/answer/linked_list_stu1_1.jpg');
CALL Create_Aimage(3, 7, '/images/answer/linked_list_stu7_1.png');
CALL Create_Aimage(4, 10, '/images/answer/sort_stu10_1.jpg');
CALL Create_Aimage(5, 3, '/images/answer/process_stu3_1.jpg');
CALL Create_Aimage(6, 2, '/images/answer/requirements_stu2_1.jpg');
CALL Create_Aimage(6, 8, '/images/answer/requirements_stu8_1.png');
CALL Create_Aimage(7, 8, '/images/answer/neural_stu8_1.jpg');
CALL Create_Aimage(8, 2, '/images/answer/regression_stu2_1.jpg');
CALL Create_Aimage(8, 7, '/images/answer/regression_stu7_1.jpg');

SELECT '答案图片数据创建完成' AS Status;


-- ============================================
-- 数据库基本功能测试
-- ============================================

-- 测试注册功能

-- 测试学生注册
CALL S_Register('张三', '13800138000', 'password123', 'zhangsan@test.com');
-- 检查返回结果和表中数据
SELECT * FROM Student_Info;

-- 测试老师注册
CALL T_Register('李老师', '13800138001', 'teacher123', 'li@test.com');
SELECT * FROM Teacher_Info;

-- 测试登录功能

-- 学生登录测试
CALL S_Login('13800138000', 'password123');

-- 错误密码测试
CALL S_Login('13800138000', 'wrongpassword');

-- 测试课程相关功能

-- 创建课程（假设老师Tno=1）
CALL Create_Course('程序设计', '计算机科学', 3, '必修', 1);

-- 查看课程
CALL View_Course(1);

-- 编辑课程
CALL Edit_Course(1, '高级数据库', '计算机科学', 4, '必修', 1);

-- 【触发器功能测试】

-- 测试作业发布触发器

-- 先插入选课记录
INSERT INTO SC (Cno, Sno) VALUES (1, 1);

-- 发布作业
CALL Push_homework('第一次作业', '高级数据库', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), '完成以下SQL语句...');

-- 检查触发器是否自动创建了Write记录
SELECT * FROM `Write`;

-- 测试学生选课触发器

-- 创建另一个学生
CALL S_Register('李四', '13800138002', 'password456', 'lisi@test.com');

-- 学生选课
CALL Select_Course(1, 2);

-- 检查是否自动为该学生创建了所有已发布作业的Write记录
SELECT * FROM `Write` WHERE Sno = 2;

-- 【作业提交流程测试】

-- 学生提交作业
CALL Submit_Answer(1, 1, '这是我的作业答案...');

-- 检查状态更新
SELECT * FROM `Write` WHERE Wno = 1 AND Sno = 1;

-- 检查作业进度是否更新
SELECT * FROM Work WHERE Wno = 1;

-- 老师打分
CALL Marking(1, 1, 95, '非常不错');

-- 【删除学生测试】

-- 教师从某课程中删除学生

CALL Delete_Student_From_Course(1, 2);

-- 【模糊查询功能测试】

-- 根据关键词查询作业列表
CALL Student_View_Work_List(1, '测试');

CALL Student_View_Work_List(1, '1');

-- 教师查询学生信息
CALL Teacher_View_Student_List('张');

CALL Teacher_View_Student_List('1');

-- 教师查询课程信息
CALL Teacher_View_Course_List('系统');

CALL Teacher_View_Course_List('2');

-- 教师查询作业列表
CALL Teacher_View_Work_List('2');

CALL Teacher_View_Work_List('试作');

-- 通过Tno精确查找教师所授课程
CALL Teacher_View_Courses_By_Tno(1);

CALL Teacher_View_Courses_By_Tno(3);

CALL Teacher_View_Courses_By_Tno(114514);

-- 通过Cno精确查询课程下的所有作业
CALL Teacher_View_Works_By_Cno(12);

CALL Teacher_View_Works_By_Cno(1);

-- 通过Wno精确查询作业下的所有学生提交记录
CALL Teacher_View_Writes_By_Wno(3);

CALL Teacher_View_Writes_By_Wno(1);

-- 通过Sno精确查询该学生的所有提交记录
CALL Teacher_View_Writes_By_Sno(2);

-- 根据Tno查看老师管理的课程总数
CALL TcntCourse(1);

-- 根据Sno查看学生所选课程总数
CALL ScntCourse(1);

-- 根据Sno查看学生当前未截止的作业数量
CALL ScntWriting(2);