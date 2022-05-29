import json
import unittest
import string
import random

import app as housemates_app
import db
import utils

# INSTRUCTIONS:
#   test a specific function: python users_test.py -v UsersTest.function_name
#   verbose mode (runs all functions): python users_test.py -v
#   normal (silent, runs all functions) mode: python users_test.py

# BUGS FOUND IN APIS:
#   /update_user:
#       validation issue -> doesn't check if email exists before performing update?


class UsersTest(unittest.TestCase):

    # holds generated random names during testing. Helps to avoid duplicate random names
    random_names = dict()

    # setup testing object
    def setUp(self):
        housemates_app.app.testing = True
        self.app = housemates_app.app.test_client()

    # test the default route '/'
    def test_default(self):
        result = self.app.get('/')
        self.assertEqual("Hello from the Housemates Flask API!", result.data.decode('utf-8'))

    # performs /list_users, and verifies that the users were fetched correctly
    def test_list_users(self):

        # perform '/list_users' request
        actual_response = self.app.get('/list_users')

        # extract data from json response
        actual_data = json.loads(actual_response.data)['data']

        # generate expected response from database
        sql_string = "SELECT * FROM users "
        with housemates_app.app.app_context():
            expected_data = db.db_query(sql_string, many=True)

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)

    def test_profilePic(self):
        pass

    # performs /update_user, and verifies that the user was successfully updated
    def test_update_user(self):

        # test update data
        update_dict = dict(email='test@ucsc.edu',
                           first_name='Daniel',
                           last_name='Carrera',
                           password='password',
                           mobile_number='6908934789')

        # send test put request
        actual_response = self.app.put('/update_user',
                                       data=json.dumps(update_dict),
                                       content_type='application/json')

        # try extracting actual data
        actual_data = json.loads(actual_response.data)['data']

        # fetch updated user from database
        sql_string = "SELECT * FROM users WHERE email='{}'".format(update_dict['email'])
        with housemates_app.app.app_context():
            expected_data = db.db_query(sql_string)

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)

    # performs /signup, and verifies that the user was inserted into the db
    def test_signup(self):

        # generate random name for signup to avoid duplicate signups
        letters = string.ascii_lowercase
        random_name = ''.join(random.choice(letters) for _ in range(10))
        # generate a new name if it already exists
        while random_name in self.random_names:
            random_name = ''.join(random.choice(letters) for _ in range(10))
        # track the new name
        self.random_names[random_name] = 'seen'

        # create signup dict
        signup_dict = dict(email=random_name + '@ucsc.edu',
                           first_name=random_name,
                           last_name=random_name,
                           password='password',
                           mobile_number='1234567890')

        # send test post request
        actual_response = self.app.post('/signup',
                                        data=json.dumps(signup_dict),
                                        content_type='application/json')

        # get data from json response
        actual_data = json.loads(actual_response.data)['data']

        # fetch new user from database
        sql_string = "SELECT * FROM users WHERE email='{}'".format(signup_dict['email'])
        with housemates_app.app.app_context():
            expected_data = db.db_query(sql_string)

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)

    # performs /login, and verifies that the user logged in successfully
    def test_login(self):

        # create login dict
        login_dict = dict(email='test1@ucsc.edu',
                          password='password')

        # send test post request
        actual_response = self.app.post('/login',
                                        data=json.dumps(login_dict),
                                        content_type='application/json')

        # extract data from json response
        actual_data = json.loads(actual_response.data)['data']

        # fetch new user from database
        sql_string = "SELECT * FROM users WHERE email='{}'".format(login_dict['email'])
        with housemates_app.app.app_context():
            expected_data = db.db_query(sql_string)

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)

    # performs /get_user and verifies that the correct user was fetched
    def test_get_user(self):

        # perform '/get_user' request
        params_dict = dict(email='test@ucsc.edu')
        actual_response = self.app.get('/get_user?email=' + params_dict['email'])

        # extract data from json response
        actual_data = json.loads(actual_response.data)['data']

        # generate expected response from database
        sql_string = "SELECT * FROM users WHERE email='{}'".format(params_dict['email'])
        with housemates_app.app.app_context():
            expected_data = db.db_query(sql_string)

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)


if __name__ == '__main__':
    unittest.main()
