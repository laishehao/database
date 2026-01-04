-- 触发器：一旦发布新的题目，就为选课学生创建write记录，初始状态为未完成
DELIMITER $$
CREATE TRIGGER trg_after_work_insert
AFTER INSERT ON Work
FOR EACH ROW
BEGIN
    -- 为所有选修该课程的学生创建Write记录
    INSERT INTO `Write` (Wno, Sno, State, Wrcontent, Score)
    SELECT 
        NEW.Wno,      -- 新作业的ID
        SC.Sno,       -- 选修该课程的学生学号
        0,            -- 状态：未完成
        NULL,         -- 内容：空
        NULL          -- 分数：空
    FROM SC 
    WHERE SC.Cno = NEW.Cno;  -- 选修了该课程的学生
END$$
DELIMITER ;