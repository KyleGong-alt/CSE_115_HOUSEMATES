from flask import jsonify, request
import pymysql
import random
import string
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
    sql_string = "UPDATE users SET"
    sqlOptions = ""
    if first_name:
        sqlOptions += " first_name='{}',".format(first_name)
    if last_name:
        sqlOptions += " last_name='{}',".format(last_name)
    if password:
        sqlOptions += " password='{}',".format(password)
    if mobile_number:
        sqlOptions += " mobile_number='{}',".format(mobile_number)
    if sqlOptions.endswith(','):
        sqlOptions = sqlOptions[:-1]

    sql_string += sqlOptions + " WHERE email='{}'".format(email)

    # update user
    result = db.db_insert(sql_string)
    print(result)

    # validate the insertion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to update user')

    # fetch newly created user
    sql_string = "SELECT * FROM users WHERE email='{}'".format(email)
    data = db.db_query(sql_string)

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='update successful', data=data)

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
def add_chore(name, desc, due_date, house_code, assignees):

    # dup_check = db.count_rows(table='chores', field='name', value=name)
    # if dup_check > 0:
    #     return utils.encode_response(status='failure', code=600, desc='duplicate chore')

    house_check = db.count_rows(table='house_groups', field='house_code', value=house_code)
    if house_check == 0:
        return utils.encode_response(status='failure', code=404, desc='house not found')

    # build sql string
    # insert new chore into the "chores" table
    sql_string = "INSERT INTO chores (name, due_date, house_code, description) VALUES ("\
        "'{}', '{}', '{}', '{}')".format(name, due_date, house_code, desc)
    result = db.db_insert(sql_string)

    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to create chore')

    # query the recent created chore
    sql_string = "SELECT * FROM chores WHERE id = (SELECT MAX(id) FROM chores)"
    result = db.db_query(sql_string)

    chore_id = result['id']

    result1 = True

    # make changes to assignees
    for id in assignees:
        sql_string = "INSERT INTO chores_assignee (user_id, chore_id, house_code) VALUES (" \
                 "'{}', '{}', '{}')".format(id, chore_id, house_code)
        # insert user into chores_assignee table
        result1 = db.db_insert(sql_string)

    # return encoded response
    if (not result1) or (not result):
        return utils.encode_response(status='failure', code=601, desc='unable to create chore')

    date_time = result['due_date'].strftime('%Y-%m-%d %H:%M:%S')
    result['due_date'] = date_time

    return utils.encode_response(status='success', code=200, desc='create chore successful', data=result)

def add_house_rules(title, description, house_code, voted_num, valid):

    # check for duplicate house_rules
    dup_check = db.count_rows(table = 'house_rules', field='title', value=title)
    if dup_check > 0:
        return utils.encode_response(status='failure', code=600, desc='duplicate house rule')

    # check if the house exists in our database
    house_created = db.count_rows(table='house_groups', field='house_code', value=house_code)
    if house_created == 0:
        return utils.encode_response(status='failure', code=404, desc='house not found')

    # format the table by building sql string
    sql_string = """INSERT INTO house_rules (title, description, house_code, voted_num, valid) VALUES ("{}","{}","{}","{}","{}")""".format(title, description, house_code, voted_num, valid)

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
# assignees: optional list of user_id's to assign to the chore
# if assignees: remove all current assignments not in list & assign users that are in the list
#
def edit_chore(chore_id, name, due_date, description, assignees, house_code):

    # check if chore exists before updating
    dup_check = db.count_rows('chores', 'id', chore_id)
    if dup_check < 1:
        return utils.encode_response(status='failure', code=600, desc="chore doesn't exist")

    # build chore update string
    update_string = "UPDATE chores SET name = '{}', due_date = '{}', description = '{}' " \
                    "WHERE id = '{}'".format(name, due_date, description, chore_id)

    # update chore info
    data = db.db_insert(update_string)
    if not data:
        return utils.encode_response(status='failure', code=601, desc='unable to update chore')

    # get current users assigned to chore
    get_assignees_sql = "SELECT user_id FROM chores_assignee WHERE chore_id = '{}'".format(chore_id)
    result = db.db_query(get_assignees_sql, many=True)

    # extract user_id's from sql result
    curr_assignees = [assignee_dict['user_id'] for assignee_dict in result if 'user_id' in assignee_dict]

    # get the user ids that should be unassigned, i.e. users that aren't in the assignees list
    unassign_ids = [user for user in curr_assignees if user not in assignees]

    # get the user ids that need to be assigned & skip users that are already assigned
    assign_ids = [user for user in assignees if user not in curr_assignees]

    # unassign users from chore
    for user_id in unassign_ids:
        result = unassign_chore(user_id, chore_id)
        # return on failed unassignment
        if '"status": "failure"' in result.get_data(as_text=True):
            return result

    # assign users to chore
    for user_id in assign_ids:
        result = assign_chore(user_id, chore_id, house_code)
        # return on failed assignment
        if '"status": "failure"' in result.get_data(as_text=True):
            return result

    # return response
    return utils.encode_response(status='success', code=200, desc='successfully updated chore')

