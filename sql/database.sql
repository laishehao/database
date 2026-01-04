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


-- 存储过程：发布作业
DELIMITER $$
CREATE PROCEDURE Push_homework(					        -- 发布题目
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

    if NOT EXISTS (select 1 from course where Cname = p_cname) THEN	    -- 还要判断指定的课程是否存在
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


-- 存储过程：查看作业
DELIMITER $$
CREATE PROCEDURE View_homework(	                                -- 查看学生写的作业的内容（包括作业题目的文本，写的内容文本，分数）
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
        SELECT 'SUCCESS' AS result_type, (select Wcontent from Work where Wno = p_wno) AS title, (select Wrcontent from `write` where Sno = p_sno and Wno = p_wno) AS write_content;
    else
        ROLLBACK;
        SELECT 'ERROR:WORK_NOT_EXISTS' AS result_type, NULL AS title, NULL AS write_content;			-- 否则该作业不存在
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
    end if
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
    end if
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
    end if
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
        INSERT INTO image (
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
        INSERT INTO image (
            Wno, Sno, image_path
        ) VALUES (
            p_wno, p_sno, p_image_path
        );
        commit;
        SELECT 'SUCCESS' AS result_type;
    else 
	ROLLBACK;
        SELECT 'ERROR:WRITE_NOT_EXISTS' AS result_type;		-- 该作业不存在
    end if;

END
$$
DELIMITER ;

