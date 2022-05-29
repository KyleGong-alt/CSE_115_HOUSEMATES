import requests
import json
import unittest

import app as housemates_app
import db
import utils

# BUGS:
    # update_user doesn't check if email exists before performing update


class UsersTest(unittest.TestCase):

    # setup testing object
    def setUp(self):
        housemates_app.app.testing = True
        self.app = housemates_app.app.test_client()

    # test the default route '/'
    def test_default(self):
        result = self.app.get('/')
        self.assertEqual("Hello from the Housemates Flask API!", result.data.decode('utf-8'))

    # test the '/list_users' route
    def test_list_users(self):

        actual_response = self.app.get('/list_users')

        # generate expected response from database
        sql_string = "SELECT * FROM users "
        with housemates_app.app.app_context():
            data = db.db_query(sql_string, many=True)
            expected_response = utils.encode_response(status='success', code=200, desc='', data=data)

        # print("ACTUAL: ", actual_response.data.decode('utf-8'))
        # print("EXPECTED: ", expected_response.data.decode('utf-8'))

        self.assertEqual(expected_response.data, actual_response.data)

    def test_profilePic(self):
        pass

    def test_update_user(self):

        # this function performs /update_user, and verifies that the user was successfully updated

        # test update data
        update_dict = dict(email='test@ucsc.edu',
                           first_name='Daniel',
                           last_name='Carrera',
                           password='password',
                           mobile_number='6908934789')

        # convert data to json
        encoded_update_dict = json.dumps(update_dict)

        # send test put request
        actual_response = self.app.put('/update_user',
                                       data=encoded_update_dict,
                                       content_type='application/json')

        # fetch updated user from database
        sql_string = "SELECT * FROM users WHERE email='{}'".format(update_dict['email'])
        with housemates_app.app.app_context():
            data = db.db_query(sql_string)
            expected_response = utils.encode_response(status='success', code=200, desc='', data=data)

        # extract actual and expected data
        expected_data = json.loads(expected_response.data)['data']
        actual_data = json.loads(actual_response.data)['data']

        # print("ACTUAL RESPONSE: ", actual_response.data.decode('utf-8'))
        # print("EXPECTED RESPONSE: ", expected_response.data.decode('utf-8'))

        # print("ACTUAL DATA: ", actual_data)
        # print("EXPECTED DATA: ", expected_data)

        self.assertEqual(expected_data, actual_data)


if __name__ == '__main__':
    unittest.main()
