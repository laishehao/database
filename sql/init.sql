-- ============================================
-- 数据库完全初始化脚本
-- ============================================

-- 设置变量
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- 临时禁用自动提交
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- ============================================
-- 第一步: 删除所有数据
-- ============================================

-- 删除所有表
DROP TABLE IF EXISTS Answer_Image;
DROP TABLE IF EXISTS Title_Image;
DROP TABLE IF EXISTS `Write`;
DROP TABLE IF EXISTS Work;
DROP TABLE IF EXISTS SC;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student_Info;
DROP TABLE IF EXISTS Teacher_Info;

-- 删除所有存储过程
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

-- 删除所有触发器
DROP TRIGGER IF EXISTS trg_after_work_insert;
DROP TRIGGER IF EXISTS trg_after_sc_insert;

-- 验证删除结果
SHOW PROCEDURE STATUS WHERE Db = 'test_system';
SHOW TRIGGERS;

-- ============================================
-- 第二步: 导入所有文件
-- ============================================

SOURCE /database_src/database_code/schema.sql
SOURCE /database_src/database_code/database.sql
SOURCE /database_src/database_code/triggers.sql

-- ============================================
-- 第三步: 插入测试数据
-- ============================================

-- 插入测试教师
INSERT INTO Teacher_Info (Tname, Tpassword, Temail, Tgender, Tphone, Tavatar) 
VALUES 
('张老师', SHA2('teacher123', 256), 'zhang@example.com', '男', '13800138001', '/avatars/teacher1.jpg');

-- 插入测试学生
INSERT INTO Student_Info (Sname, Spassword, Semail, Sgender, Smajor, Sphone, Savatar)
VALUES
('张三', SHA2('student123', 256), 'zhangsan@example.com', '男', '计算机科学', '13800138111', '/avatars/student1.jpg'),
('李四', SHA2('student456', 256), 'lisi@example.com', '女', '软件工程', '13800138112', '/avatars/student2.jpg'),
('王五', SHA2('student789', 256), 'wangwu@example.com', '男', '数据科学', '13800138113', '/avatars/student3.jpg');

-- 插入测试课程
INSERT INTO Course (Cname, Cmajor, Ccredit, Ctype, Tno)
VALUES
('数据库原理', '计算机科学', 3, '必修', 1),
('软件工程', '软件工程', 4, '必修', 2),
('机器学习', '数据科学', 3, '选修', 1);

-- ============================================
-- 第四步: 测试注册功能
-- ============================================

-- 测试学生注册
CALL S_Register('张三', '13800138000', 'password123', 'zhangsan@test.com');
-- 检查返回结果和表中数据
SELECT * FROM Student_Info;

-- 测试老师注册
CALL T_Register('李老师', '13800138001', 'teacher123', 'li@test.com');
SELECT * FROM Teacher_Info;

-- ============================================
-- 第五步: 测试登录功能
-- ============================================

-- 学生登录测试
CALL S_Login('13800138000', 'password123');

-- 错误密码测试
CALL S_Login('13800138000', 'wrongpassword');

-- ============================================
-- 第六步: 测试课程功能
-- ============================================

-- 创建课程（假设老师Tno=1）
CALL Create_Course('程序设计', '计算机科学', 3, '必修', 1);

-- 查看课程
CALL View_Course(1);

-- 编辑课程
CALL Edit_Course(1, '高级数据库', '计算机科学', 4, '必修', 1);

-- 查看所有课程
select * from Course;

-- ============================================
-- 第七步: 测试触发器功能
-- ============================================

-- 测试作业发布触发器
-- 先插入选课记录
INSERT INTO SC (Cno, Sno) VALUES (1, 1);
-- 查看选课表
select * from SC;

-- 发布作业
CALL Push_homework('第一次作业', '高级数据库', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), '完成以下SQL语句...');
-- 查看作业表
select * from Work;

-- 检查触发器是否自动创建了Write记录
SELECT * FROM `Write`;

-- 测试学生选课触发器
-- 创建另一个学生
CALL S_Register('李四', '13800138002', 'password456', 'lisi@test.com');

-- 学生选课
CALL Select_Course(1, 2);

-- 检查是否自动为该学生创建了所有已发布作业的Write记录
SELECT * FROM `Write` WHERE Sno = 2;

-- ============================================
-- 第八步: 作业提交流程测试
-- ============================================

-- 学生提交作业
CALL Submit_Answer(1, 1, '这是我的作业答案...');

-- 检查状态更新
SELECT * FROM `Write` WHERE Wno = 1 AND Sno = 1;

-- 检查作业进度是否更新
SELECT * FROM Work WHERE Wno = 1;

-- 老师打分
CALL Marking(1, 1, 95);

-- 查看打分结果
SELECT * FROM `Write`;

-- ============================================
-- 第九步: 提交事务并恢复设置
-- ============================================

COMMIT;

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

-- 恢复自动提交
SET AUTOCOMMIT = 1;

-- ============================================
-- 验证初始化结果
-- ============================================

SELECT '数据库初始化完成!' AS Message;

-- 显示所有表
-- SHOW TABLES;

-- 显示所有存储过程
-- SHOW PROCEDURE STATUS WHERE Db = DATABASE();

-- 显示所有触发器
-- SHOW TRIGGERS;

-- 显示表记录数
-- SELECT 
--     'Teacher_Info' AS Table_Name, 
--     COUNT(*) AS Record_Count 
-- FROM Teacher_Info
-- UNION ALL
-- SELECT 
--     'Student_Info', 
--     COUNT(*) 
-- FROM Student_Info
-- UNION ALL
-- SELECT 
--     'Course', 
--     COUNT(*) 
-- FROM Course
-- UNION ALL
-- SELECT 
--     'SC', 
--     COUNT(*) 
-- FROM SC
-- UNION ALL
-- SELECT 
--     'Work', 
--     COUNT(*) 
-- FROM Work
-- UNION ALL
-- SELECT 
--     'Write', 
--     COUNT(*) 
-- FROM `Write`;
