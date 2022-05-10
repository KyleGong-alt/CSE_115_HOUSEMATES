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

#
# get single user
#
def get_user(email):
    # build sql string
    sql_string = "SELECT * FROM users WHERE email='{}'".format(email)

    # query the row that has user email
    # since email is unique, return data should only be one row
    result = db.db_query(sql_string)

    # return encoded response
    if not result:
        return None
    return result

def get_user_chores(user_id):
    # build sql string
    sql_string = "SELECT * FROM chores WHERE id IN \
                (SELECT chore_id FROM chores_assignee WHERE \
                (user_id='{}' AND house_code = \
                (SELECT house_code FROM users WHERE id = '{}')))".format(user_id, user_id)

    # sql_string = "SELECT * FROM chores"
    data = '{}'

    # query the chores that associate with user_id
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='', data=data)
    return response

#
# add single chore
#
def add_chore(name, desc, due_date, house_code):
    # email must be unique
    dup_check = db.count_rows(table='chores', field='name', value=name)
    if dup_check > 0:
        return utils.encode_response(status='failure', code=600, desc='duplicate chore')

    house_check = db.count_rows(table='house_groups', field='house_code', value=house_code)
    if house_check == 0:
        return utils.encode_response(status='failure', code=404, desc='house not found')

    # build sql string
    sql_string = "INSERT INTO chores (name, due_date, house_code, description) VALUES ("\
        "'{}', '{}', '{}', '{}')".format(name, due_date, house_code, desc)

    result = db.db_insert(sql_string)

    # return encoded response
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create chore')
    return utils.encode_response(status='success', code=200, desc='create chore successful')


#
# get list of chores by house_code
#
def get_house_chores(house_code):
    # build sql string
    sql_string = "SELECT * FROM chores WHERE house_code = '{}'".format(house_code)

    # fetch chores from DB
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code='200', desc='successful query', data=data)
    # response = jsonify(data)
    return response


#
# get assignees by chore_id
#
def get_assignees(chore_id):
    # build sql string
    sql_string = "SELECT * FROM users WHERE id IN (SELECT user_id FROM chores_assignee WHERE chore_id = {})".format(chore_id)

    # fetch users assigned to chore
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code='200', desc='successful query', data=data)
    return response
