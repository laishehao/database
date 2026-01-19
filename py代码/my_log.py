import logging
def setup_logger():
    """配置日志记录器"""
    logger = logging.getLogger("app_logger")
    
    if not logger.handlers:  # 避免重复添加处理器
        logger.setLevel(logging.DEBUG)
        
        # 控制台输出
        ch = logging.StreamHandler()
        ch.setLevel(logging.INFO)
        
        # 文件输出
        fh = logging.FileHandler('app.log', encoding='utf-8')
        fh.setLevel(logging.DEBUG)
        
        # 格式
        formatter = logging.Formatter(
            '%(asctime)s [%(levelname)s] %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        
        ch.setFormatter(formatter)
        fh.setFormatter(formatter)
        
        logger.addHandler(ch)
        logger.addHandler(fh)
        logger.info('my_app日志记录器已配置')
    return logger



def setup_logger_py():
    """配置日志记录器"""
    logger_ = logging.getLogger("sql_logger")
    
    if not logger_.handlers:  # 避免重复添加处理器
        logger_.setLevel(logging.DEBUG)
        
        # 控制台输出
        ch = logging.StreamHandler()
        ch.setLevel(logging.INFO)
        
        # 文件输出
        fh = logging.FileHandler('sql_py.log', encoding='utf-8')
        fh.setLevel(logging.DEBUG)
        
        # 格式
        formatter = logging.Formatter(
            '%(asctime)s [%(levelname)s] %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        
        ch.setFormatter(formatter)
        fh.setFormatter(formatter)
        
        logger_.addHandler(ch)
        logger_.addHandler(fh)
        logger_.info('sql日志记录器已配置')
    return logger_
