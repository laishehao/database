import pymysql

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
def select_humans():
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
if __name__ == '__main__':
    select_humans()