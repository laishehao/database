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
    # host='0.0.0.0' 允许所有IP访问
    # port=5000 指定端口（可选）