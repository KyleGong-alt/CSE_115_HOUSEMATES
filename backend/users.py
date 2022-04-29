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

def add_house_rules(title, description, house_code, voted_num):
    
    # check for duplicate house_rules
    dup_check = db.count_rows(table = 'house_rules', field='title', value=title)
    if dup_check > 0:
        return utils.encode_response(status='failure', code=600, desc='duplicate house rule')
    
    # check if the house exists in our database
    house_created = db.count_rows(table='house_groups', field='house_code', value=house_code)
    if house_created == 0:
        return utils.encode_response(status='failure', code=404, desc='house not found')
    
    # format the table by building sql string
    sql_string = "INSERT INTO house_rules (title, description, house_code, voted_num) VALUES ('{}','{}','{}','{}')".format(title, description, house_code, voted_num)
    
    #save the formated string 
    result = db.db_insert(sql_string)

    # return encoded response 
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create the house rule')
    return utils.encode_response(status='success', code=200, desc='house chore scucessfully created')