# <<<<<<< Updated upstream
from flask import Flask, request,jsonify
from py_sql import *
from flask_cors import CORS
import logging
from flask import abort
from my_log import *

logger = setup_logger()
logger_py = setup_logger_py()
# logger_py.info('日志记录器已配置')
app = Flask(__name__)
# # CORS(app)
# CORS(app, resources={r"/homework/*": {"origins": "http://localhost:8080"}})
# 配置1：最宽松的配置（推荐学习阶段用）
CORS(app, supports_credentials=True)  # 允许所有来源，包括携带凭证
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
# TODO:注册
@app.route('/register',methods=['POST'])
def app_register():
    """ 注册用户，需要传入用户名、密码、姓名和邮箱
        成功：返回True
        失败：返回错误原因
    """
    data = request.get_json()
    
    role=data.get('role')
    password = data.get('password')
    name = data.get('name')
    e_mail = data.get('email')   
    phone=data.get('phone')   
    
    logger.info('访问了注册界面')
    logger.info(f'role={role},password={password},name={name},email={e_mail}')
        
    if_ok= register (role, name, password,phone, e_mail)
    
    logger.info(f'if_ok={if_ok}')
    return if_ok
# TODO：用户信息修改?
@app.route('/api/user',methods=['POST'])
def app_userinfo():
    """ 
    用户信息修改，需要传入用户名、密码、姓名和邮箱
    """
    logger.info('访问了用户界面')
    # phone = request.form.get('phone')
    # name = request.form.get('name')
    # email = request.form.get('email')
    data = request.get_json()
    phone = data.get('phone')
    name = data.get('name')
    email = data.get('email')
    role=data.get('role')
    logger.info(f'phone={phone},name={name},email={email},role={role}')
    
    if_ok= userinfo (phone, name, email,role)
    logger.info(f'if_ok={if_ok["msg"]}')

    return if_ok
# TODO:登录
@app.route('/login',methods=['POST'])
def app_login():
    """登录用户，需要传入用户名和密码
        成功：返回True
        失败：返回错误原因
    """
    logger.info('访问了登录界面')
    data=request.get_json()
    phone=data.get('phone')
    password = data.get('password')
    logger.info(f'phone={phone},password={password}')
    
    if_ok= login (phone, password)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# TODO:查看学生列表
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
    role=request.args.get('role')
    id=request.args.get('id')
    # print(query,page,page_size)
    logger.info('访问了学生界面')
    logger.info(f'query={query},page={page},page_size={page_size},role={role},id={id}')
    ans = select_student (query, page, page_size,role,id)
    logger.info(f'students[0]={ans["list"][0]}')
    return ans
# TODO：老师添加学生?
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
    Cno=data.get('Cno')
    Sno=data.get('Sno')
    logger.info(f'studentId={studentId},name={name},gender={gender},major={major},phone={phone}')

    # avatar = request.args.get('avatar')
    # age = request.form.get('age')
    
    if_ok= add_student (studentId,name,gender,major,phone,Cno,Sno)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# TODO: #老师查看学生详细信息
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
# TODO：老师删除学生
@app.route('/student/<int:studentId><int:Cno>', methods=['DELETE'])
def app_delete_student(studentId,Cno):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    logger_py.info(f'studentId={studentId},id={Cno}')
    if_ok= delete_student (studentId,Cno)
    return if_ok

# 课程处理
# TODO：老师查询课程
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
    id=request.args.get('id')
    logger.info(f'query={query},page={page},pageSize={pageSize},id={id}')
    
    ans = select_course (query, page, pageSize,id)
    
    return ans
# TODO：新建课程
@app.route('/course',methods=['POST'])
def app_add_course():
    """
    增加课程
    """
    logger.info('访问了课程添加界面')
    # courseId = request.args.get('courseId')
    # CourseName = request.args.get('CourseName')
    # major = request.args.get('major')
    # credits = request.args.get('credits')
    # type = request.args.get('type')
    # teacher = request.args.get('teacher')
    # age = request.form.get('age')
    data = request.get_json()
    courseId = data.get('courseId')
    CourseName = data.get('courseName')
    major = data.get('major')
    credits = data.get('credits')
    type = data.get('type')
    teacher = data.get('teacher')
    logger.info(f'courseId={courseId},CourseName={CourseName},major={major},credits={credits},type={type},teacher={teacher}')
    
    if_ok= add_course (courseId,CourseName,major,credits,type,teacher)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# TODO：老师编辑课程
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
    userId=data.get('userId')
    logger.info(f'courseId={courseId},CourseName={CourseName},major={major},credits={credits},type={type},userId={userId}')
    
    if_ok= update_course (courseId,CourseName,major,credits,type,userId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

# DELETE 请求处理
# TODO：删除课程
@app.route('/course/<int:courseId>', methods=['DELETE'])
def app_delete_course(courseId):
    """删除课程信息
        成功：返回True
        失败：返回错误原因
    """
    logger.info('访问了课程删除界面')
    logger.info(f'courseId={courseId}')
    if_ok= delete_course (courseId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok

# 作业处理
# TODO：查看作业
@app.route('/homework',methods=['GET'])
def app_select_work():
    """查询作业信息
        
    """
    logger.info('访问了作业查看界面')
    # abort(500)
    # data=request.get_json()
    query=request.args.get('query')
    page = request.args.get('page')
    pageSize=request.args.get('pageSize')
    role = request.args.get('role')
    id = request.args.get('id')
    # page = data.get("page")
    # pageSize = data.get("pageSize")
    logger.info(f'query={query},page={page},pageSize={pageSize},role={role},id={id}')
    
    work = select_work (query,page,pageSize,role,id)
    logger.info(f'work[0]={work["list"][0]}')
    
    return work
# TODO：老师从作业列表跳到作业详情页查看学生

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
# TODO：老师发布作业
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
# TODO: 老师作业删除
@app.route('/homework/<int:workId>',methods=['DELETE'])
def app_delete_work(workId):
    """
    删除作业
    """
    logger.info('访问了作业删除界面')
    if_ok= delete_work (workId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# TODO: 老师作业更新
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
# TODO: 学生提交作业
@app.route('/homework/submit/<int:workId>',methods=['POST'])
def app_submit_work(workId):
    """
    提交作业
    """
    role=request.form.get('role')
    syudentId=request.args.get('studentId')
    workId=request.args.get('workId')
    writecheck=request.args.get('writecheck')
    # data = request.get_json()
    # role = data.get('role')
    # syudentId = data.get('studentId')
    # writecheck = data.get('writecheck')
    logger.info(f'role={role},syudentId={syudentId},workId={workId},writecheck={writecheck}')
    if_ok= submit_work (role,syudentId,workId,writecheck)
    return if_ok
# TODO: 学生做作业界面
@app.route('/homework/<int:workId>',methods=['GET'])
def app_watch_work(workId):
    """
    学生查看某一项作业bianji
    """
    logger.info('访问了作业查看界面')
    # data=request.get_json()
    # UserId = data.get('UserId')
    UserId = request.args.get('userId')
    logger.info(f'workId={workId},UserId={UserId}')
    
    if_ok= watch_work (workId,UserId)
    logger.info(f'if_ok={if_ok["msg"]}')
    return if_ok
# TODO:  老师批改作业界面
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
@app.route('/dashboard/stats')
def app_hello_world():
    id=request.args.get('id')
    role=request.args.get('role')
    logger.info(f'id={id},role={role}')
    dashboard=dashboard_stats(id,role)
    return 'Hello World!'
# 修改这2行
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    # app.run(debug=True)
