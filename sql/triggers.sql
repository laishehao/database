-- 触发器：一旦发布新的题目，就创建一个write记录，初始状态为未完成
DELIMITER $$
CREATE TRIGGER trg_after_work_insert
AFTER INSERT ON Work
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE student_sno INT;
    DECLARE student_cursor CURSOR FOR SELECT Sno FROM SC WHERE Cno = NEW.Cno;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN student_cursor;

    read_loop: LOOP
        FETCH student_cursor INTO student_sno;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO `Write` (Wno, Uno, State) VALUES (NEW.Wno, student_sno, 0);
    END LOOP;

    CLOSE student_cursor;
END$$ 
DELIMITER ;
