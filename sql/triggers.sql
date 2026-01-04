-- 触发器：一旦发布新的题目，就为选课学生创建write记录，初始状态为未完成
DELIMITER $$
CREATE TRIGGER trg_after_work_insert
AFTER INSERT ON Work
FOR EACH ROW
BEGIN
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