import pymysql
import logging
# from flask import jsonify
from my_app import logger_py

# 创建连接
connection = pymysql.connect(
    host='',
    user='lzh',
    password='12345678',
    database='619database',
    port=3306,
    charset='utf8'
    # cursorclass=pymysql.cursors.DictCursor
)

# 创建连接
# connection = pymysql.connect(
#     host='127.0.0.1',
#     user='root',
#     password='123456',
#     database='laizhehao',
#     port=3306,
#     charset='utf8'
#     # cursorclass=pymysql.cursors.DictCursor
# )

    
    
def test():
    """用于测试数据库连接是否成功
    Returns:
        json: _description_
    """
    try:
        with connection.cursor() as cursor:
            # sql = "INSERT INTO student (Sno, Sname, Sdept) VALUES ('11234', 'test', 'CS'); "
            # cursor.execute(sql)  # 注意参数必须是元组，单个参数也要加逗号
            
            # # 提交事务
            # connection.commit()
            
            # sql = "desc testtable;"
            sql = "show tables;"
            cursor.execute(sql)  # 注意参数必须是元组，单个参数也要加逗号
            result = cursor.fetchall()
            # print(result[1][0])
            # print(type(result[1][0]))
            print(result)
            # for res in result:
            #     print(res[2])
    except:
        connection.rollback()  # 异常时回滚
        raise
    finally:
        connection.close()
    return result
    

