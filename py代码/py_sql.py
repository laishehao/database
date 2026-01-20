import pymysql
import logging
# from flask import jsonify
from my_app import logger_py
import json
from pathlib import Path
import datetime
from flask import abort,jsonify
json_path = Path("E:/code/clone/data.json")

 # 读取JSON文件
with open(json_path, 'r', encoding='utf-8') as f:
    config = json.load(f)
    
ip = config.get('ip',{})

# 创建连接
connection = pymysql.connect(
    host=ip,
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
        "email":email,
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
                msg=result[0][0]
                
                if "ERROR" in msg:
                    logger_py.info('有问题')
                    ans={
                        "msg":msg,
                        "code":404
                    }
                    return ans
                user["id"]=result[0][1]
        except:
            logger_py.info('储存失败')
            abort(500)
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
                msg=result[0][0]
                if "ERROR" in msg:
                    ans={
                        "msg":msg,
                        "code":404
                    }
                    return ans
                user["id"]=result[0][1]
        except:
            logger_py.info('储存失败')
            abort(500)
            connection.rollback()  # 异常时回滚
    logger_py.info(f'user={ans["user"]}')
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
    gendre="male" if result[5]=="男" else "female"
    user={
        "username":result[1],
        "name":result[2],
        "role":role,
        "id":result[1],
        "phone":phone,
        "email":result[4],
        "gender":gendre,
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    # 创建登录响应对象
    ans={
        "msg":"登录成功",
        "user" :user
    }
    return ans
def userinfo(id,phone, name, email,role,gender,password,major):
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                params = (id,name,email,phone,gender,password)
                logger_py.info(f'params={params}')
                logger_py.info('数据库开始修改教师信息')
                cursor.callproc('Edit_Teacher', params)
                result = cursor.fetchall()
                if"ERROR" in result[0][0]:
                    ans={
                        "msg":"修改成功",
                        "code":404,
                        "user" :user
                    }
                logger_py.info(result)
        except:
            logger_py.info('修改失败')
            connection.rollback()  # 异常时回滚
    else:
        try:
            with connection.cursor() as cursor:
                params = (id,name,email,phone,gender,major,password)
                logger_py.info('数据库开始修改用户信息')
                cursor.callproc('Edit_Student', params)
                result = cursor.fetchall()
                logger_py.info(result)
        except:
            logger_py.info('修改失败')
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
    if gender=="男":
        gender="male"
    else:
        gender="female"
    user={
        "email":email,
        "name":name,
        "role":role,
        "phone":phone,
        "id":id,
        "gender":gender,
        "major":major,
        "password":password,
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
    students=[]
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                params = (id,)
                logger_py.info('数据库开始恩家课程查询学生')
                cursor.callproc('View_Course_Student', params)
                result = cursor.fetchall()
                logger_py.info(result)
                for row in result:
                    logger_py.info(row)
                    st={
                        "studentId": row[0],
                        "name": row[1],
                        "gender": row[3],
                        "major": row[4],
                        "phone":  row[5],
                        "avatar":
                             row[6]
                    }
                    students.append(st)
        except:
            logger_py.info('查询失败')
            connection.rollback()  # 异常时回滚
        
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
    students=[student]+students
    
    list=students
    total=list.__len__()
    ans={
        "total":total,
        "list":list
    }
    return ans

def add_student (studentId, name, major, gender,phone,cno,sno):
    try:
        with connection.cursor() as cursor:
            params = (cno,sno)
            logger_py.info('数据库开始添加学生')
            cursor.callproc('Select_Course', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        logger_py.info('添加失败')
        connection.rollback()  # 异常时回滚
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
            logger_py.info('数据库老师查询课程')
            cursor.callproc('Teacher_View_Course_List', params)
            result = cursor.fetchall()
            logger_py.info(result)
            
            params = (Tno,)
            logger_py.info('数据库查询老师信息')
            cursor.callproc('View_Teacher', params)
            tc = cursor.fetchall()
            logger_py.info(tc)
            
            
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
                    "teacher": tc[0][2],  # 原始数据中不包含，设为空字符串
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
    try:
        with connection.cursor() as cursor:
            params = (CourseName,major,credits,type,teacher)
            logger_py.info('数据库添加课程')
            cursor.callproc('Create_Course', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        logger_py.info('添加失败')
        connection.rollback()  # 异常时回滚
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
    try:
        with connection.cursor() as cursor:
            params = (courseId,)
            logger_py.info('数据库删除课程')
            cursor.callproc('Delete_Course', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        logger_py.info('删除失败')
        connection.rollback()  # 异常时回滚
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
    
def select_work(query,page,pageSize,role,id):
    homwork={
            'workId':'1000000',
            'title':'test',
            'course':'test',
            'content':'test',
            'active':True,
            'progress':50,
            'completed':True
        }
    homworks=[]
    homworks.append(homwork)
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
                for row in result:
                    # params = (row[2],)
                    # logger_py.info('查询课程信息')
                    # cursor.callproc('View_Course', params)
                    # corse = cursor.fetchall()
                    # logger_py.info(corse)
                    homework = {
                        'workId': row[0],
                        'title': row[1],
                        'course': row[7],  # 根据实际情况调整
                        'content': row[3],
                        'starttime': row[4].isoformat() if row[4] else None,
                        'overtime': row[5].isoformat() if row[5] else None,
                        'active': True,  # 根据业务逻辑判断
                        "progress":row[6]
                    }
                    homworks.append(homework)
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
                for item in result:
                    homework = {
                        'workId': item[0],
                        'title': item[1],
                        'course': f'课程{item[2]}',  # 根据实际情况调整
                        'content': item[3],
                        'startDate': item[4].isoformat() if item[4] else None,
                        'endDate': item[5].isoformat() if item[5] else None,
                        'active': True,  # 根据业务逻辑判断
                        'progress': 9 ,
                        'completed': 1 if item[8] is not None else 0  # 假设第7位是完成状态
                    }
                    homworks.append(homework)
        except:
            connection.rollback()  # 异常时回滚

    
    total=homworks.__len__()
    # for item in result:
    #     homework = {
    #         'workId': item[0],
    #         'title': item[1],
    #         'course': f'课程{item[2]}',  # 根据实际情况调整
    #         'content': item[3],
    #         'startDate': item[4].isoformat() if item[4] else None,
    #         'endDate': item[5].isoformat() if item[5] else None,
    #         'active': True,  # 根据业务逻辑判断
    #         'progress': item[7] ,
    #         'completed': 1 if item[8] is not None else 0  # 假设第7位是完成状态
    #     }
    #     homworks.append(homework)
    ans={
        "code":400,
        "total":total,
        "msg":"shit",
        "list":homworks
    }
    return ans
def add_work(title,course,content,progress,UserId,start,over):
    try:
        with connection.cursor() as cursor:
            params = (title,course,UserId,start,over,content)
            logger_py.info('数据库添加作业')
            cursor.callproc('Push_homework', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        connection.rollback()  # 异常时回滚
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
def submit_work(role,studentId,workId,content):
    try:
        with connection.cursor() as cursor:
            params = (workId,studentId,content)
            logger_py.info('学生提交作业')
            cursor.callproc('Submit_Answer', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
        connection.rollback()  # 异常时回滚
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
            "score":None,
            # "comment":"评语",
            "teacherComment":None,
            "completed":False
            }
    try:
        with connection.cursor() as cursor:
            params = (UserId,workId)
            logger_py.info('学生做作业界面-写了什么')
            cursor.callproc('View_homework', params)
            write = cursor.fetchall()
            wt=write[0]
            logger_py.info(f"wt={wt}")
            
            params = (workId,)
            logger_py.info('学生做作业界面-作业是什么')
            cursor.callproc('View_work', params)
            work = cursor.fetchall()
            wk=work[0]
            logger_py.info(f"wk={wk}")
            dt=wk[6].strftime('%Y-%m-%d %H:%M:%S')
            # print(dt)
            params = (int(wk[3]),)
            logger_py.info('学生做作业界面-课程是什么')
            cursor.callproc('View_Course', params)
            course = cursor.fetchall()
            cs=course[0]
            logger_py.info(f"cs={cs}")
            # formatted_date = wt[6].strftime('%Y-%m-%d %H:%M')
            logger_py.info(f"formatted_date={dt}")
            detail={
                "workId": workId,
                "title": wk[2],# 作业名字
                "course": cs[2],# 课程名字
                "content": wk[4],# 作业具体内容
                "starttime": wk[5].strftime('%Y-%m-%d %H:%M:%S'),
                "overtime": dt,# 截止时间
                "context":wt[1],# 作答
                "score":wt[2],# 分数
                "comment":wt[3],
                "teacherComment":wt[4],# 老师评语
                "completed":True if wt[2] is not None else False   # 是否有评语
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
    test={
            "workId": "HW002",
            "userId": "202301001",
            "name": "张三",
            "status": "unsubmitted",
            "score": 0,
            "content": "",
            "teacherComment": "还未提交"
            }
    list=[]
    list.append(test)
    try:
        st=""
        with connection.cursor() as cursor:
            params = (workId,)
            logger_py.info('数据库开始查找老师作业下的学生')
            cursor.callproc('Teacher_View_Writes_By_Wno', params)
            result = cursor.fetchall()
            logger_py.info(f"result={result}")
            for row in result:
                params = (row[0],)
                logger_py.info('学生信息')
                cursor.callproc('View_Student', params)
                st = cursor.fetchall()
                logger_py.info(f"st={st}")
                
                params = (row[0],row[1])
                logger_py.info('作业批改情况')
                cursor.callproc('View_homework', params)
                wt = cursor.fetchall()
                logger_py.info(f"wt={wt}")
                status="unsubmitted"
                if wt[0][1] is not None:
                    status="submitted"
                if wt[0][2] is not None:
                    status="graded"
                    
                tvs={
                    "workId": row[1],
                    "userId": row[0],
                    "name": st[0][2],
                    "status":status,
                    "score": wt[0][2] ,
                    "content": wt[0][1],
                    "teacherComment": wt[0][4]
                }
                list.append(tvs)
    except:
        logger_py.info('数据库查询失败')
        connection.rollback()  # 异常时回滚
    
    
    data= {
        "title": "2023-2024学年第一学期作业汇总",
        "list": list
    }
    ans={
        "code":404,
        "data":data
    }
    return ans
def deal_work (workId,UserId,teacherComment,score):
    try:
        with connection.cursor() as cursor:
            params = (workId,UserId,score,teacherComment)
            logger_py.info('数据库老师批改')
            cursor.callproc('Marking', params)
            result = cursor.fetchall()
            logger_py.info(result)
    except:
            logger_py.info('数据库查询失败')
            connection.rollback()  # 异常时回滚
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
    # pass
    ans=""
    if role=="teacher":
        try:
            with connection.cursor() as cursor:
                
                #  ----
                params = (id,)
                logger_py.info('老师管学生数量')
                cursor.callproc('TcntStudent', params)
                teac = cursor.fetchall()
                logger_py.info(teac)
                s=teac[0][2]
                
                params = (id,)
                logger_py.info('老师授课数量')
                cursor.callproc('TcntCourse', params)
                teac = cursor.fetchall()
                logger_py.info(teac)
                a=teac[0][2]
                
                params = (id,)
                logger_py.info('老师进行的作业数量')
                cursor.callproc('TcntWriting', params)
                result = cursor.fetchall()
                b=result[0][2]
                logger_py.info(result)
                
                params = (id,)
                logger_py.info('老师待改的作业数量')
                cursor.callproc('TcntCorrect', params)
                result = cursor.fetchall()
                c=result[0][2]
                logger_py.info(result)
                
                ans={
                    "code":200,
                    "stats":{
                        "studentCount": s,
                        "courseCount": a,
                        "ongoingHomework": b,
                        "pendingGrade": c
                    }
                }
        except:
            logger_py.info('数据库查询失败')
            connection.rollback()  # 异常时回滚
    else:
        try:
            with connection.cursor() as cursor:
                params = (id,)
                logger_py.info('学生选课数量')
                cursor.callproc('ScntCourse', params)
                Scors = cursor.fetchall()
                a=Scors[0][2]
                logger_py.info(a)
                
                params = (id,)
                logger_py.info('学生为截止作业量')
                cursor.callproc('ScntWriting', params)
                ncmp = cursor.fetchall()
                b=ncmp[0][2]
                logger_py.info(b)
                # stats={
                #     "courseCount": a,
                #     "ongoingHomework": b
                # }
                ans={
                    "code":200,
                    "stats":{
                        "courseCount": a,
                        "ongoingHomework": b
                    }
                }
                
        except:
            connection.rollback()  # 异常时回滚ss
    return ans
    # pass
if __name__ == '__main__':
    test()


