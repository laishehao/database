import pymysql
from flask import jsonify

# 创建连接
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='123456',
    database='laizhehao',
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
            sql = "SELECT * FROM humans "
            cursor.execute(sql)  # 注意参数必须是元组，单个参数也要加逗号
            result = cursor.fetchall()
            print(result)
            # for res in result:
            #     print(res[2])
    except:
        connection.rollback()  # 异常时回滚
        raise
    finally:
        connection.close()
    return result
def register(username, password, name, email):
    pass
def login(username, password):
    pass
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

def add_student (id, name, age, gender):
    pass
def update_student():
    pass
def delete_student():
    pass
def select_course():
    
    pass
def add_course():
    pass
def update_course():
    pass
def delete_course():
    pass
def select_work():
    pass
def add_work():
    pass
def update_work():
    pass
def delete_work():
    pass

if __name__ == '__main__':
    select_student(1,2,3)