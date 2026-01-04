

CREATE TABLE `Teacher_Info` (
    Tno int AUTO_INCREMENT PRIMARY KEY,
    Tname VARCHAR(50) NOT NULL,
    Tpassword VARCHAR(100) NOT NULL,
    Temail VARCHAR(100) NOT NULL UNIQUE,
    Tgender CHAR(1) CHARACTER SET utf8mb4,
    Tphone VARCHAR(20) NOT NULL UNIQUE,
    Tavatar VARCHAR(200) UNIQUE,
    CONSTRAINT chk_tgender CHECK (Tgender IN ('男', '女'))  -- 修正：Ctype改为Tgender
);

CREATE TABLE `Student_Info` (
    Sno int AUTO_INCREMENT PRIMARY KEY,
    Sname VARCHAR(50) NOT NULL,
    Spassword VARCHAR(100) NOT NULL,
    Semail VARCHAR(100) NOT NULL UNIQUE,
    Sgender CHAR(1) CHARACTER SET utf8mb4,
    Smajor VARCHAR(50),
    Sphone VARCHAR(20) NOT NULL UNIQUE,
    Savatar VARCHAR(200) UNIQUE,
    CONSTRAINT chk_sgender CHECK (Sgender IN ('男', '女'))  -- 修正：Ctype改为Sgender
);


-- 课程表定义
CREATE TABLE Course (
    Cno int AUTO_INCREMENT PRIMARY KEY,
    Cname VARCHAR(100) NOT NULL UNIQUE,
    Cmajor VARCHAR(50),
    Ccredit INT,
    Ctype VARCHAR(20),
    Tno int,
    FOREIGN KEY (Tno) REFERENCES Teacher_Info(Tno) ON DELETE SET NULL,
    CONSTRAINT chk_ctype CHECK (Ctype IN ('必修', '选修'))				-- Ctype只能是必修或选修
);

-- 选课表定义
CREATE TABLE SC (
    Cno INT,
    Sno INT,
    PRIMARY KEY (Cno, Sno),
    FOREIGN KEY (Cno) REFERENCES Course(Cno) ON DELETE CASCADE,
    FOREIGN KEY (Sno) REFERENCES Student_Info(Sno) ON DELETE CASCADE
);


-- 作业表定义
CREATE TABLE Work (
    Wno int AUTO_INCREMENT PRIMARY KEY,
    Wtitle VARCHAR(200) NOT NULL,
    Cno int,
    Wprogress INT DEFAULT 0,
    Wcontent TEXT,				-- 新增题目内容
    Wstart DATETIME,
    Wover DATETIME,
    FOREIGN KEY (Cno) REFERENCES Course(Cno) ON DELETE CASCADE
);

-- 学生 - 作业对应关系定义
CREATE TABLE `Write` (
    Wno int NOT NULL,
    Sno int NOT NULL,
    State INT DEFAULT 0,
    Wrcontent TEXT,				-- 新增书写内容
    Score INT,					-- 新增打分
    PRIMARY KEY (Wno, Sno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Sno) REFERENCES Student_Info(Sno) ON DELETE CASCADE
);

-- 题目图片表定义
CREATE TABLE Title_Image (			-- 新增图片表，题目的图片和书写作业的图片都保存在里面
    Wno int NOT NULL,
    Cno int NOT NULL,			-- 如果Uno为老师，则这是题目图片，否则是书写作业的图片
    image_path VARCHAR(255),
    PRIMARY KEY (Wno, Cno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Cno) REFERENCES Course(Cno) ON DELETE CASCADE
);


-- 答案图片表定义
CREATE TABLE Answer_Image (			-- 新增图片表，题目的图片和书写作业的图片都保存在里面
    Wno int NOT NULL,
    Sno int NOT NULL,			-- 如果Uno为老师，则这是题目图片，否则是书写作业的图片
    image_path VARCHAR(255),
    PRIMARY KEY (Wno, Sno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Sno) REFERENCES Student_Info(Sno) ON DELETE CASCADE
);



-- 1. 教师信息表索引
CREATE INDEX idx_teacher_name ON Teacher_Info(Tname);  -- 按姓名查询
CREATE INDEX idx_teacher_gender ON Teacher_Info(Tgender);  -- 按性别统计
CREATE INDEX idx_teacher_avatar ON Teacher_Info(Tavatar);  -- 头像查询

