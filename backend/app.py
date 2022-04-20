from flask import Flask
import os
import users

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/list_users', methods=['GET', 'POST'])
def get_users():
    return users.list_users()

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    users.create_user()
    return 'signup testing'

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8080, debug=True)

