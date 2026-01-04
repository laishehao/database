-- 存储过程：学生注册
DELIMITER $$
CREATE PROCEDURE S_Register(							    -- 注册账户，返回用户id
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
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
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    
   
    INSERT INTO Student_Info (
        Sname, Spassword, Semail, Sphone
    ) VALUES (
        p_name, SHA2(p_password, 256), 					-- SHA2是对密码加密
        p_email, p_role,p_phone
    );
    
    COMMIT;											    -- 提交事务
    SELECT 'SUCCESS' AS result_type,  (select Sno from Student_Info where Sphone =  p_phone) AS user_id;
END
$$
DELIMITER ;


-- 存储过程：编辑学生信息，注意：不用修改的属性传入空值就好
DELIMITER $$
CREATE PROCEDURE Edit_Student(
    IN p_sno INT,
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
    IN p_gender CHAR(1),
    IN p_major VARCHAR(50),
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_avatar VARCHAR(200),
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
        set Sname = p_name, Spassword = p_password, Semail = p_email, Sgender = p_gender, Smajor = p_major, Sphone = p_phone, Savatar = p_avatar
        where Sno = p_cno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;


-- 存储过程：查看学生信息
DELIMITER $$
CREATE PROCEDURE View_Student(
    IN p_sno INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    SELECT 'SUCCESS' AS result_type, (select * from Student_Info where Sno =  p_sno);
    COMMIT;
    
END
$$
DELIMITER ;



-- 存储过程：学生登录
DELIMITER $$
CREATE PROCEDURE S_Login(							        -- 登录，返回用户uno和电话号码
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

    if EXISTS (select 1 from Student_Info where Sphone = p_phone and Spassword = p_password) THEN		    -- 判断电话号码和密码的组合是否在表中存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Sno from Student_Info where Sphone = p_phone) AS user_id;
    elseif EXISTS (select 1 from Student_Info where Sphone = p_phone) THEN								-- 登录失败，判断电话号码是否正确
        ROLLBACK;
        SELECT 'ERROR:PASSWORD_ERROR' AS result_type;		    -- 如果电话号码正确，那就是密码错误
    else
        ROLLBACK;
        SELECT 'ERROR:PHONE_ERROR' AS result_type;			    -- 否则电话号码不正确
    end if;
END
$$
DELIMITER ;



-- 存储过程：老师注册
DELIMITER $$
CREATE PROCEDURE T_Register(							-- 注册账户，返回用户id
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
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
        p_email, p_role,p_phone
    );
    
    COMMIT;											    -- 提交事务
    SELECT 'SUCCESS' AS result_type,  (select Tno from Teacher_Info where Tphone =  p_phone) AS user_id;
END
$$
DELIMITER ;


-- 存储过程：编辑老师信息
DELIMITER $$
CREATE PROCEDURE Edit_Student(
    IN p_sno INT,
    IN p_name VARCHAR(50),							    -- 用户名
    IN p_password VARCHAR(100),						    -- 密码
    IN p_email VARCHAR(100),							-- 邮箱
    IN p_gender CHAR(1),
    IN p_phone VARCHAR(20),							    -- 电话
    IN p_avatar VARCHAR(200),
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
    
    if not exists (select 1 from Teacher_Info where Tno = p_sno) then
        ROLLBACK;
        SELECT 'ERROR:STUDENT_NOT_EXISTS' AS result_type;
    else
        update Teacher_Info
        set Tname = p_name, Tpassword = p_password, Temail = p_email, Tgender = p_gender, Tphone = p_phone, Tavatar = p_avatar
        where Tno = p_tno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;


-- 存储过程：查看老师信息
DELIMITER $$
CREATE PROCEDURE View_Teacher(
    IN p_tno INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION			    -- 这是通用错误处理函数，出现系统异常时，进入到下面的代码执行
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    
    START TRANSACTION;								    -- 开始事务
    SELECT 'SUCCESS' AS result_type, (select * from Teacher_Info where Tno =  p_tno);
    COMMIT;
    
END
$$
DELIMITER ;


-- 存储过程：老师登录
DELIMITER $$
CREATE PROCEDURE T_Login(							        -- 登录，返回用户uno和电话号码
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

    if EXISTS (select 1 from Teacher_Info where Tphone = p_phone and Tpassword = p_password) THEN		    -- 判断电话号码和密码的组合是否在表中存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Tno from Teacher_Info where Tphone = p_phone) AS user_id;
    elseif EXISTS (select 1 from Teacher_Info where Tphone = p_phone) THEN								-- 登录失败，判断电话号码是否正确
        ROLLBACK;
        SELECT 'ERROR:PASSWORD_ERROR' AS result_type;		    -- 如果电话号码正确，那就是密码错误
    else
        ROLLBACK;
        SELECT 'ERROR:PHONE_ERROR' AS result_type;			    -- 否则电话号码不正确
    end if;
END
$$
DELIMITER ;


-- 存储过程：发布题目
DELIMITER $$
CREATE PROCEDURE Push_homework(					        -- 发布题目
    IN p_title VARCHAR(200),
    IN p_cname VARCHAR(100),
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

    if NOT EXISTS (select 1 from course where Cname = p_cname) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:CNAME_NOT_EXISTS' AS result_type;
    else
        select Cno into p_cno from course where Cname = p_cname;			-- 通过课程名查询得到的课程号并保存在临时变量中
        INSERT INTO Work (
            Wtitle, Cno, Wcontent, Wstart, Wover
        ) VALUES (
            p_title, p_cno, p_content, p_start, p_over
        );
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Wno from work where Cno = p_cno) AS Work_id;
    end if;
END
$$
DELIMITER ;


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

    if NOT EXISTS (select 1 from work where Wno = p_wno) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    else
        update Work
        set Wtitle = p_title, Wstart = p_start, Wover = p p_over, Wcontent = p_content
        where Wno = p_wno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;



-- 存储过程：查看题目
DELIMITER $$
CREATE PROCEDURE View_work(	                                    -- 查看作业题目内容以及完成人数
    IN p_wno int						                        -- 指名作业
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if EXISTS (select 1 from work where Wno = p_cno) THEN		                    -- 判断这个作业是否存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select * from work where Wno = p_wno);
    else
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;			-- 否则该作业不存在
    end if;
END
$$
DELIMITER ;


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

    if NOT EXISTS (select 1 from work where Wno = p_wno) THEN	    -- 还要判断指定的课程是否存在
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;
    else
        delete from work where Wno = p_wno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;


-- 存储过程：查看作业
DELIMITER $$
CREATE PROCEDURE View_homework(	                                -- 查看学生写的作业的内容和分数
    IN p_sno int,						                        -- 指名角色
    IN p_wno int						                        -- 指名作业
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if EXISTS (select 1 from `write` where Sno = p_sno and Wno = p_wno) THEN		                    -- 判断这个作业是否存在
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select Wrcontent AS write_content, Score from `write` where Sno = p_sno and Wno = p_wno);
    else
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type;			-- 否则该作业不存在
    end if;
END
$$
DELIMITER ;


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
        Cname, Cmajor, Ccredit, Ctype, Tno
    ) VALUES (
        p_cname, p_major,
        p_credit, p_type, p_tno
    );
    
    COMMIT;
    SELECT 'SUCCESS' AS result_type,  (select Cno from course where Cname =  p_cname) AS course_id;
END
$$
DELIMITER ;


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

    if not exists (select 1 from course where Cno = p_cno) then #检查该课程是否存在
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
    if not exists (select 1 from course where Cno = p_cno) then #检查该课程是否存在
        ROLLBACK;
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    else
        delete from course where Cno = p_cno;
        COMMIT;
        SELECT 'SUCCESS' AS result_type;
    end if;
END
$$
DELIMITER ;


-- 存储过程：查看课程
DELIMITER $$
CREATE PROCEDURE View_Course(		                        -- 返回是否删除成功
    p_cno INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;
    START TRANSACTION;
    if not exists (select 1 from course where Cno = p_cno) then #检查该课程是否存在
        ROLLBACK;
        SELECT 'ERROR:COURSE_NOT_EXIST' AS result_type;
    else
        COMMIT;
        SELECT 'SUCCESS' AS result_type, (select * from course where Cno = p_cno);
    end if;
END
$$
DELIMITER ;


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

    if exists (select 1 from work where Wno = p_wno and Cno = p_cno) then
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

    if exists (select 1 from `write` where Wno = p_wno and Sno = p_sno) then
        INSERT INTO Answer_Image (
            Wno, Sno, image_path
        ) VALUES (
            p_wno, p_sno, p_image_path
        );
        update `write` set State = 1 where Wno = p_wno and Sno = p_sno
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

    if exists (select 1 from `write` where Wno = p_wno and Sno = p_sno) then
        update `write`
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



-- 存储过程：打分
DELIMITER $$
CREATE PROCEDURE Marking(
    p_wno int,
    p_sno int,
    p_score int
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR:SYSTEM_ERROR' AS result_type;
    END;

    START TRANSACTION;

    if exists (select 1 from `write` where Wno = p_wno and Sno = p_sno) then
        update `write`
        set Score = p_score
        where Wno = p_wno and Sno = p_sno;
        commit;
        SELECT 'SUCCESS' AS result_type;
    else 
	ROLLBACK;
        SELECT 'ERROR:WRITE_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;

END
$$
DELIMITER ;

-- 存储过程：学生选课，以Student表与SC表为准
DELIMITER $$

CREATE PROCEDURE Select_Course(
    p_Cno INT,      -- 课程编号
    p_Sno INT       -- 学生学号
)
BEGIN
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
        LEAVE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Student_Info WHERE Sno = p_Sno) THEN
        SELECT 'ERROR:STUDENT_NOT_EXIST' AS result_type;
        LEAVE;
    END IF;

    -- 插入选课记录
    INSERT INTO SC (Cno, Sno) VALUES (p_Cno, p_Sno);
    
    SELECT 'SUCCESS' AS result_type;
END$$

DELIMITER ;

-- 存储过程：一旦有某张write表对应的记录发生改变，便更新其对应的Work表中的Wprogress字段
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
        LEAVE;
    END IF;  

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
END$$
DELIMITER ;