#
# join house given user_id and house_code
#
def join_house(user_id, house_code):
    # check if house_code is valid
    if(db.count_rows("house_groups", "house_code", house_code)) == 0:
        return utils.encode_response(status='failure', code=601, desc='invalid house_code')

    # build sql string
    sql_string = "UPDATE users SET house_code = '{}' WHERE id = '{}'".format(house_code, user_id)

    data = db.db_insert(sql_string)

    # return encoded response
    if not data:
        return utils.encode_response(status='failure', code=601, desc='unable to join house')
    response = utils.encode_response(status='success', code=200, desc='successful join house', data=data)
    return response

#
# leave house given user_id
#
def leave_house(user_id):

    # build sql string
    sql_string = "UPDATE users SET house_code = null WHERE id = '{}'".format(user_id)

    data = db.db_insert(sql_string)

    sql_string = "DELETE FROM chores_assignee WHERE user_id = '{}'".format(user_id)

    data2 = db.db_insert(sql_string)

    # return encoded response
    if (not data) or (not data2):
        return utils.encode_response(status='failure', code=601, desc='unable to leave house')
    response = utils.encode_response(status='success', code=200, desc='successful leave house', data=data)
    return response

#
# given house_code, return members
#
def get_house_members(house_code):
    # build sql string
    sql_string = "SELECT * FROM users WHERE house_code = '{}'".format(house_code)

    # fetch chores from DB
    data = db.db_query(sql_string, many=True)

    #Check if house_code is present
    if not data:
        return utils.encode_response(status='failure', code=404, desc='house_code not found')

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    return response

#
# Generates a random House code
#
def create_house(user_id):

    while (1):
        letters = string.ascii_uppercase
        New_House_Code = (''.join(random.choice(letters) for i in range(8)))
        dup_check = db.count_rows(table='house_groups', field='house_code', value=New_House_Code)
        if dup_check == 0:
            break

    #Updates the user with the user_id to have the new house_code
    sql_string = "UPDATE users SET house_code = '{}' WHERE id = '{}'".format(New_House_Code, user_id)

    #Creates the new house group with the user_id as the new house_admin_id
    sql_string1 = "INSERT INTO house_groups(house_code, house_admin_id) VALUES ('{}', '{}')".format(New_House_Code, user_id)

    # insert new house group
    data1 = db.db_insert(sql_string1)
    # Check if new house_group exists
    if not data1:
        return utils.encode_response(status='failure', code=601, desc='unable to create house')

    # Update user to have new house code from user_id
    data = db.db_insert(sql_string)
    if not data:
        return utils.encode_response(status='failure', code=601, desc='unable to update user to house')

    #Sends back the New house code
    house_code_data = {"house_code":New_House_Code}

    response = utils.encode_response(status='success', code=200, desc='successful query',data=house_code_data)
    return response

#
# assign a user to a chore
#
def assign_chore(user_id, chore_id, house_code):
    # a user can only be assigned to a chore once
    sql_string_check = "SELECT * FROM chores_assignee WHERE chore_id={} AND user_id={}".format(chore_id, user_id)
    dup_check = db.count_rows_custom(sql_string_check)
    if dup_check > 0:
        return utils.encode_response(status='failure', code=600, desc='user already assigned to this chore')

    # build sql string
    sql_string = "INSERT INTO chores_assignee (user_id, chore_id, house_code) VALUES (" \
                 "'{}', '{}', '{}')".format(user_id, chore_id, house_code)

    # insert user into chores_assignee table
    result = db.db_insert(sql_string)

    # validate the insertion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to assign chore to user')

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='chore assignment successful')

