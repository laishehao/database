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

@app.route('/login',methods=['POST'])
def app_login():
    """登录用户，需要传入用户名和密码
        成功：返回True
        失败：返回错误原因
    """
    username = request.form.get('username')
    password = request.form.get('password')
    if_ok= login (username, password)
    return if_ok

@app.route('/student',methods=['GET'])
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
    studentId = request.form.get('studentId')
    name = request.form.get('name')
    gender = request.form.get('gender')
    major = request.form.get('major')
    phone = request.form.get('phone')
    avatar = request.form.get('avatar')
    # age = request.form.get('age')
    
    if_ok= add_student (studentId,name,gender,major,phone,avatar)
    return if_ok

@app.route('/student',methods=['PUT'])
def app_update_student():
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    studentId = request.form.get('studentId')
    name = request.form.get('name')
    gender = request.form.get('gender')
    major = request.form.get('major')
    phone = request.form.get('phone')
    avatar = request.form.get('avatar')
    
    if_ok= update_student (studentId,name,gender,major,phone,avatar)
    return if_ok

# DELETE 请求处理
@app.route('/student/<int:id>', methods=['DELETE'])
def app_delete_student(id):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    if_ok= delete_student (id)
    return if_ok

# 课程处理
@app.route('/course',methods=['GET'])
def app_select_course():
    """查询学生信息
        成功：返回学生信息列表
        失败：返回错误原因
    """
    query=request.form.get('query')
    major=request.form.get('major')
    students = select_course (query, major)
    return students

@app.route('/student',methods=['POST'])
def app_add_course():
    """添加学生信息
        成功：返回True
        失败：返回错误原因
    """
    courseId = request.form.get('courseId')
    CourseName = request.form.get('CourseName')
    major = request.form.get('major')
    credits = request.form.get('credits')
    type = request.form.get('type')
    teacher = request.form.get('teacher')
    # age = request.form.get('age')
    
    if_ok= add_course (courseId,CourseName,major,credits,type,teacher)
    return if_ok

@app.route('/student',methods=['PUT'])
def app_update_course():
    """更新学生信息
        成功：返回True
        失败：返回错误原因
    """
    courseId = request.form.get('courseId')
    CourseName = request.form.get('CourseName')
    major = request.form.get('major')
    credits = request.form.get('credits')
    type = request.form.get('type')
    teacher = request.form.get('teacher')
    
    if_ok= update_course (courseId,CourseName,major,credits,type,teacher)
    return if_ok

# DELETE 请求处理
@app.route('/student/<int:id>', methods=['DELETE'])
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
    query=request.form.get('query')
    work = select_work (query)
    return work

@app.route('/homework',methods=['POST'])
def app_add_work():
    """添加学生信息
        成功：返回True
        失败：返回错误原因
    """
    title = request.form.get('title')
    content = request.form.get('course')
    progress = request.form.get('progress')
    active = request.form.get('active')
    # age = request.form.get('age')
    
    if_ok= add_work (title,content,progress,active)
    return if_ok

@app.route('/homework/<int:id>',methods=['DELETE'])
def app_delete_work(id):
    """删除学生信息
        成功：返回True
        失败：返回错误原因
    """
    if_ok= delete_work (id)
    return if_ok
 

# 修改这2行
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
    # app.run(debug=True)
=======
from flask import Flask
from sql import select_humans
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/name')
def get_name():
    return 'Hello World!'

@app.route('/fans')
def get_fans():
    return '1000'

@app.route('/human')
def sele_human():
    return str(select_humans())

# 修改这2行
if __name__ == '__main__':
    # app.run(debug=True, host='0.0.0.0', port=5000)
    app.run(debug=True)
# >>>>>>> Stashed changes
    # host='0.0.0.0' 允许所有IP访问
    # port=5000 指定端口（可选）