# <<<<<<< Updated upstream
from flask import Flask, request,jsonify
from sql import *
from flask_cors import CORS
app = Flask(__name__)
CORS(app)
@app.route('/')
def welcome():
    """主界面
        return: True
    """
    return 'True'

@app.route('/test')
def app_test():
    """测试数据库是否连接
    """
    return str(test())

@app.route('/register',methods=['POST'])
def app_register():
    """ 注册用户，需要传入用户名、密码、姓名和邮箱
        成功：返回True
        失败：返回错误原因
    """
    username = request.form.get('username')
    password = request.form.get('password')
    name = request.form.get('name')
    email = request.form.get('email')
    if_ok= register (username, password, name, email)
    return if_ok

@app.route('/api/login',methods=['POST'])
def app_login():
    """登录用户，需要传入用户名和密码
        成功：返回True
        失败：返回错误原因
    """
    username = request.form.get('username')
    password = request.form.get('password')
    if_ok= login (username, password)
    return if_ok

@app.route('/api/student',methods=['GET'])
def app_select_student():
    """查询学生信息
        成功：返回学生信息列表
        失败：返回错误原因
    """
    # print(request.args)
    # print(request.form)
    # print(request)
    query=request.args.get('query')
    page=request.args.get('page')
    page_size=request.args.get('pageSize')
    # print(query,page,page_size)
    students = select_student (query, page, page_size)
    
    return students

@app.route('/student',methods=['POST'])
def app_add_student():
    """添加学生信息
        成功：返回True
        失败：返回错误原因
    """
    studentId = request.args.get('studentId')
    name = request.args.get('name')
    gender = request.args.get('gender')
    major = request.args.get('major')
    phone = request.args.get('phone')
    # avatar = request.args.get('avatar')
    # age = request.form.get('age')
    
    if_ok= add_student (studentId,name,gender,major,phone)
    return if_ok

@app.route('/student',methods=['PUT'])
def app_update_student():
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    studentId = request.args.get('studentId')
    name = request.args.get('name')
    gender = request.args.get('gender')
    major = request.args.get('major')
    phone = request.args.get('phone')
    # avatar = request.args.get('avatar')
    
    if_ok= update_student (studentId,name,gender,major,phone)
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
    query=request.args.get('query')
    page=request.args.get('page')
    pageSize=request.args.get('pageSize')
    students = select_course (query, page, pageSize)
    return students

@app.route('/student',methods=['POST'])
def app_add_course():
    """添加学生信息
        成功：返回True
        失败：返回错误原因
    """
    courseId = request.args.get('courseId')
    CourseName = request.args.get('CourseName')
    major = request.args.get('major')
    credits = request.args.get('credits')
    type = request.args.get('type')
    teacher = request.args.get('teacher')
    # age = request.form.get('age')
    
    if_ok= add_course (courseId,CourseName,major,credits,type,teacher)
    return if_ok

@app.route('/student',methods=['PUT'])
def app_update_course():
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    courseId = request.args.get('courseId')
    CourseName = request.args.get('CourseName')
    major = request.args.get('major')
    credits = request.args.get('credits')
    type = request.args.get('type')
    teacher = request.args.get('teacher')
    
    if_ok= update_course (courseId,CourseName,major,credits,type,teacher)
    return if_ok

# DELETE 请求处理
@app.route('/student/<int:courseId>', methods=['DELETE'])
def app_delete_course(id):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    if_ok= delete_student (id)
    return if_ok

# 作业处理
@app.route('/homework',methods=['GET'])
def app_select_work():
    """查询学生信息
        成功：返回学生信息列表
        失败：返回错误原因
    """
    query=request.args.get('query')
    page = request.args.get('page')
    pageSize=request.args.get('pageSize')
    
    work = select_work (query,page,pageSize)
    return work

@app.route('/homework',methods=['POST'])
def app_add_work():
    """添加学生信息
        成功：返回True
        失败：返回错误原因
    """
    title = request.form.get('title')
    content = request.form.get('content')
    progress = request.form.get('progress')
    course = request.form.get('course')
    # age = request.form.get('age')
    
    if_ok= add_work (title,course,content,progress)
    return if_ok

@app.route('/homework/<int:workId>',methods=['DELETE'])
def app_delete_work(workId):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    if_ok= delete_work (workId)
    return if_ok
@app.route('/homework',methods=['PUT'])
def app_update_work():
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    workId = request.args.get('workId')
    title = request.args.get('title')
    content = request.args.get('content')
    
    if_ok= update_work (workId,title,content)
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

# 修改这2行
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    # app.run(debug=True)
