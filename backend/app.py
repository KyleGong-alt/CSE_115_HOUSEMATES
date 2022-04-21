from flask import Flask, request
from werkzeug.exceptions import HTTPException
import os

import users
import utils

app = Flask(__name__)

#
# default route
#
@app.route('/')
def hello():
    return 'Hello from the Housemates Flask API!'


#
# list all users in db
#
@app.route('/list_users', methods=['GET', 'POST'])
def get_users():
    response = users.list_users()
    return response


#
# account signup
#
@app.route('/signup', methods=['POST'])
def signup():
    # get form-data fields
    email = request.form.get('email')
    first_name = request.form.get('first_name')
    last_name = request.form.get('last_name')
    password = request.form.get('password')
    mobile_number = request.form.get('mobile_number')

    # validate form-data for null values
    if '' in [email, first_name, last_name, password, mobile_number]:
        return utils.encode_response(status='failure', code=602, desc='invalid signup form-data')

    # perform signup
    response = users.create_user(email=email, first_name=first_name, last_name=last_name, password=password,
                                 mobile_number=mobile_number)
    return response


#
# Handle HTTP and application errors
#
@app.errorhandler(Exception)
def handle_exception(e):
    print(e)

    # pass through HTTP errors
    if isinstance(e, HTTPException):
        return e

    # now you're handling non-HTTP exceptions only
    exception_str = str(e)
    response = utils.encode_response(status='failure', code=500, desc=exception_str)
    return response


#
# app.py entry point
#
if __name__ == "__main__":
    # run app on localhost:8080
    app.run(host='127.0.0.1', port=8080, debug=True)

