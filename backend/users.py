import db
import json
from flask import jsonify, request
import pymysql

def list_users():
    sql_string = "SELECT * FROM users"
    data = '{}'
    data = db.db_query(sql_string, many=True)
    return data

def create_user():
    result = db.check_duplicate('users', 'email', 'dcarrer1@ucsc.edu')