#
# unassign a user from a chore
#
def unassign_chore(user_id, chore_id):
    # a user can only be assigned to a chore once
    sql_string_check = "SELECT * FROM chores_assignee WHERE chore_id={} AND user_id={}".format(chore_id, user_id)
    dup_check = db.count_rows_custom(sql_string_check)
    if dup_check < 1:
        return utils.encode_response(status='failure', code=600, desc="user isn't assigned to this chore")

    # build sql string
    sql_string = "DELETE FROM chores_assignee WHERE chore_id={} AND user_id={}".format(chore_id, user_id)

    # delete chores_assignee row
    result = db.db_insert(sql_string)

    # validate deletion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to unassign user from chore')

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='chore unassignment successful')

#
#delete user
#
def delete_chore(user_id):
    sql_string = "DELETE FROM chores WHERE id={}".format(user_id)
    #deletes the chore from
    result = db.db_insert(sql_string)

    # validate deletion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to delete chore')

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='delete chore successful')

#
#delete house rule
#
def delete_house_rule(house_rule_id):
    sql_string = "DELETE FROM house_rules WHERE id={}".format(house_rule_id)
    #deletes the chore from
    result = db.db_insert(sql_string)

    # validate deletion
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to delete house rule')

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='delete house rule successful')

#
# edit a house rule
#
def edit_house_rules(rule_id, title, description):
    # house rule must exist
    dup_check = db.count_rows('house_rules', 'id', rule_id)
    if dup_check < 1:
        return utils.encode_response(status='failure', code=600, desc="house rule doesn't exist")

    # build sql string
    sql_string = "UPDATE house_rules SET title = '{}', description = '{}' WHERE id='{}'".format(title, description, rule_id)

    # update house rule
    result = db.db_insert(sql_string)

    # validate the update
    if not result:
        return utils.encode_response(status='failure', code=601, desc='unable to update house rule')

    # return encoded response
    return utils.encode_response(status='success', code=200, desc='house rule update successful')

#
# Run through all house rules of a given house_code and validate whether they're valid
# return -1 for errors
# return 0 for empty house
# return 1 fo success
#
def validate_rules(house_code):
    # validate approved rules
    sql_string = "SELECT COUNT(*) FROM users WHERE house_code = '{}'".format(house_code)
    sql_string1 = "SELECT id, voted_num FROM house_rules WHERE house_code = '{}'".format(house_code)

    count = db.db_query(sql_string)
    rules = db.db_query(sql_string1, many=True)

    # error while getting number of house members/ house_code doesn't exist
    if not count or not rules:
        return -1

    num_member = count['COUNT(*)']

    # empty house :(
    if num_member <= 0:
        return 0

    # go through each house_rules id and update valid column
    for rule in rules:
        voted_num = rule['voted_num']
        if (voted_num/num_member) >= 0.5:
            sql_string = "UPDATE house_rules SET valid = 1 WHERE id = {}".format(rule['id'])
        else:
            sql_string = "UPDATE house_rules SET valid = 0 WHERE id = {}".format(rule['id'])

        #update the house rule
        result = db.db_insert(sql_string)

        # validate the update
        if not result:
            return -1
    return 1

#
# given house_code, return approved house rules
#
def get_approved_house_rules(house_code):

    # validate_rules(house_code)

    # build sql string
    sql_string = "SELECT id, title, description, voted_num FROM house_rules WHERE house_code = '{}' AND valid = 1".format(house_code)

    # fetch house rules from DB
    data = db.db_query(sql_string, many=True)

    # Check if house rules is present
    if not data:
        return utils.encode_response(status='failure', code=404, desc='no approved rules found')

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    return response

#
# given house_code, return approved house rules
#
def get_not_approved_house_rules(house_code):

    # validate_rules(house_code)

    # build sql string
    sql_string = "SELECT id, title, description, voted_num FROM house_rules WHERE house_code = '{}' AND valid = 0".format(house_code)

    # fetch house rules from DB
    data = db.db_query(sql_string, many=True)

    # Check if house rules is present
    if not data:
        return utils.encode_response(status='failure', code=404, desc='no unapproved rules found')

    # return encoded response
    response = utils.encode_response(status='success', code=200, desc='successful query', data=data)
    return response