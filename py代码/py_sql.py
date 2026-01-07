import pymysql
import logging
# from flask import jsonify


# 创建连接
connection = pymysql.connect(
    host='127.0.0.1',
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
    

def register(role,name, password, phone, email):
    user={
        "id":0,
        "username":"testuser_datacheck",
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
    return ans
def login(phone, password):
    # 创建用户信息对象
    user={
        "username":"testuser_datacheck",
        "name":"testname",
        "role":"teacher",
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    # 创建登录响应对象
    ans={
        "msg":"登录成功",
        "user" :user
    }
    return ans
def userinfo(phone, name, email):
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
def select_student(query, page, page_size):
    
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
    students.append(student)
    
    list=students
    total=list.__len__()
    ans={
        "total":total,
        "list":list
    }
    return ans

def add_student (studentId, name, major, gender,phone):
    ans={
        "code":200,
        "msg":"添加成功"
    }
    return ans
def update_student(studentId, name, major, gender,phone):
    ans={
        "code":200,
        "msg":"更新成功"
    }
    return ans
def delete_student(studentId):
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
def select_course(query,page,pageSize):
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
        ]
    }
    return ans
def add_course(courseId,CourseName,major,credits,type,teacher):
    ans={
        "code":200,
        "msg":"添加成功"
    }
    return ans

def update_course(courseId,CourseName,major,credits,type,teacher):
    ans={
        "code":200,
        "msg":"更新成功"
    }
    return ans
def delete_course(courseId):
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
    
def select_work(query,page,pageSize):
    homwork={
            'workId':'1',
            'title':'test',
            'course':'test',
            'content':'test',
            'active':True,
            'progerss':50,
            'completed':False
        }
    homworks=[]
    homworks.append(homwork)
    total=homworks.__len__()
    ans={
        # "code":400,
        "total":total,
        "list":homworks
    }
    return ans
def add_work(title,course,content,progress):
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
    ans={
        "code":200,
        "msg":"删除成功"
    }
    return ans
def submit_work(role,studentId,workId,writecheck):
    ans={
        "code":200,
        "msg":"提交成功"
    }
    return ans
def watch_work(workId,UserId):
    ans={
        "code":200,
        "msg":"查看成功"
    }
    return ans
def check_work(workId):
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
        "userId": "202301002",
        "workId": "HW001",
        "status": "graded",
        "score": "92",
        "teacherComment": "思路清晰，答案正确，继续保持！"
    }
    return ans
if __name__ == '__main__':
    test()