def register(role,name, password, phone,email):
    user={
        "id":0,
        "username":name,
        "name":name,
        "role":role,
        "phone":phone,
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    ans={
        "msg":"注册成功",
        "user" :user,
        "code":400
    }
    if role == "student":
        try:
            with connection.cursor() as cursor:
                params = (name,phone,password, email)
                logger_py.info('数据库开始调用学生注册储存过程')
                cursor.callproc('S_Register', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚
            raise
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                params = (name,phone,password, email)
                logger_py.info('数据库开始调用老师注册储存过程')
                cursor.callproc('T_Register', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚

    return ans
def login(phone, password):
    
    result=""
    try:
        with connection.cursor() as cursor:
            params = ( phone,password)
            logger_py.info('数据库开始调用"学生登录"储存过程')
            cursor.callproc('S_Login', params)
            result = cursor.fetchall()
            logger_py.info(result)
            if "ERROR" in result[0][0]:
                logger_py.info('数据库开始调用"老师登录"储存过程')
                cursor.callproc('T_Login', params)
                result = cursor.fetchall()
                logger_py.info(result)
                if "ERROR" in result[0][0]:
                    ans={
                        "msg":"账号或密码错误",
                        "code":404
                    }
                    return ans
                else:
                    role="teacher"
                    cursor.callproc('View_Teacher',(result[0][1],) )
                    
                    result = cursor.fetchall()
                    result=result[0]
                    logger_py.info(result)
                    
            else:
                role="student"
                cursor.callproc('View_Student',(result[0][1],) )
                
                result = cursor.fetchall()
                result=result[0]
                logger_py.info(result)
                
    except:
        connection.rollback()  # 异常时回滚
        raise
    # 创建用户信息对象
    user={
        "username":result[1],
        "name":result[2],
        "role":role,
        "id":result[1],
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    # 创建登录响应对象
    ans={
        "msg":"登录成功",
        "user" :user
    }
    return ans
def userinfo(phone, name, email,role):
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                # params = (name,phone,password, email)
                logger_py.info('数据库开始修改用户信息')
                # cursor.callproc('T_Register', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚
    else:
        try:
            with connection.cursor() as cursor:
                # params = (name,phone,password, email)
                logger_py.info('数据库开始修改用户信息')
                # cursor.callproc('T_Register', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚
    # try:
    #     with connection.cursor() as cursor:
    #         # params = (name,phone,password, email)
    #         logger_py.info('数据库开始修改用户信息')
    #         # cursor.callproc('T_Register', params)
    #         result = cursor.fetchall()
    #         logger_py.info(result)
    # except:
    #     connection.rollback()  # 异常时回滚
    user={
        "email":"example@example.com",
        "name":"testname",
        "role":"teacher",
        "phone":1234567890,
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    ans={
        "msg":"修改成功",
        "code":404,
        "user" :user
    }
    return ans
# TODO:查看学生列表无法测试
def select_student(query, page, page_size,role,id):
    result=""
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                params = (id,query)
                logger_py.info('数据库开始查询学生')
                cursor.callproc('Teacher_View_Student_List', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            logger_py.info('查询失败')
            connection.rollback()  # 异常时回滚
        students=[]
    else:
        try:
            with connection.cursor() as cursor:
                params = (id,query)
                logger_py.info('数据库开始查询学生')
                cursor.callproc('Student_View_Work_List', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚
        students=[]
    # test 王小明
    student= {
          "studentId": "2023001",
          "name": "王小明",
          "gender": "男",
          "major": "计算机科学",
          "phone": "13812345678",
          "avatar":
            "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
        }
    # role_check=True
    students=[student]*20
    
    list=students
    total=list.__len__()
    ans={
        "total":total,
        "list":list
    }
    return ans

def add_student (studentId, name, major, gender,phone,cno,sno):
    # try:
    #     with connection.cursor() as cursor:
    #         # params = (cno,sno)
    #         logger_py.info('数据库开始添加学生')
    #         # cursor.callproc('Select_Course', params)
    #         result = cursor.fetchall()
    #         logger_py.info(result)
    # except:
    #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"添加成功"
    }
    return ans
def update_student(studentId, name, major, gender,phone):
    try:
        with connection.cursor() as cursor:
            params = (studentId)
            logger_py.info('数据库开始更新学生信息')
            cursor.callproc('View_Student', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"更新成功"
    }
    return ans
def delete_student(studentId,cno):
    try:
        with connection.cursor() as cursor:
            params = (cno,studentId)
            logger_py.info('数据库开始查添加学生')
            cursor.callproc('Delete_Student_From_Course', params)
            result = cursor.fetchall()
            logger_py.info(f"result={result}")
    except:
        logger_py.info('删除失败')
        connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
def select_course(query,page,pageSize,Tno):
    try:
        with connection.cursor() as cursor:
            params = (Tno,query)
            logger_py.info('数据库开始修改用户信息')
            cursor.callproc('Teacher_View_Course_List', params)
            result = cursor.fetchall()
            logger_py.info(result)
            corses=[]
            for row in result:
                # 确保元组长度至少为5
                if len(row) < 5:
                    continue
                    
                # 创建课程字典
                course = {
                    "courseId": str(row[0]),  # 转换为字符串
                    "courseName": str(row[1]),
                    "major": str(row[2]),
                    "credits": int(row[3]),
                    "type": str(row[4]),
                    "teacher": "",  # 原始数据中不包含，设为空字符串
                    "time": "",    # 原始数据中不包含，设为空字符串
                    "place": "",   # 原始数据中不包含，设为空字符串
                    "selected": False
                }
                corses.append(course)
                logger_py.info(f"course={course}")
    except:
        logger_py.info('查询失败')
        connection.rollback()  # 异常时回滚
    ans={
        "total":10,
        "list":[
            {
                "courseId": "1",
                "courseName": "高等数学",
                "major": "计算机科学与技术",
                "credits": 4,
                "type": "必修",
                "teacher": "张三",
                "time": "周一、二、四、五 第1-2节",
                "place": "教室A101",
                "selected": False
           
            }
        ]+corses
    }
    return ans
def add_course(courseId,CourseName,major,credits,type,teacher):
    # try:
    #     with connection.cursor() as cursor:
    #         params = (CourseName,major,credits,type,teacher)
    #         logger_py.info('数据库开始修改用户信息')
    #         cursor.callproc('Create_Course', params)
    #         result = cursor.fetchall()
    #         logger_py.info(result)
    # except:
    #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"添加成功"
    }
    return ans

def update_course(courseId,CourseName,major,credits,type1,userId):
    try:
        with connection.cursor() as cursor:
            params = (courseId,CourseName,major,credits,type1,userId)
            logger_py.info('老师编辑课程')
            cursor.callproc('Edit_Course', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        logger_py.info('老师编辑课程')
        connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"更新成功"
    }
    return ans
def delete_course(courseId):
    # try:
    #     with connection.cursor() as cursor:
    #         params = (courseId)
    #         logger_py.info('数据库开始修改用户信息')
    #         cursor.callproc('Delete_Course', params)
    #         result = cursor.fetchall()
    #         logger_py.info(result)
    # except:
    #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
    
def select_work(query,page,pageSize,role,id):
    
    result=""
    # logger_py.info('query is None')
    if role == "teacher":
        
        try:
            with connection.cursor() as cursor:
                params = (id,query)
                logger_py.info('老师查询作业信息')
                cursor.callproc('Teacher_View_Work_List', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            logger_py.info('老师查询作业信息')
            connection.rollback()  # 异常时回滚
    else:
        try:
            with connection.cursor() as cursor:
                params = (id,query)
                logger_py.info('学生查询作业信息')
                cursor.callproc('Student_View_Work_List', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            connection.rollback()  # 异常时回滚

    homwork={
            'workId':'1000000',
            'title':'test',
            'course':'test',
            'content':'test',
            'active':True,
            'progerss':50,
            'completed':True
        }
    homworks=[]
    homworks.append(homwork)
    total=homworks.__len__()
    for item in result:
        homework = {
            'workId': item[0],
            'title': item[1],
            'course': f'课程{item[2]}',  # 根据实际情况调整
            'content': item[3],
            'startDate': item[4].isoformat() if item[4] else None,
            'endDate': item[5].isoformat() if item[5] else None,
            'active': True,  # 根据业务逻辑判断
            'progress': item[7] ,
            'completed': 1 if item[8] is not None else 0  # 假设第7位是完成状态
        }
        homworks.append(homework)
    ans={
        # "code":400,
        "total":total,
        "list":homworks
    }
    return ans
def add_work(title,course,content,progress,start,over):
    # try:
        #     with connection.cursor() as cursor:
        #         params = (title,course,start,over,content)
        #         logger_py.info('数据库开始修改用户信息')
        #         cursor.callproc('Push_homework', params)
        #         result = cursor.fetchall()
        #         logger_py.info(result)
        # except:
        #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"添加成功"
    }
    return ans
def update_work(workId,title,content):
    ans={
        "code":200,
        "msg":"更新成功"
    }
    return ans
def delete_work(workId):
    # try:
        #     with connection.cursor() as cursor:
        #         params = (workId)
        #         logger_py.info('数据库开始修改用户信息')
        #         cursor.callproc('Delete_Course', params)
        #         result = cursor.fetchall()
        #         logger_py.info(result)
        # except:
        #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
def submit_work(role,studentId,workId,writecheck):
     # try:
        #     with connection.cursor() as cursor:
        #         params = (workId)
        #         logger_py.info('数据库开始修改用户信息')
        #         cursor.callproc('Submit_Answer', params)
        #         result = cursor.fetchall()
        #         logger_py.info(result)
        # except:
        #     connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"提交成功"
    }
    return ans
def watch_work(workId,UserId):
    # TODO:作答无法修改、截止时间无法修改
    work=""
    write=""
    course=""
    detail={
            "workId": 1,
            "title": 1,
            "course": 11,
            "content": 1,
            "startDate": 1,
            "endDate": 1,
            "context":"作答",
            "score":11,
            # "comment":"评语",
            "teacherComment":"评语",
            "completed":True
            }
    try:
        with connection.cursor() as cursor:
            params = (UserId,workId)
            logger_py.info('学生做作业界面-写了什么')
            cursor.callproc('View_homework', params)
            write = cursor.fetchall()
            wt=write[0]
            logger_py.info(wt)
            
            params = (workId,)
            logger_py.info('学生做作业界面-作业是什么')
            cursor.callproc('View_work', params)
            work = cursor.fetchall()
            wk=work[0]
            logger_py.info(f"wk={wk}")
            
            params = (int(wk[3]),)
            logger_py.info('学生做作业界面-课程是什么')
            cursor.callproc('View_Course', params)
            course = cursor.fetchall()
            cs=course[0]
            logger_py.info(f"cs={cs}")
            formatted_date = wt[6].strftime('%Y-%m-%d %H:%M')
            detail={
                "workId": workId,
                "title": wk[2],# 作业名字
                "course": cs[2],# 课程名字
                "content": wk[4],# 作业具体内容
                "startDate": wk[5],
                "endDate": formatted_date,# 截止时间
                "context":wt[1],# 作答
                "score":wt[2],# 分数
                "comment":wt[3],
                "teacherComment":wt[4],# 老师评语
                "completed":1 if wt[2] is not None else 0   # 是否有评语
            }
            logger_py.info(f"detail={detail}")
    except:
        logger_py.info('数据库查询失败')
        connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"查看成功",
        "detail":detail
    }
    return ans

def check_work(workId):
    result=""
    try:
        st=""
        with connection.cursor() as cursor:
            params = (3,)
            logger_py.info('数据库开始查找老师作业下的学生')
            cursor.callproc('Teacher_View_Writes_By_Wno', params)
            result = cursor.fetchall()
            logger_py.info(f"result={result}")
            for row in result:
                params = (row[0],)
                logger_py.info('学生信息')
                cursor.callproc('View_Student', params)
                result = cursor.fetchall()
                logger_py.info(f"result={result}")
                
                params = (row[0],)
                logger_py.info('作业批改情况')
                cursor.callproc('View_Student', params)
                result = cursor.fetchall()
                logger_py.info(f"result={result}")
    except:
        logger_py.info('数据库查询失败')
        connection.rollback()  # 异常时回滚
    
    data= {
        "title": "2023-2024学年第一学期作业汇总",
        "list": [
            {
            "workId": "HW001",
            "userId": "202301001",
            "name": "张三",
            "status": "submitted",
            "score": 85,
            "content": "这是我的第一次作业，主要完成了前两章的基础练习...",
            "teacherComment": "完成得不错，但第三题可以更详细些"
            },
            {
            "workId": "HW001",
            "userId": "202301002", 
            "name": "李四",
            "status": "graded",
            "score": 92,
            "content": "作业已完成，包括所有附加题...",
            "teacherComment": "思路清晰，答案正确，继续保持！"
            },
            {
            "workId": "HW001",
            "userId": "202301003",
            "name": "王五",
            "status": "unsubmitted",
            "score": 0,
            "content": "",
            "teacherComment": "尚未提交"
            },
            {
            "workId": "HW002",
            "userId": "202301001",
            "name": "张三",
            "status": "unsubmitted",
            "score": 0,
            "content": "",
            "teacherComment": "还未提交"
            }
        ]
    }
    ans={
        "code":404,
        "data":data
    }
    return ans
def deal_work (workId,UserId,teacherComment,score):
    ans={
        "msg": "批改成功",
        # "userId": "202301002",
        # "workId": "HW001",
        # "status": "graded",
        # "score": "92",
        # "teacherComment": "思路清晰，答案正确，继续保持！"
    }
    return ans
def dashboard_stats(id,role):
    pass
    # if role=="teacher":
    #     # try:
    #     #     with connection.cursor() as cursor:
    #     #         params = (id)
    #     #         logger_py.info('数据库开始修改用户信息')
    #     #         cursor.callproc('TcntCourse', params)
    #     #         result = cursor.fetchall()
    #     #         logger_py.info(result)
    #     # except:
    #     #     connection.rollback()  # 异常时回滚
    # else:
    #     # try:
    #     #     with connection.cursor() as cursor:
    #     #         params = (id)
    #     #         logger_py.info('数据库开始修改用户信息')
    #     #         cursor.callproc('Teacher_View_Writes_By_Wno', params)
    #     #         result = cursor.fetchall()
    #     #         logger_py.info(result)
    #     # except:
    #     #     connection.rollback()  # 异常时回滚ss
    # pass
if __name__ == '__main__':
    test()


