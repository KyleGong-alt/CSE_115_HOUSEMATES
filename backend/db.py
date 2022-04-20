import os
import pymysql
from flask import jsonify

db_user = os.environ.get("DB_USERNAME")
db_password = os.environ.get("DB_PASSWORD")
db_host = os.environ.get("DB_IP")
db_name = os.environ.get("DB_NAME")


print(db_user)
print(db_password)
print(db_host)
print(db_name)


# create a db connection
def db_open_connection():
    try:
        print(db_user, db_password, db_host, db_name)
        connection = pymysql.connect(user=db_user, password=db_password, host=db_host, db=db_name, cursorclass=pymysql.cursors.DictCursor)
        return connection
    except pymysql.MySQLError as e:
        print("db_open_connection: ", e)
    return False


# fetch query
def db_query(sql_string, many=False):
    conn = db_open_connection()
    data = False
    with conn.cursor() as cursor:
        cursor.execute(sql_string)
        if not many:
            data = cursor.fetchone()
        else:
            data = cursor.fetchall()
        data = jsonify(data)
    conn.close()
    return data


# insert query
def db_insert(sql_string):
    conn = db_open_connection()
    with conn.cursor() as cursor:
        cursor.execute(sql_string)
        conn.commit()
        conn.close()
        return True
    conn.close()
    return False

def check_duplicate(table, field, value):
    sql_string = f"SELECT EXSISTS(SELECT * FROM {table} WHERE {field}='{value}')"
    print(sql_string)
    result = db_query(sql_string)
    if result == False:
        return False
    print("result", result)
    
