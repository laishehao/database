# <<<<<<< Updated upstream
from flask import Flask, request,jsonify
from py_sql import *
from flask_cors import CORS
import logging
from flask import abort
def setup_logger():
    """配置日志记录器"""
    logger = logging.getLogger(__name__)
    
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
        logger.info('日志记录器已配置')
    return logger
logger = setup_logger()


app = Flask(__name__)
CORS(app)
@app.route('/')
def welcome():
    """主界面
        return: True
    """
    logger.info('访问了主界面')
    return 'True'

@app.route('/test')
def app_test():
    """测试数据库是否连接
    """
    logger.info('访问了测试界面')
    return str(test())

@app.route('/register',methods=['POST'])
def app_register():
    """ 注册用户，需要传入用户名、密码、姓名和邮箱
        成功：返回True
        失败：返回错误原因
    """
    role = request.form.get('role')
    password = request.form.get('password')
    name = request.form.get('name')
    email = request.form.get('email')
    phone = request.form.get('phone')
    
    logger.info('访问了注册界面')
    logger.info(f'role={role},password={password},name={name},email={email}')
        
    if_ok= register (role, password, name, email)
    
    logger.info(f'if_ok={if_ok}')
    return if_ok

@app.route('/api/user',methods=['POST'])
def app_userinfo():
    """ 
    用户信息修改，需要传入用户名、密码、姓名和邮箱
    """
    logger.info('访问了用户界面')
    phone = request.form.get('phone')
    name = request.form.get('name')
    email = request.form.get('email')
    logger.info(f'phone={phone},name={name},email={email}')
    
    if_ok= userinfo (phone, name, email)
    logger.info(f'if_ok={if_ok["msg"]}')

    return if_ok

@app.route('/login',methods=['POST'])
def app_login():
    """登录用户，需要传入用户名和密码
        成功：返回True
        失败：返回错误原因
    """
    logger.info('访问了登录界面')
    phone = request.form.get('phone')
    password = request.form.get('password')
    logger.info(f'phone={phone},password={password}')
    
    if_ok= login (phone, password)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/student',methods=['GET'])
def app_select_student():
    """
    查看学生列表
    """
    # print(request.args)
    # print(request.form)
    # print(request)
    query=request.args.get('query')
    page=request.args.get('page')
    page_size=request.args.get('pageSize')
    # print(query,page,page_size)
    logger.info('访问了学生界面')
    logger.info(f'query={query},page={page},page_size={page_size}')
    ans = select_student (query, page, page_size)
    logger.info(f'students[0]={ans["list"][0]}')
    return ans

@app.route('/student',methods=['POST'])
def app_add_student():
    """
    增加学生信息
    """
    logger.info('访问了学生添加界面')

    # studentId = request.form.get('studentId')
    # name = request.args.get('name')
    # gender = request.args.get('gender')
    # major = request.args.get('major')
    # phone = request.args.get('phone')
    data = request.get_json()
    studentId = data.get('studentId')
    name=data.get('name')
    gender=data.get('gender')
    major=data.get('major')
    phone = data.get('phone')   
    
    logger.info(f'studentId={studentId},name={name},gender={gender},major={major},phone={phone}')

    # avatar = request.args.get('avatar')
    # age = request.form.get('age')
    
    if_ok= add_student (studentId,name,gender,major,phone)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/student/<int:studentId>',methods=['PUT'])
def app_update_student(studentId):
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    logger.info('访问了学生更新界面')
    # studentId = request.args.get('studentId')
    # name = request.args.get('name')
    # gender = request.args.get('gender')
    # major = request.args.get('major')
    # phone = request.args.get('phone')
    # avatar = request.args.get('avatar')
    data = request.get_json()
    studentId = data.get('studentId')
    name=data.get('name')
    gender=data.get('gender')
    major=data.get('major')
    phone = data.get('phone')  
    logger.info(f'studentId={studentId},name={name},gender={gender},major={major},phone={phone}')
    
    if_ok= update_student (studentId,name,gender,major,phone)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

# DELETE 请求处理
@app.route('/student/<int:studentId>', methods=['DELETE'])
def app_delete_student(studentId):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    if_ok= delete_student (studentId)
    return if_ok

# 课程处理
@app.route('/course',methods=['GET'])
def app_select_course():
    """查询课程信息
        成功：返回学生信息列表
        失败：返回错误原因
    """
    logger.info('访问了课程查看界面')
    
    query=request.args.get('query')
    page=request.args.get('page')
    pageSize=request.args.get('pageSize')
    logger.info(f'query={query},page={page},pageSize={pageSize}')
    
    ans = select_course (query, page, pageSize)
    
    return ans

