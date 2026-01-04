-- 触发器：一旦发布新的题目，就创建一个write记录，初始状态为未完成
DELIMITER $$
CREATE TRIGGER trg_after_work_insert
AFTER INSERT ON Work
FOR EACH ROW
BEGIN
    DECLARE student_count INT DEFAULT 0;
    
    -- 记录执行日志
    INSERT INTO Trigger_Log (trigger_name, work_id, course_id, execution_time) 
    VALUES ('trg_after_work_insert', NEW.Wno, NEW.Cno, NOW());
    
    -- 统计选修该课程的学生数
    SELECT COUNT(*) INTO student_count 
    FROM SC 
    WHERE Cno = NEW.Cno;
    
    -- 如果有学生选课，创建Write记录
    IF student_count > 0 THEN
        INSERT INTO `Write` (Wno, Uno, State, Wrcontent, Score)
        SELECT 
            NEW.Wno,
            SC.Sno,      -- 假设Sno就是Uno
            0,           -- 状态：未完成
            NULL,        -- 内容：空
            NULL         -- 分数：空
        FROM SC 
        WHERE Cno = NEW.Cno;
        
        -- 可以更新作业状态或记录日志
        -- UPDATE Work SET Wprogress = 1 WHERE Wno = NEW.Wno;
    END IF;
END$$
DELIMITER ;