-- 2. 学生信息表索引
CREATE INDEX idx_student_name ON Student_Info(Sname);  -- 按姓名查询
CREATE INDEX idx_student_gender ON Student_Info(Sgender);  -- 按性别统计
CREATE INDEX idx_student_major ON Student_Info(Smajor);  -- 按专业查询
CREATE INDEX idx_student_avatar ON Student_Info(Savatar);  -- 头像查询
CREATE INDEX idx_student_email ON Student_Info(Semail);  -- 邮箱登录查询（唯一索引已存在，但这是复合索引的基础）

-- 3. 课程表索引
CREATE INDEX idx_course_name ON Course(Cname);  -- 课程名查询（唯一索引已存在）
CREATE INDEX idx_course_teacher ON Course(Tno);  -- 按教师查询课程（修正：原来错误地使用了Sno）
CREATE INDEX idx_course_major ON Course(Cmajor);  -- 按专业查询课程
CREATE INDEX idx_course_type ON Course(Ctype);  -- 按课程类型查询
CREATE INDEX idx_course_credit ON Course(Ccredit);  -- 按学分查询
-- 复合索引：经常同时按专业和类型查询
CREATE INDEX idx_course_major_type ON Course(Cmajor, Ctype);

-- 4. 选课表索引
CREATE INDEX idx_sc_student ON SC(Sno);  -- 查询学生选课情况（主键已包含Cno+Sno）
CREATE INDEX idx_sc_course ON SC(Cno);  -- 查询课程被选情况（主键已包含Cno+Sno）
-- 复合索引：查询特定学生特定课程类型的选课情况（可能需要连接Course表）
-- 注意：由于SC表没有课程类型字段，这个索引可能需要根据实际查询模式调整

-- 5. 作业表索引
CREATE INDEX idx_work_course ON Work(Cno);  -- 按课程查询作业
CREATE INDEX idx_work_progress ON Work(Wprogress);  -- 按进度查询作业
CREATE INDEX idx_work_title ON Work(Wtitle);  -- 按标题搜索作业
CREATE INDEX idx_work_start_time ON Work(Wstart);  -- 按开始时间查询
CREATE INDEX idx_work_end_time ON Work(Wover);  -- 按结束时间查询
-- 复合索引：经常同时按课程和进度查询
CREATE INDEX idx_work_course_progress ON Work(Cno, Wprogress);
-- 复合索引：按时间范围查询作业
CREATE INDEX idx_work_time_range ON Work(Wstart, Wover);

-- 6. 学生作业表索引
CREATE INDEX idx_write_student ON `Write`(Sno);  -- 按学生查询作业
CREATE INDEX idx_write_work ON `Write`(Wno);  -- 按作业查询学生完成情况（主键已包含）
CREATE INDEX idx_write_state ON `Write`(State);  -- 按状态查询（如未提交、已提交等）
CREATE INDEX idx_write_score ON `Write`(Score);  -- 按分数查询或排序
-- 复合索引：查询学生特定状态的作业
CREATE INDEX idx_write_student_state ON `Write`(Sno, State);
-- 复合索引：查询作业的分数分布
CREATE INDEX idx_write_work_score ON `Write`(Wno, Score);
-- 复合索引：学生作业提交状态和分数的综合查询
CREATE INDEX idx_write_student_state_score ON `Write`(Sno, State, Score);

-- 7. 题目图片表索引
-- 主键索引已经覆盖(Wno, Cno)的查询
CREATE INDEX idx_title_image_course ON Title_Image(Cno);  -- 按课程查询图片
CREATE INDEX idx_title_image_work ON Title_Image(Wno);  -- 按作业查询图片（主键已包含）
-- 复合索引：查询课程相关的作业图片
CREATE INDEX idx_title_image_course_work ON Title_Image(Cno, Wno);

-- 8. 答案图片表索引
-- 主键索引已经覆盖(Wno, Sno)的查询
CREATE INDEX idx_answer_image_student ON Answer_Image(Sno);  -- 按学生查询答案图片
CREATE INDEX idx_answer_image_work ON Answer_Image(Wno);  -- 按作业查询答案图片（主键已包含）
-- 复合索引：查询学生所有作业的答案图片
CREATE INDEX idx_answer_image_student_work ON Answer_Image(Sno, Wno);