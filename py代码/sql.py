import pymysql

# from flask import jsonify


# 创建连接
connection = pymysql.connect(
    host='8.130.144.155',
    user='testuser',
    password='12345678',
    database='619database',
    port=3306,
    charset='utf8'
    # cursorclass=pymysql.cursors.DictCursor
)

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
            
            sql = "select * from tmp; "
            # sql = "desc student;"
            cursor.execute(sql)  # 注意参数必须是元组，单个参数也要加逗号
            result = cursor.fetchall()
            print(result[1][0])
            print(type(result[1][0]))
            print(result)
            # for res in result:
            #     print(res[2])
    except:
        connection.rollback()  # 异常时回滚
        raise
    finally:
        connection.close()
    return result
    pass

def register(username, password, name, email):
    user={
        "username":"testuser_datacheck",
        "name":"testname",
        "role":"teacher",
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    ans={
        "msg":"注册成功",
        "user" :user
    }
    return ans
def login(username, password):
    user={
        "username":"testuser_datacheck",
        "name":"testname",
        "role":"teacher",
        "avatar":"https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
    }
    ans={
        "msg":"注册成功",
        "user" :user
    }
    return ans
def select_student(query, page, page_size):
    students=[]
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
    # ans={
    #     "role_chech":role_check,
    #     "data":students
    # }
    # test
    # print(students)
    return students

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
        # "list":[{"id":1},{"id":2}] #格式未知
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
    ans={
        "total":10,
        # "list":[{"id":1},{"id":2}] #格式未知
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

if __name__ == '__main__':
    test()


