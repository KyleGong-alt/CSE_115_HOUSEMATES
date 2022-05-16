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

    # validate the insertion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create new user')

    # fetch newly created user
    sql_string = "SELECT * FROM users WHERE email='{}'".format(email)
    data = db.db_query(sql_string)

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='signup successful', data=data)


#
# update user in users table
#
def update_user(email, first_name, last_name, password, mobile_number):

    # build sql string
    sqlString = "UPDATE users SET "
    sqlOptions = ""
    if first_name:
        sqlOptions += "first_name " + first_name+","
    if last_name:
        sqlOptions += "last_name " + last_name+","
    if password:
        sqlOptions += "password " + password+","
    if mobile_number:
        sqlOptions += "mobile_number " + mobile_number+","
    if sqlOptions.endswith(','):
        sqlOptions = sqlOptions[:-1]

    sqlString += sqlOption + "WHERE email={}".format(email)

    # insert user into users table
    result = db.db_query(sql_string)
    print(sql_string)

    # validate the insertion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create new user')

    # fetch newly created user
    sql_string = "SELECT * FROM users WHERE email='{}'".format(email)
    data = db.db_query(sql_string)

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='signup successful', data=data)

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

#
# get list of chores by house_code
#
def get_house_chores(house_code):
    # build sql string
    sql_string = "SELECT * FROM chores WHERE house_code = '{}'".format(house_code)

    # fetch chores from DB
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    # response = jsonify(data)
    return response

#
# get list of house rules by house_code
#
def get_house_rules(house_code):
    # build sql string
    sql_string = "SELECT * FROM house_rules WHERE house_code = '{}'".format(house_code)

    # fetch chores from DB
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
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
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    return response

#
# get chores
#
def get_chores(house_code):
    # build sql string
    # get users assigned to chores from given house_code
    # get all chores from given house_code, combine the results
    sql_string = "SELECT c.id, c.name, c.due_date, c.house_code, c.description, a.user_id, u.email, u.first_name, u.last_name " \
                 "FROM chores_assignee a " \
                 "JOIN chores c on a.chore_id = c.id " \
                 "JOIN users u on a.user_id = u.id " \
                 "WHERE a.house_code = '{}' " \
                 "UNION " \
                 "SELECT c.id, c.name, c.due_date, c.house_code, c.description, Null as user_id ,Null as email, Null as first_name, Null as last_name " \
                 "FROM chores as c " \
                 "WHERE c.house_code = '{}' AND c.id NOT IN(SELECT chore_id FROM chores_assignee)" \
                 "".format(house_code, house_code)
    # fetch chores and assignees
    data = db.db_query(sql_string, many=True)

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    return response

#
# edit chore
#
def edit_chore(chore_id, name, due_date, description):
    # build sql string
    sql_string = "UPDATE chores SET name = '{}', due_date = '{}', description = '{}' " \
                 "WHERE id = '{}'".format(name, due_date, description, chore_id)

    # update chore info
    data = db.db_insert(sql_string)
    if not data:
        return utils.encode_response(status='failure', code=601, desc='unable to update chore')
    return utils.encode_response(status='success', code=200, desc='successfully updated chore')
