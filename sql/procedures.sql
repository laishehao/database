SELECT "S_Register procedure created." AS Message;

-- 存储过程：学生注册
DELIMITER $$
CREATE PROCEDURE S_Register(							    -- 注册账户，返回用户id
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100)							-- 邮箱（移除末尾逗号）
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062  					    -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        IF EXISTS (SELECT 1 FROM Student_Info WHERE Sphone = p_phone) THEN
            SELECT 'ERROR:PHONE_EXISTS' AS result_type;	    -- 要么是电话号码重复了
        ELSE
            SELECT 'ERROR:EMAIL_EXISTS' AS result_type;	    -- 要么是邮箱重复了
        END IF;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			        -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
   
    INSERT INTO Student_Info (
        Sname, Spassword, Semail, Sphone
    ) VALUES (
        p_name, SHA2(p_password, 256), 					-- SHA2是对密码加密
        p_email, p_phone
    );
    
    COMMIT;											    -- 提交事务
    SELECT 'SUCCESS' AS result_type,  (select Sno from Student_Info where Sphone =  p_phone) AS user_id;
END
$$
DELIMITER ;

SELECT "Edit_Student procedure created." AS Message;

-- 存储过程：编辑学生信息
DELIMITER $$
CREATE PROCEDURE Edit_Student(
    IN p_sno INT,
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
    IN p_gender CHAR(1),
    IN p_major VARCHAR(50),
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_avatar VARCHAR(200)							-- 头像（移除末尾逗号）
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062  					    -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        IF EXISTS (SELECT 1 FROM Student_Info WHERE Sphone = p_phone) THEN
            SELECT 'ERROR:PHONE_EXISTS' AS result_type;	    -- 电话号码重复了
        ELSEIF EXISTS (SELECT 1 FROM Student_Info WHERE Semail = p_email) THEN
            SELECT 'ERROR:EMAIL_EXISTS' AS result_type;	    -- 邮箱重复了
        ELSE
            SELECT 'ERROR:AVATAR_EXISTS' AS result_type;	-- 头像url重复了
        END IF;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
    if not exists (select 1 from Student_Info where Sno = p_sno) then
        ROLLBACK;
        SELECT 'ERROR:STUDENT_NOT_EXISTS' AS result_type;
    else
        update Student_Info
        set Sname = p_name, Spassword = SHA2(p_password, 256), Semail = p_email, Sgender = p_gender, Smajor = p_major, Sphone = p_phone, Savatar = p_avatar
        where Sno = p_sno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "View_Student procedure created." AS Message;

-- 存储过程：查看学生信息
DELIMITER $$
CREATE PROCEDURE View_Student(
    IN p_sno INT
)
BEGIN
    DECLARE v_student_exists INT;
    
    -- 检查学生是否存在
    SELECT COUNT(*) INTO v_student_exists
    FROM Student_Info WHERE Sno = p_sno;
    
    IF v_student_exists = 0 THEN
        SELECT 'ERROR:STUDENT_NOT_EXISTS' AS result_type;
    ELSE
        SELECT 
            'SUCCESS' AS result_type,
            Sno, 
            Sname, 
            Spassword, 
            Semail, 
            Sgender, 
            Smajor, 
            Sphone, 
            Savatar
        FROM Student_Info 
        WHERE Sno = p_sno;
    END IF;
END$$
DELIMITER ;

SELECT "S_Login procedure created." AS Message;

-- 存储过程：学生登录
DELIMITER $$
CREATE PROCEDURE S_Login(
    IN p_phone VARCHAR(20),
    IN p_password VARCHAR(100)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_password_hash VARCHAR(100);
    
    -- 获取密码哈希
    SET v_password_hash = SHA2(p_password, 256);
    
    -- 检查是否存在匹配的用户
    SELECT Sno INTO v_user_id
    FROM Student_Info 
    WHERE Sphone = p_phone AND Spassword = v_password_hash;
    
    IF v_user_id IS NOT NULL THEN
        SELECT 'SUCCESS' AS result_type, v_user_id AS user_id;
    ELSEIF EXISTS (SELECT 1 FROM Student_Info WHERE Sphone = p_phone) THEN
        SELECT 'ERROR:PASSWORD_ERROR' AS result_type;
    ELSE
        SELECT 'ERROR:PHONE_ERROR' AS result_type;
    END IF;
END$$
DELIMITER ;

SELECT "T_Register procedure created." AS Message;

-- 存储过程：老师注册
DELIMITER $$
CREATE PROCEDURE T_Register(							-- 注册账户，返回用户id
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100)							-- 邮箱（移除末尾逗号）
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062  					    -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        IF EXISTS (SELECT 1 FROM Teacher_Info WHERE Tphone = p_phone) THEN
            SELECT 'ERROR:PHONE_EXISTS' AS result_type;	    -- 要么是电话号码重复了
        ELSE
            SELECT 'ERROR:EMAIL_EXISTS' AS result_type;	    -- 要么是邮箱重复了
        END IF;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
   
    INSERT INTO Teacher_Info (
        Tname, Tpassword, Temail, Tphone
    ) VALUES (
        p_name, SHA2(p_password, 256), 					-- SHA2是对密码加密
        p_email, p_phone
    );
    
    COMMIT;											    -- 提交事务
    SELECT 'SUCCESS' AS result_type,  (select Tno from Teacher_Info where Tphone =  p_phone) AS user_id;
END
$$
DELIMITER ;

SELECT "Edit_Teacher procedure created." AS Message;

-- 存储过程：编辑老师信息
DELIMITER $$
CREATE PROCEDURE Edit_Teacher(
    IN p_tno INT,
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
    IN p_gender CHAR(1),
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_avatar VARCHAR(200)							-- 头像（移除末尾逗号）
)
BEGIN
    DECLARE EXIT HANDLER FOR 1062  					    -- 违反主键或唯一约束时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        IF EXISTS (SELECT 1 FROM Teacher_Info WHERE Tphone = p_phone) THEN
            SELECT 'ERROR:PHONE_EXISTS' AS result_type;	    -- 电话号码重复了
        ELSEIF EXISTS (SELECT 1 FROM Teacher_Info WHERE Temail = p_email) THEN
            SELECT 'ERROR:EMAIL_EXISTS' AS result_type;	    -- 邮箱重复了
        ELSE
            SELECT 'ERROR:AVATAR_EXISTS' AS result_type;	-- 头像url重复了
        END IF;
    END;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
    if not exists (select 1 from Teacher_Info where Tno = p_tno) then
        ROLLBACK;
        SELECT 'ERROR:TEACHER_NOT_EXISTS' AS result_type;
    else
        update Teacher_Info
        set Tname = p_name, Tpassword = SHA2(p_password, 256), Temail = p_email, Tgender = p_gender, Tphone = p_phone, Tavatar = p_avatar
        where Tno = p_tno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "View_Teacher procedure created." AS Message;

-- 存储过程：查看老师信息（修复版）
DELIMITER $$
CREATE PROCEDURE View_Teacher(
    IN p_tno INT
)
BEGIN
    DECLARE v_teacher_exists INT;
    
    -- 检查老师是否存在
    SELECT COUNT(*) INTO v_teacher_exists
    FROM Teacher_Info WHERE Tno = p_tno;
    
    IF v_teacher_exists = 0 THEN
        SELECT 'ERROR:TEACHER_NOT_EXISTS' AS result_type;
    ELSE
        SELECT 
            'SUCCESS' AS result_type,
            Tno, 
            Tname, 
            Tpassword, 
            Temail, 
            Tgender, 
            Tphone, 
            Tavatar
        FROM Teacher_Info 
        WHERE Tno = p_tno;
    END IF;
END$$
DELIMITER ;

SELECT "T_Login procedure created." AS Message;

-- 存储过程：老师登录
DELIMITER $$
CREATE PROCEDURE T_Login(
    IN p_phone VARCHAR(20),
    IN p_password VARCHAR(100)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_password_hash VARCHAR(100);
    
    -- 获取密码哈希
    SET v_password_hash = SHA2(p_password, 256);
    
    -- 检查是否存在匹配的用户
    SELECT Tno INTO v_user_id
    FROM Teacher_Info 
    WHERE Tphone = p_phone AND Tpassword = v_password_hash;
    
    IF v_user_id IS NOT NULL THEN
        SELECT 'SUCCESS' AS result_type, v_user_id AS user_id;
    ELSEIF EXISTS (SELECT 1 FROM Teacher_Info WHERE Tphone = p_phone) THEN
        SELECT 'ERROR:PASSWORD_ERROR' AS result_type;
    ELSE
        SELECT 'ERROR:PHONE_ERROR' AS result_type;
    END IF;
END$$
DELIMITER ;

SELECT "Push_homework procedure created." AS Message;

-- 存储过程：发布题目
DELIMITER $$
CREATE PROCEDURE Push_homework(
    IN p_title VARCHAR(200),
    IN p_cname VARCHAR(100),
    IN p_start DATETIME,
    IN p_over DATETIME,
    IN p_content TEXT
)
BEGIN
    DECLARE p_cno INT;
    DECLARE v_work_id INT;
    
    -- 检查课程是否存在
    SELECT Cno INTO p_cno 
    FROM Course WHERE Cname = p_cname;
    
    IF p_cno IS NULL THEN
        SELECT 'ERROR:CNAME_NOT_EXISTS' AS result_type;
    ELSE
        -- 插入作业
        INSERT INTO Work (Wtitle, Cno, Wcontent, Wstart, Wover)
        VALUES (p_title, p_cno, p_content, p_start, p_over);
        
        SET v_work_id = LAST_INSERT_ID();
        SELECT 'SUCCESS' AS result_type, v_work_id AS Work_id;
    END IF;
END$$
DELIMITER ;

SELECT "Edit_homework procedure created." AS Message;

-- 存储过程：编辑题目
DELIMITER $$
CREATE PROCEDURE Edit_homework(
    IN p_wno INT,
    IN p_title VARCHAR(200),
    IN p_start DATETIME,
    In p_over DATETIME,
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

    if NOT EXISTS (select 1 from Work where Wno = p_wno) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    else
        update Work
        set Wtitle = p_title, Wstart = p_start, Wover = p_over, Wcontent = p_content
        where Wno = p_wno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "View_work procedure created." AS Message;

-- 存储过程：查看题目
DELIMITER $$
CREATE PROCEDURE View_work(
    IN p_wno INT
)
BEGIN
    DECLARE v_work_exists INT;
    
    -- 检查作业是否存在
    SELECT COUNT(*) INTO v_work_exists
    FROM Work WHERE Wno = p_wno;
    
    IF v_work_exists = 0 THEN
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    ELSE
        SELECT 
            'SUCCESS' AS result_type,
            Wno, 
            Wtitle, 
            Cno, 
            Wcontent, 
            Wstart, 
            Wover, 
            Wprogress
        FROM Work 
        WHERE Wno = p_wno;
    END IF;
END$$
DELIMITER ;

SELECT "Delete_homework procedure created." AS Message;

-- 存储过程：删除题目，删除前python层要记得把关联的图片从服务器上删除
DELIMITER $$
CREATE PROCEDURE Delete_homework(
    IN p_wno INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;								    -- 开始事务

    if NOT EXISTS (select 1 from Work where Wno = p_wno) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    else
        delete from Work where Wno = p_wno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "View_homework procedure created." AS Message;

-- 存储过程：查看作业
DELIMITER $$
CREATE PROCEDURE View_homework(
    IN p_sno INT,
    IN p_wno INT
)
BEGIN
    DECLARE v_write_exists INT;
    
    -- 检查作业是否存在
    SELECT COUNT(*) INTO v_write_exists
    FROM `Write` WHERE Sno = p_sno AND Wno = p_wno;
    
    IF v_write_exists = 0 THEN
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    ELSE
        SELECT 
            'SUCCESS' AS result_type,
            Wrcontent AS write_content, 
            Score,
            State,
            Comment
        FROM `Write` 
        WHERE Sno = p_sno AND Wno = p_wno;
    END IF;
END$$
DELIMITER ;

SELECT "Create_Course procedure created." AS Message;

-- 存储过程：创建课程
DELIMITER $$
CREATE PROCEDURE Create_Course(		                        -- 增加课程，返回课程id
    p_cname VARCHAR(100),
    p_major VARCHAR(50),
    p_credit INT,
    p_type VARCHAR(20),
    p_tno int							                    -- 指名教学老师
)
BEGIN
    DECLARE v_errno INT;
    DECLARE v_errmsg VARCHAR(255);

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
        GET DIAGNOSTICS CONDITION 1 
            v_errno = MYSQL_ERRNO,
            v_errmsg = MESSAGE_TEXT;
        SELECT CONCAT('ERROR:', v_errno, ' - ', v_errmsg) AS result_type;
    END;

    START TRANSACTION;

    INSERT INTO Course (
        Cname, Cmajor, Ccredit, Ctype, Tno
    ) VALUES (
        p_cname, p_major,
        p_credit, p_type, p_tno
    );
    
    COMMIT;
    SELECT 'SUCCESS' AS result_type,  (select Cno from Course where Cname =  p_cname) AS course_id;
END
$$
DELIMITER ;

SELECT "Edit_Course procedure created." AS Message;

-- 存储过程：编辑课程
DELIMITER $$
CREATE PROCEDURE Edit_Course(		                        -- 返回是否修改成功
    p_cno INT,
    p_cname VARCHAR(100),
    p_major VARCHAR(50),
    p_credit INT,
    p_type VARCHAR(20),
    p_tno INT							                    -- 指名教学老师
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

    if not exists (select 1 from Course where Cno = p_cno) then #检查该课程是否存在
        ROLLBACK;
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    else
        update Course
        set Cname = p_cname, Cmajor = p_major, Ccredit = p_credit, Ctype = p_type, Tno = p_tno
        where Cno = p_cno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "Delete_Course procedure created." AS Message;

-- 存储过程：删除课程，会连锁到图片url的删除，因此删除前python层要记得把关联的图片从服务器上删除
DELIMITER $$
CREATE PROCEDURE Delete_Course(		                        -- 返回是否删除成功
    p_cno INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    START TRANSACTION;
    if not exists (select 1 from Course where Cno = p_cno) then #检查该课程是否存在
        ROLLBACK;
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    else
        delete from Course where Cno = p_cno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;

SELECT "View_Course procedure created." AS Message;

-- 存储过程：查看课程
DELIMITER $$
CREATE PROCEDURE View_Course(
    p_cno INT
)
BEGIN
    -- 不使用复杂错误处理，简化逻辑
    DECLARE v_course_exists INT;
    
    -- 检查课程是否存在
    SELECT COUNT(*) INTO v_course_exists
    FROM Course WHERE Cno = p_cno;
    
    IF v_course_exists = 0 THEN
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    ELSE
        SELECT 
            'SUCCESS' AS result_type,
            Cno, 
            Cname, 
            Cmajor, 
            Ccredit, 
            Ctype, 
            Tno
        FROM Course 
        WHERE Cno = p_cno;
    END IF;
END$$
DELIMITER ;

SELECT "Create_Timage procedure created." AS Message;

-- 存储过程：增加题目图片
DELIMITER $$
CREATE PROCEDURE Create_Timage(						        -- 增加图片
    p_wno int,
    p_cno int,
    p_image_path VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if exists (select 1 from Work where Wno = p_wno and Cno = p_cno) then
        INSERT INTO Title_Image (
            Wno, Cno, image_path
        ) VALUES (
            p_wno, p_cno, p_image_path
        );
        commit;
        SELECT 'SUCCESS' AS result_type;
    else 
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;		-- 该题目不存在
    end if;
END
$$
DELIMITER ;

SELECT "Create_Aimage procedure created." AS Message;

-- 存储过程：增加答案图片
DELIMITER $$
CREATE PROCEDURE Create_Aimage(						        -- 增加图片
    p_wno int,
    p_sno int,
    p_image_path VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if exists (select 1 from `Write` where Wno = p_wno and Sno = p_sno) then
        INSERT INTO Answer_Image (
            Wno, Sno, image_path
        ) VALUES (
            p_wno, p_sno, p_image_path
        );
        update `Write` set State = 1 where Wno = p_wno and Sno = p_sno;  -- 添加分号
        COMMIT;
        call Update_Work_Progress(p_wno);
        SELECT 'SUCCESS' AS result_type;
    else 
        ROLLBACK;
        SELECT 'ERROR:WRITE_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;
END
$$
DELIMITER ;

SELECT "Submit_Answer procedure created." AS Message;

-- 存储过程：提交作业答案
DELIMITER $$
CREATE PROCEDURE Submit_Answer(						        -- 增加图片
    p_wno int,
    p_sno int,
    p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if exists (select 1 from `Write` where Wno = p_wno and Sno = p_sno) then
        update `Write`
        set Wrcontent = p_content, State = 1
        where Wno = p_wno and Sno = p_sno;
        commit;
        call Update_Work_Progress(p_wno);
        SELECT 'SUCCESS' AS result_type;
    else 
        ROLLBACK;
        SELECT 'ERROR:WRITE_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;
END
$$
DELIMITER ;

SELECT "Marking procedure created." AS Message;

-- 存储过程：打分
DELIMITER $$
CREATE PROCEDURE Marking(
    p_wno int,
    p_sno int,
    p_score int,
    p_comment text
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if exists (select 1 from `Write` where Wno = p_wno and Sno = p_sno) then
        if p_score < 0 or p_score > 100 then
            ROLLBACK;
            SELECT 'ERROR:SCORE_OUT_OF_RANGE' AS result_type;	-- 分数不在0-100范围内
        else
            update `Write`
            set Score = p_score, Comment = p_comment
            where Wno = p_wno and Sno = p_sno;
            commit;
            SELECT 'SUCCESS' AS result_type;
        end if;
    else 
        ROLLBACK;
        SELECT 'ERROR:WRITE_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;
END
$$
DELIMITER ;

SELECT "Select_Course procedure created." AS Message;

-- 存储过程：学生选课，以Student表与SC表为准
DELIMITER $$

CREATE PROCEDURE Select_Course(
    p_Cno INT,      -- 课程编号
    p_Sno INT       -- 学生学号
)
BEGIN
    -- 声明退出标签
    DECLARE exit_flag BOOLEAN DEFAULT FALSE;

    -- 重复选课
    DECLARE EXIT HANDLER FOR 1062   
    BEGIN
        SELECT 'ERROR:COURSE_ALREADY_SELECTED' AS result_type;
    END;

    -- 违反外键约束
    DECLARE EXIT HANDLER FOR 1452   
    BEGIN
        SELECT 'ERROR:COURSE_OR_STUDENT_NOT_EXIST' AS result_type;
    END;

    -- 通用错误处理
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 判断p_Cno和p_Sno是否存在
    IF NOT EXISTS (SELECT 1 FROM Course WHERE Cno = p_Cno) THEN
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    ELSEIF NOT EXISTS (SELECT 1 FROM Student_Info WHERE Sno = p_Sno) THEN
        SELECT 'ERROR:STUDENT_NOT_EXIST' AS result_type;
    ELSE
        -- 插入选课记录
        INSERT INTO SC (Cno, Sno) VALUES (p_Cno, p_Sno);
        SELECT 'SUCCESS' AS result_type;
    END IF;
END$$

DELIMITER ;

SELECT "Update_Work_Progress procedure created." AS Message;

-- 存储过程：一旦有某张Write表对应的记录发生改变，便更新其对应的Work表中的Wprogress字段
DELIMITER $$
CREATE PROCEDURE Update_Work_Progress(
    IN p_wno INT
)
BEGIN
    -- 计算该作业的已完成提交人数
    DECLARE completed_count INT;
    -- 定义变量，用于检查对应作业是否存在
    DECLARE work_exists INT;

    -- 错误处理，出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 检查作业是否存在
    SELECT COUNT(*) INTO work_exists
    FROM Work
    WHERE Wno = p_wno;

    -- 如果作业不存在，返回错误信息并退出存储过程
    IF work_exists = 0 THEN
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    ELSE  
        -- 开始事务：计算作业已完成人数，并更新Work表中对应作业的Wprogress属性
        START TRANSACTION;

        SELECT COUNT(*) INTO completed_count
        FROM `Write`
        WHERE Wno = p_wno AND State = 1;

        -- 更新Work表中的Wprogress字段
        UPDATE Work
        SET Wprogress = completed_count
        WHERE Wno = p_wno;

        COMMIT;

        SELECT 'SUCCESS' AS result_type;
    END IF;
END$$
DELIMITER ;

SELECT "Delete_Student_From_Course procedure created." AS Message;

-- 存储过程：删除学生
-- 老师可以将某个学生从课程中删除
DELIMITER $$
CREATE PROCEDURE Delete_Student_From_Course(
    IN p_cno INT,
    IN p_sno INT
)
BEGIN
    -- 错误处理，出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 开始事务
    START TRANSACTION;
    -- 检查学生是否选修该课程
    IF NOT EXISTS (SELECT 1 FROM SC WHERE Cno = p_cno AND Sno = p_sno) THEN
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:STUDENT_NOT_ENROLLED' AS result_type;
    END;
    -- 学生选择了该课程，正常删除记录即可
    ELSE
        DELETE FROM SC WHERE Cno = p_cno AND Sno = p_sno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    END IF;
END$$
DELIMITER ;

SELECT "Student_View_Course_List procedure created." AS Message;

-- 存储过程：学生查询自己的作业列表
-- 关键词：作业标题、作业编号、作业所属课程等
DELIMITER $$
CREATE PROCEDURE Student_View_Work_List(
    IN p_sno INT,
    IN p_keyword VARCHAR(200)    -- 可选关键词，模糊匹配作业标题
)
BEGIN
    -- 错误处理，出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    -- 查询作业列表及提交状态和分数
    SELECT
        W.Wno,
        W.Wtitle,
        W.Cno,
        W.Wcontent,
        W.Wstart,
        W.Wover,
        W.Wprogress,
        IFNULL(WR.State, 0) AS Submission_State,
        IFNULL(WR.Score, NULL) AS Score
    FROM
        Work W
    LEFT JOIN
        `Write` WR ON W.Wno = WR.Wno AND WR.Sno = p_sno
    WHERE
        W.Wtitle LIKE CONCAT('%', p_keyword, '%')
        OR W.Wno LIKE CONCAT('%', p_keyword, '%')
        OR W.Cno LIKE CONCAT('%', p_keyword, '%')
    ORDER BY
        W.Wstart DESC;  -- 按作业开始时间降序排列
END$$
DELIMITER ;

SELECT "Teacher_View_Student_List procedure created." AS Message;

-- 存储过程：教师查询学生信息
-- 关键词：学生姓名、学号、邮箱等
DELIMITER $$
CREATE PROCEDURE Teacher_View_Student_List(
    IN p_keyword VARCHAR(100)    -- 可选关键词，模糊匹配学生姓名、学号或邮箱
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    -- 查询学生信息
    SELECT
        S.Sno,
        S.Sname,
        S.Semail,
        S.Sgender,
        S.Smajor,
        S.Sphone,
        S.Savatar
    FROM
        Student_Info S
    WHERE
        S.Sname LIKE CONCAT('%', p_keyword, '%')
        OR S.Sno LIKE CONCAT('%', p_keyword, '%')
        OR S.Semail LIKE CONCAT('%', p_keyword, '%')
    ORDER BY
        S.Sno ASC;  -- 按学号升序排列
END$$
DELIMITER ;

SELECT "Teacher_View_Course_List procedure created." AS Message;

-- 存储过程：教师查询课程信息
-- 关键词：课程名称、课程编号等
DELIMITER $$
CREATE PROCEDURE Teacher_View_Course_List(
    IN p_tno INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询课程信息
    SELECT
        C.Cno,
        C.Cname,
        C.Cmajor,
        C.Ccredit,
        C.Ctype,
        C.Tno
    FROM
        Course C
    WHERE
        C.Tno = p_tno and (
        C.Cname LIKE CONCAT('%', p_keyword, '%')
        OR C.Cno LIKE CONCAT('%', p_keyword, '%')
        )
    ORDER BY
        C.Cno ASC;  -- 按课程编号升序排列
END$$
DELIMITER ;

SELECT "Teacher_View_Work_List procedure created." AS Message;

-- 存储过程：教师查询作业列表
-- 关键词：作业标题、作业编号、所属课程等
-- 来自所有课程的作业都在一起，按照关键词过滤
DELIMITER $$
CREATE PROCEDURE Teacher_View_Work_List(
    IN p_tno INT,
    IN p_keyword VARCHAR(200)
)
BEGIN
    -- 错误处理，出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询课程信息
    SELECT
        W.Wno,
        W.Wtitle,
        W.Cno,
        W.Wcontent,
        W.Wstart,
        W.Wover,
        W.Wprogress
    FROM
        Work W
    JOIN Course C ON C.Cno = W.Cno
    WHERE
        C.Tno = p_tno and (
        W.Wtitle LIKE CONCAT('%', p_keyword, '%')
        OR W.Wno LIKE CONCAT('%', p_keyword, '%')
        OR W.Cno LIKE CONCAT('%', p_keyword, '%')
        )
    ORDER BY
        W.Wstart DESC;  -- 按作业开始时间降序排列
END$$
DELIMITER ;

SELECT "Teacher_View_Courses_By_Tno procedure created." AS Message;

-- 存储过程：通过Tno精确查询教师所教的所有课程
DELIMITER $$
CREATE PROCEDURE Teacher_View_Courses_By_Tno(
    IN p_tno INT
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询课程信息
    SELECT
        C.Cno,
        C.Cname,
        C.Cmajor,
        C.Ccredit,
        C.Ctype,
        C.Tno
    FROM
        Course C
    WHERE
        C.Tno = p_tno;
END$$
DELIMITER ;

SELECT "Teacher_View_Works_By_Cno procedure created." AS Message;

-- 存储过程：通过Cno精确查询课程下的所有作业
DELIMITER $$
CREATE PROCEDURE Teacher_View_Works_By_Cno(
    IN p_cno INT
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询作业信息
    SELECT
        W.Wno,
        W.Wtitle,
        W.Cno,
        W.Wcontent,
        W.Wstart,
        W.Wover,
        W.Wprogress
    FROM
        Work W
    WHERE
        W.Cno = p_cno;
END$$
DELIMITER ;

SELECT "Teacher_View_Writes_By_Wno procedure created." AS Message;

-- 存储过程：通过Wno精确查询作业下的所有学生提交记录
DELIMITER $$
CREATE PROCEDURE Teacher_View_Writes_By_Wno(
    IN p_wno INT
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询作业提交记录
    SELECT
        WR.Sno,
        WR.Wno,
        WR.Wrcontent,
        WR.Score,
        WR.State
    FROM
        `Write` WR
    WHERE
        WR.Wno = p_wno;
END$$
DELIMITER ;

SELECT "Teacher_View_Writes_By_Sno procedure created." AS Message;

-- 存储过程：通过Sno精确查询该学生的所有提交记录
DELIMITER $$
CREATE PROCEDURE Teacher_View_Writes_By_Sno(
    IN p_sno INT
)
BEGIN
    -- 错误处理：出现异常时回滚并返回错误信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    -- 查询作业提交记录
    SELECT
        WR.Sno,
        WR.Wno,
        WR.Wrcontent,
        WR.Score,
        WR.State
    FROM
        `Write` WR
    WHERE
        WR.Sno = p_sno;
END$$
DELIMITER ;

SELECT "TcntCourse procedure created." AS Message;

-- 存储过程：根据Tno查看老师管理的课程总数
DELIMITER $$

DROP PROCEDURE IF EXISTS TcntCourse$$

CREATE PROCEDURE TcntCourse(
    p_tno INT
)
BEGIN
    DECLARE v_course_count INT DEFAULT 0;
    DECLARE v_teacher_exists INT DEFAULT 0;
    
    -- 检查教师是否存在
    SELECT COUNT(*) INTO v_teacher_exists
    FROM Teacher_Info 
    WHERE Tno = p_tno;
    
    IF v_teacher_exists = 0 THEN
        SELECT 'ERROR:TEACHER_NOT_EXIST' AS result_type;
    ELSE
        -- 查询教师管理的课程数量
        SELECT COUNT(*) INTO v_course_count
        FROM Course 
        WHERE Tno = p_tno;
        
        -- 返回成功结果，包含课程数量
        SELECT 
            'SUCCESS' AS result_type,
            p_tno AS teacher_id,
            v_course_count AS course_count;
    END IF;
END$$

DELIMITER ;

SELECT "ScntCourse procedure created." AS Message;


-- 存储过程：根据Sno查看学生选的课程总数
DELIMITER $$

DROP PROCEDURE IF EXISTS ScntCourse$$

CREATE PROCEDURE ScntCourse(
    p_sno INT
)
BEGIN
    DECLARE v_course_count INT DEFAULT 0;
    DECLARE v_student_exists INT DEFAULT 0;
    
    -- 检查学生是否存在
    SELECT COUNT(*) INTO v_student_exists
    FROM Student_Info 
    WHERE Sno = p_sno;
    
    IF v_student_exists = 0 THEN
        SELECT 'ERROR:STUDENT_NOT_EXIST' AS result_type;
    ELSE
        -- 查询学生选修的课程数量
        SELECT COUNT(*) INTO v_course_count
        FROM SC 
        WHERE Sno = p_sno;
        
        -- 返回成功结果，包含课程数量
        SELECT 
            'SUCCESS' AS result_type,
            p_sno AS student_id,
            v_course_count AS course_count;
    END IF;
END$$

DELIMITER ;

SELECT "ScntWriting procedure created." AS Message;

-- 存储过程：根据Sno查看学生当前未截止的作业数量
DELIMITER $$

DROP PROCEDURE IF EXISTS ScntWriting$$

CREATE PROCEDURE ScntWriting(
    p_sno INT
)
BEGIN
    DECLARE v_work_count INT DEFAULT 0;
    DECLARE v_student_exists INT DEFAULT 0;
    
    -- 检查学生是否存在
    SELECT COUNT(*) INTO v_student_exists
    FROM Student_Info 
    WHERE Sno = p_sno;
    
    IF v_student_exists = 0 THEN
        SELECT 'ERROR:STUDENT_NOT_EXIST' AS result_type;
    ELSE
        -- 查询学生当前未截止的作业数量
        -- 注意：这里需要检查学生是否选了该课程
        SELECT COUNT(DISTINCT W.Wno) INTO v_work_count
        FROM Work W
        JOIN SC ON W.Cno = SC.Cno
        LEFT JOIN `Write` WR ON W.Wno = WR.Wno AND WR.Sno = p_sno
        WHERE SC.Sno = p_sno 
          AND NOW() < W.Wover
          AND (WR.State IS NULL OR WR.State = 0);  -- 未提交或未完成
        
        -- 返回成功结果，包含作业数量
        SELECT 
            'SUCCESS' AS result_type,
            p_sno AS student_id,
            v_work_count AS writing_count;
    END IF;
END$$

DELIMITER ;

SELECT "TcntWriting procedure created." AS Message;

-- 存储过程：根据Tno查看老师管理的正在进行的作业
DELIMITER $$

DROP PROCEDURE IF EXISTS TcntWriting$$

CREATE PROCEDURE TcntWriting(
    p_tno INT
)
BEGIN
    DECLARE v_work_count INT DEFAULT 0;
    DECLARE v_teacher_exists INT DEFAULT 0;
    
    -- 检查教师是否存在
    SELECT COUNT(*) INTO v_teacher_exists
    FROM Teacher_Info 
    WHERE Tno = p_tno;
    
    IF v_teacher_exists = 0 THEN
        SELECT 'ERROR:TEACHER_NOT_EXIST' AS result_type;
    ELSE
        -- 查询老师管理的当前未截止的题目数量
        SELECT COUNT(DISTINCT Wno) INTO v_work_count
        FROM Work W
        JOIN Course C ON W.Cno = C.Cno
        WHERE Tno = p_tno AND NOW() < Wover;
        
        -- 返回成功结果，包含作业数量
        SELECT 
            'SUCCESS' AS result_type,
            p_tno AS teacher_id,
            v_work_count AS writing_count;
    END IF;
END$$

DELIMITER ;

SELECT "TcntCorrect procedure created." AS Message;
-- 存储过程：根据Tno查看老师待批改的作业
DELIMITER $$

DROP PROCEDURE IF EXISTS TcntCorrect$$

CREATE PROCEDURE TcntCorrect(
    p_tno INT
)
BEGIN
    DECLARE v_work_count INT DEFAULT 0;
    DECLARE v_teacher_exists INT DEFAULT 0;
    
    -- 检查学生是否存在
    SELECT COUNT(*) INTO v_teacher_exists
    FROM Teacher_Info 
    WHERE Tno = p_tno;
    
    IF v_teacher_exists = 0 THEN
        SELECT 'ERROR:TEACHER_NOT_EXIST' AS result_type;
    ELSE

        SELECT COUNT(DISTINCT W.Wno) INTO v_work_count
        FROM Work W
        JOIN `Write` WR ON W.Wno = WR.Wno
        JOIN Course C ON C.Cno = W.Cno
        WHERE Tno = p_tno
          AND NOW() > W.Wover;
        
        -- 返回成功结果，包含作业数量
        SELECT 
            'SUCCESS' AS result_type,
            p_tno AS teacher_id,
            v_work_count AS correct_count;
    END IF;
END$$

DELIMITER ;


SELECT "View_Course_Student procedure created." AS Message;
-- 存储过程：根据Cno查看课程下的学生
DELIMITER $$

DROP PROCEDURE IF EXISTS View_Course_Student$$

CREATE PROCEDURE View_Course_Student(
    p_cno INT
)
BEGIN
    select 
        SC.Sno,
        Sname,
        Semail,
        Sgender,
        Smajor,
        Sphone,
        Savatar
    from
        SC
    join Student_Info SI ON SC.Sno = SI.Sno
    where Cno = p_cno;
END$$

DELIMITER ;