@app.route('/course',methods=['POST'])
def app_add_course():
    """
    增加课程
    """
    logger.info('访问了课程添加界面')
    courseId = request.args.get('courseId')
    CourseName = request.args.get('CourseName')
    major = request.args.get('major')
    credits = request.args.get('credits')
    type = request.args.get('type')
    teacher = request.args.get('teacher')
    # age = request.form.get('age')
    logger.info(f'courseId={courseId},CourseName={CourseName},major={major},credits={credits},type={type},teacher={teacher}')
    
    if_ok= add_course (courseId,CourseName,major,credits,type,teacher)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/course/<int:courseId>',methods=['PUT'])
def app_update_course(courseId):
    """
    更新课程信息，编辑课程
    """
    logger.info('访问了课程更新界面')
    # courseId = request.args.get('courseId')
    # CourseName = request.form.get('CourseName')
    # major = request.form.get('major')
    # credits = request.form.get('credits')
    # type = request.form.get('type')
    # teacher = request.form.get('teacher')
    data = request.get_json()
    # logger.info(f'data={data}')
    CourseName = data.get('courseName')
    major = data.get('major')
    credits = data.get('credits')
    type = data.get('type')
    teacher = data.get('teacher')
    
    logger.info(f'courseId={courseId},CourseName={CourseName},major={major},credits={credits},type={type},teacher={teacher}')
    
    if_ok= update_course (courseId,CourseName,major,credits,type,teacher)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

# DELETE 请求处理
@app.route('/course/<int:courseId>', methods=['DELETE'])
def app_delete_course(courseId):
    """删除课程信息
        成功：返回True
        失败：返回错误原因
    """
    logger.info('访问了课程删除界面')
    logger.info(f'courseId={courseId}')
    if_ok= delete_student (courseId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

# 作业处理
@app.route('/homework',methods=['GET'])
def app_select_work():
    """查询课程信息
        
    """
    logger.info('访问了作业查看界面')
    # abort(500)
    query=request.args.get('query')
    page = request.args.get('page')
    pageSize=request.args.get('pageSize')
    logger.info(f'query={query},page={page},pageSize={pageSize}')
    
    work = select_work (query,page,pageSize)
    logger.info(f'work[0]={work["list"][0]}')
    
    return work

@app.route('/homework/submissions',methods=['GET'])
def app_check_work():
    """查询具体作业提交情况
    """
    logger.info('访问了作业批改界面')
    work = request.args.get('workId')
    logger.info(f'work={work}')
    ans = check_work(work)
    
    logger.info(f'work[0]={ans["data"]["list"][0]}')
    # logger.info(f'work[0]={work["list"][0]}')
    
    return ans

@app.route('/homework',methods=['POST'])
def app_add_work():
    """添加作业，发布作业
    """
    logger.info('访问了作业添加界面')
    data=request.get_json()
    title = data.get('title')
    content = data.get('content')
    progress = data.get('progress')
    course = data.get('course')
    logger.info(f'title={title},content={content},progress={progress},course={course}')
    # age = request.form.get('age')
    
    if_ok= add_work (title,course,content,progress)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/homework/<int:workId>',methods=['DELETE'])
def app_delete_work(workId):
    """
    删除作业
    """
    logger.info('访问了作业删除界面')
    if_ok= delete_work (workId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
@app.route('/homework/<int:workId>',methods=['PUT'])
def app_update_work(workId):
    """
    编辑作业信息
    """
    logger.info('访问了作业更新界面')
    # workId = request.args.get('workId')
    data=request.get_json()
    title = data.get('title')
    content = data.get('content')
    
    logger.info(f'workId={workId},title={title},content={content}')
    if_ok= update_work (workId,title,content)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/homework/submit/<int:workId>',methods=['POST'])
def app_submit_work(workId):
    """
    提交作业
    """
    role=request.args.get('role')
    syudentId=request.args.get('studentId')
    workId=request.args.get('workId')
    writecheck=request.args.get('writecheck')
    if_ok= submit_work (role,syudentId,workId,writecheck)
    return if_ok
@app.route('/homework/<int:workId>',methods=['GET'])
def app_watch_work(workId):
    """
    学生查看某一项作业
    """
    logger.info('访问了作业查看界面')
    # data=request.get_json()
    # UserId = data.get('UserId')
    UserId = request.form.get('UserId')
    logger.info(f'workId={workId},UserId={UserId}')
    
    if_ok= watch_work (workId,UserId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

@app.route('/homework/grade',methods=['POST'])
def app_deal_work():
    """
    提交一个作业的批改情况
    """
    logger.info('访问了作业批改界面')
    data = request.get_json()
    # 检查必要参数
    if not data:
        return jsonify({"error": "没有收到数据"}), 400
    user_id = data.get('userId')
    work_id = data.get('workId')
    score = data.get('score')
    comment = data.get('teacherComment')
    logger.info(f'workId={work_id},UserId={user_id},score={score},teacherComment={comment}')
    if_ok= deal_work (work_id,user_id,comment,score)
    
    # logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# 修改这2行
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    # app.run(debug=True)
