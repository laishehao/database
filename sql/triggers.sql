-- 触发器：一旦发布新的题目，就为选课学生创建write记录，初始状态为未完成
DELIMITER $$
CREATE TRIGGER trg_after_work_insert
AFTER INSERT ON Work
FOR EACH ROW
BEGIN
    -- 异常处理：如果触发器执行失败，记录错误信息但不阻止插入操作
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- 如果触发器出错，记录错误但继续执行
        INSERT INTO Error_Log (error_time, message) VALUES (NOW(), '触发器执行失败');
    END;
    
    -- 直接插入，不需要先检查（如果SC表中没有数据，INSERT会创建0条记录）
    INSERT INTO `Write` (Wno, Sno, State, Wrcontent, Score)
    SELECT 
        NEW.Wno,
        SC.Sno,
        0,     -- 未完成
        NULL,  -- 空内容
        NULL   -- 空分数
    FROM SC 
    WHERE Cno = NEW.Cno;
    
    -- 可选：更新作业进度状态
    -- UPDATE Work SET Wprogress = 1 WHERE Wno = NEW.Wno;
END$$
DELIMITER ;

-- 触发器：学生选课后，为该学生创建所有已发布作业的write记录
DELIMITER $$
CREATE TRIGGER trg_after_sc_insert
AFTER INSERT ON SC
FOR EACH ROW
BEGIN
    -- 异常处理：如果触发器执行失败，记录错误信息但不阻止插入操作
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- 如果触发器出错，记录错误但继续执行
        INSERT INTO Error_Log (error_time, message) VALUES (NOW(), '触发器执行失败');
    END;
    
    -- 插入该课程已发布的所有作业的write记录，如果出错，也不会插入无效数据
    INSERT INTO `Write` (Wno, Sno, State, Wrcontent, Score)
    SELECT 
        W.Wno,
        NEW.Sno,
        0,     -- 未完成
        NULL,  -- 空内容
        NULL   -- 空分数
    FROM Work W
    WHERE W.Cno = NEW.Cno AND W.Wprogress > 0;  -- 只为已发布的作业创建记录
END$$

-- 触发器：处理作业完成数量，例如write中产生变化，则更新Work表中的Wprogress字段
DELIMITER $$
CREATER TRIGGER trg_after_write_update
AFTER UPDATE ON `Write`
FOR EACH ROW
BEGIN
    DECLARE total_count INT;
    DECLARE completed_count INT;

    -- 计算该作业的总学生数和已完成学生数
    SELECT COUNT(*) INTO total_count FROM `Write` WHERE Wno = NEW.Wno;
    SELECT COUNT(*) INTO completed_count FROM `Write` WHERE Wno = NEW.Wno AND State = 1;

    -- 更新work表中的Wprogress字段为已完成学生数
    UPDATE Work
    SET Wprogress = completed_count
    WHERE Wno = NEW.Wno;
END$$
DELIMITER ;