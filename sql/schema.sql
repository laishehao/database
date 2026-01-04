-- 用户表定义
CREATE TABLE `User` (
    Uno int AUTO_INCREMENT PRIMARY KEY,
    Uname VARCHAR(50) NOT NULL,
    Upassword VARCHAR(100) NOT NULL,
    Uemail VARCHAR(100) NOT NULL UNIQUE,
    Urole VARCHAR(20),
    Ugender CHAR(1),
    Umajor VARCHAR(50),
    Uphone VARCHAR(20) NOT NULL UNIQUE,
    Uavatar VARCHAR(200)
);

-- 创建索引
CREATE UNIQUE INDEX idx_user_email ON `User`(Uemail);
CREATE UNIQUE INDEX idx_user_phone ON `User`(Uphone);
CREATE INDEX idx_user_role ON `User`(Urole);           -- 按角色查询

-- 课程表定义
CREATE TABLE Course (
    Cno int AUTO_INCREMENT PRIMARY KEY,
    Cname VARCHAR(100) NOT NULL UNIQUE,
    Cmajor VARCHAR(50),
    Ccredit INT,
    Ctype VARCHAR(20),
    Uno int,
    FOREIGN KEY (Uno) REFERENCES User(Uno) ON DELETE SET NULL,
    CONSTRAINT chk_ctype CHECK (Ctype IN ('必修', '选修'))				-- Ctype只能是必修或选修
);

-- 选课表定义
CREATE TABLE SC (
    Cno INT,
    Uno INT,
    PRIMARY KEY (Cno, Uno),
    FOREIGN KEY (Cno) REFERENCES Course(Cno) ON DELETE CASCADE,
    FOREIGN KEY (Uno) REFERENCES `User`(Uno) ON DELETE CASCADE
);

-- 创建索引
CREATE INDEX idx_course_name ON Course(Cname);
CREATE INDEX idx_course_teacher ON Course(Uno);

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

-- 创建索引
CREATE INDEX idx_work_course ON Work(Cno);
CREATE INDEX idx_work_progress ON Work(Wprogress);

-- 学生 - 作业对应关系定义
CREATE TABLE `Write` (
    Wno int NOT NULL,
    Uno int NOT NULL,
    State INT DEFAULT 0,
    Wrcontent TEXT,				-- 新增书写内容
    Score INT,					-- 新增打分
    PRIMARY KEY (Wno, Uno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Uno) REFERENCES `User`(Uno) ON DELETE CASCADE
);

-- 创建索引
CREATE INDEX idx_write_user ON `Write`(Uno);
CREATE INDEX idx_write_state ON `Write`(State);

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
    Uno int NOT NULL,			-- 如果Uno为老师，则这是题目图片，否则是书写作业的图片
    image_path VARCHAR(255),
    PRIMARY KEY (Wno, Uno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Uno) REFERENCES User(Uno) ON DELETE CASCADE
);