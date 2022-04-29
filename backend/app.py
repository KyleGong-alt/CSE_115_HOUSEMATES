from turtle import title
from unicodedata import name
from flask import Flask, request
from werkzeug.exceptions import HTTPException
from datetime import datetime
import os

import users
import utils

app = Flask(__name__)

# -------------- Sample route template -------------------------------------------------------------------------- #
# #
# # description
# #
# @app.route('/--route--', methods=['--method--'])
# def --function--():
#     # get form-data fields
#     email = request.form.get('email')

#     # validate form-data for null values
#     if '' in [email]:
#         return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty email)')

#     # perform request
#     response = users.get_user(email=email)

#     # return appropriate response
#     if not response:
#         return utils.encode_response(status='failure', code=602, desc='cannot find user')
#     return response
# -------------------------------------------------------------------------------------------------------------- #

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
# account login
#
@app.route('/login', methods=['POST'])
def login():
    # get form-data fields
    email = request.form.get('email')
    password = request.form.get('password')

    # validate form-data for null values
    if '' in [email]:
        return utils.encode_response(status='failure', code=602, desc='invalid login form-data')

    # perform login
    response = users.get_user(email=email)
    if not response:
        return utils.encode_response(status='failure', code=602, desc='email or password is wrong')

    # check password
    print(response)
    if(password != response['password']):
        return utils.encode_response(status='failure', code=602, desc='email or password is wrong')
    return utils.encode_response(status='success', code=200, desc='login successful')

#
# get single user info
#
@app.route('/get_user', methods=['GET'])
def get_user():
    # get form-data fields
    email = request.form.get('email')
    print(email)

    # validate form-data for null values
    if '' in [email]:
        return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty email)')

    # perform get user info
    response = users.get_user(email=email)
    if not response:
        return utils.encode_response(status='failure', code=404, desc='user not found')

    # return user data
    # print(response)
    return response

#
# add a chore
# due_date should be of type string -- "May 1 2022 10:00AM"

@app.route('/create_chore', methods=['POST'])
def create_chore():
    # get form-data fields
    name = request.form.get('name')
    desc = request.form.get('desc')
    due_date = request.form.get('due_date')
    house_code = request.form.get('house_code')

    # validate form-data for null values
    if '' in [house_code]:
        return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty housecode)')

    # perform request
    datetime_object = datetime.strptime(due_date, '%b %d %Y %I:%M%p')
    response = users.add_chore(name=name, desc=desc, due_date=datetime_object, house_code=house_code)

    # return appropriate response
    return response

@app.route('/create_house_rules', methods=['GET'])
def create_house_rules():

    #get form-data files
    title = request.form.get('title')
    description = request.form.get('description')
    house_code = request.form.get('house_code')
    voted_num = request.form.get('voted_num')

    # validate that title-data has no null values
    if '' in [title]:
        return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty house rule)')

     # validate that vote-data has no null values
    if '' in [voted_num]:
        return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty voters)')

    # validate that housecode-data has no null values
    if '' in [house_code]:
        return utils.encode_response(status='failure', code=602, desc='invalid user form-data (empty housecode)')
    
    # get all the form-data value and check if its present
    response = users.add_house_rules(title=title, description=description, house_code=house_code, voted_num=voted_num)
    if not response:
        return utils.encode_response(status='failure', code=404, desc='house_rules not found')

    #return the form-data value
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

