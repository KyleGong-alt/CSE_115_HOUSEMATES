from flask import jsonify, request
import pymysql

import db
import utils


#
# list all users in users table
#
def list_users():
    sql_string = "SELECT * FROM users"
    data = '{}'

    # fetch ALL users
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='', data=data)
    return response


#
# create user in users table
#
def create_user(email, first_name, last_name, password, mobile_number):
    # email must be unique
    dup_check = db.count_rows(table='users', field='email', value=email)
    if dup_check > 0:
        return utils.encode_response(status='failure', code=600, desc='duplicate user')

    # build sql string
    sql_string = "INSERT INTO users (email, first_name, last_name, password, mobile_number) VALUES ('{}', '{}', '{}', " \
                 "'{}', '{}')".format(email, first_name, last_name, password, mobile_number)
    # insert user into users table
    result = db.db_insert(sql_string)

    # return encoded response
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create new user')
    return utils.encode_response(status='success', code=200, desc='signup successful')
