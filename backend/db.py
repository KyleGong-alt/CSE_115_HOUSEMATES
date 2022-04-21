from flask import jsonify
import os
import pymysql


# db credentials
db_user = os.environ.get("DB_USERNAME")
db_password = os.environ.get("DB_PASSWORD")
db_host = os.environ.get("DB_IP")
db_name = os.environ.get("DB_NAME")

print(db_user, db_password, db_host, db_name)


#
# create a db connection
# returns connection object on success
# Exception on error
#
def db_open_connection():
    try:
        connection = pymysql.connect(user=db_user, password=db_password, host=db_host, db=db_name,
                                     cursorclass=pymysql.cursors.DictCursor)
        return connection
    except pymysql.MySQLError as e:
        print("db_open_connection: ", e)


#
# fetch db query
# many = True: fetch all values
# many = False: fetch a single value
# returns list of dictionaries
#
def db_query(sql_string, many=False):
    conn = db_open_connection()
    data = [{}]
    with conn.cursor() as cursor:
        cursor.execute(sql_string)
        if not many:
            data = cursor.fetchone()
        else:
            data = cursor.fetchall()
    conn.close()
    return data


#
# insert query
# returns True on success
# returns False on failure
#
def db_insert(sql_string):
    conn = db_open_connection()
    with conn.cursor() as cursor:
        cursor.execute(sql_string)
        conn.commit()
        conn.close()
        return True
    conn.close()
    return False


#
# check if field exists in table
# returns > 0 if exists
# returns 0 if doesn't exist
#
def count_rows(table, field, value):
    conn = db_open_connection()
    num_rows = 0
    sql_string = "SELECT * FROM {} WHERE {}='{}'".format(table, field, value)
    with conn.cursor() as cursor:
        cursor.execute(sql_string)
        num_rows = cursor.rowcount
    conn.close()
    return num_rows
