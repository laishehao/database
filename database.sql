CREATE TABLE User (
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

#创建索引
CREATE INDEX idx_course_name ON Course(Cname);
CREATE INDEX idx_course_teacher ON Course(Uno);


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

#创建索引
CREATE INDEX idx_work_course ON Work(Cno);
CREATE INDEX idx_work_progress ON Work(Wprogress);


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

#创建索引
CREATE INDEX idx_write_user ON `Write`(Uno);
CREATE INDEX idx_write_state ON `Write`(State);

CREATE TABLE Image (			-- 新增图片表，题目的图片和书写作业的图片都保存在里面
    Wno int NOT NULL,
    Uno int NOT NULL,			-- 如果Uno为-1，则这是题目图片，否则是书写作业的图片
    image_path VARCHAR(255),
    PRIMARY KEY (Wno, Uno),
    FOREIGN KEY (Wno) REFERENCES Work(Wno) ON DELETE CASCADE,
    FOREIGN KEY (Uno) REFERENCES `User`(Uno) ON DELETE CASCADE
);



DELIMITER $$
CREATE PROCEDURE Register(							    -- 注册账户，返回用户id
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
    IN p_role VARCHAR(20)								-- 角色（学生/老师）
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062  					    -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        IF EXISTS (SELECT 1 FROM `User` WHERE Uphone = p_phone) THEN
            SELECT 'ERROR:PHONE_EXISTS' AS result_type, NULL AS user_id, NULL AS user_role;	    -- 要么是电话号码重复了
        ELSE
            SELECT 'ERROR:EMAIL_EXISTS' AS result_type, NULL AS user_id, NULL AS user_role;	    -- 要么是邮箱重复了
        END IF;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type, NULL AS user_id, NULL AS user_role;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
   
    INSERT INTO `User` (
        Uname, Upassword, Uemail, Urole,Uphone
    ) VALUES (
        p_name, SHA2(p_password, 256), 					-- SHA2是对密码加密
        p_email, p_role,p_phone
    );
    
    COMMIT;											    -- 提交事务
    SELECT 'SUCCESS' AS result_type,  (select Uno from User where Uphone =  p_phone) AS user_id, p_role AS user_role;
END
$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE Login(							        -- 登录，返回用户uno和电话号码
    IN p_phone VARCHAR(20),
    IN p_password VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if EXISTS (select 1 from `User` where Uphone = p_phone and Upassword = p_password) THEN		    -- 判断电话号码和密码的组合是否在表中存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Uno from User where Uphone = p_phone) AS user_id, (select Urole from User where Uphone =  p_phone) AS user_role;
    elseif EXISTS (select 1 from `User` where Uphone = p_phone) THEN								-- 登录失败，判断电话号码是否正确
        ROLLBACK;
        SELECT 'ERROR:PASSWORD_ERROR' AS result_type, NULL AS user_id, NULL AS user_role;		    -- 如果电话号码正确，那就是密码错误
    else
        ROLLBACK;
        SELECT 'ERROR:PHONE_ERROR' AS result_type, NULL AS user_id, NULL AS user_role;			    -- 否则电话号码不正确
    end if;
END
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE Push_homework(					        -- 发布作业
    IN p_role VARCHAR(20),
    IN p_title VARCHAR(200),
    IN p_cname VARCHAR(100),
    IN p_content TEXT
)
BEGIN
    DECLARE p_cno int;									-- 临时变量，保存课程号，注意变量的声明必须放在一开始

    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;								    -- 开始事务

    if p_role = 'student' THEN
        ROLLBACK;
        SELECT 'ERROR:ROLE_ERROR' AS result_type;							-- 如果请求角色是学生，禁止发布作业
    elseif NOT EXISTS (select 1 from course where Cname = p_cname) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:CNAME_NOTEXISTS' AS result_type;
    else
        select Cno into p_cno from course where Cname = p_cname;			-- 通过课程名查询得到的课程号并保存在临时变量中
        INSERT INTO Work (
            Wtitle, Cno, Wcontent
        ) VALUES (
            p_title, p_cno, p_content
        );
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE View_homework(	                                -- 查看学生写的作业的内容（包括作业题目的文本，写的内容文本，分数）
    IN p_uno int,						                        -- 指名角色
    IN p_wno int						                        -- 指名作业
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if EXISTS (select 1 from `write` where Uno = p_uno and Wno = p_wno) THEN		                    -- 判断这个作业是否存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Wcontent from Work where Wno = p_wno) AS title, (select Wrcontent from `write` where Uno = p_uno and Wno = p_wno) AS write_content;
    else
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type, NULL AS title, NULL AS write_content;			-- 否则该作业不存在
    end if;
END
$$
DELIMITER ;




DELIMITER $$
CREATE PROCEDURE Create_Course(		                        -- 增加课程，返回课程id
    p_cname VARCHAR(100),
    p_major VARCHAR(50),
    p_credit INT,
    p_type VARCHAR(20),
    p_uno int							                    -- 指名教学老师
)
BEGIN

    DECLARE EXIT HANDLER FOR 1062  					        -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:CNAME_EXISTS' AS result_type;		    -- 课程名重复
    END;

    DECLARE EXIT HANDLER FOR 3819  					        -- 违反check约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:CTYPE_ERROR' AS result_type;			-- 课程类型只能是必修或选修
    END;

    DECLARE EXIT HANDLER FOR 1452					        -- 违反外键约束
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:TEACHER_NOT_EXIST' AS result_type;
    END;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    INSERT INTO course (
        Cname, Cmajor, Ccredit, Ctype, Uno
    ) VALUES (
        p_cname, p_major,
        p_credit, p_type, p_uno
    );
    
    COMMIT;
    SELECT 'SUCCESS' AS result_type,  (select Cno from course where Cname =  p_cname) AS course_id;
END
$$
DELIMITER ;




DELIMITER $$
CREATE PROCEDURE Create_Image(						        -- 增加图片
    p_wno int,
    p_uno int,
    p_image_path VARCHAR(255)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if (exists (select 1 from `write` where Wno = p_wno and Uno = p_uno)) or (p_uno = -1 and exists (select 1 from work where Wno = p_wno)) then
        INSERT INTO image (
            Wno, Uno, image_path
        ) VALUES (
            p_wno, p_uno, p_image_path
        );
        commit;
        SELECT 'SUCCESS' AS result_type;
    else 
	ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;

END
$$
DELIMITER ;

