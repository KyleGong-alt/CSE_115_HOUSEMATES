from flask import jsonify
import json
import os

#
# encode response into JSON
# status = 'success' OR 'failure'
#
def encode_response(status='success', code='', desc='', data=None):
    # build response dict
    response = {'status': status, 'code': code, 'description': desc, 'data': data}
    # convert response to JSON
    # response_json = json.dumps(response)
    response_json = jsonify(response)
    return response_json


#
# validate JSON request
# checks that the fields match and that the values exist
#
# on error: returns tuple (False, error description)
# on success: returns tuple (True, empty description)
#
def validate_json_request(correct_fields, request):
    # initialize return values
    desc = ""
    result = False

    # content-type must be json
    content_type = request.headers.get('Content-Type')
    if content_type != 'application/json':
        return result, "content-type not supported"

    # decode JSON into python dictionary
    data = request.get_json()

    # check if JSON object is valid
    if data is None or not isinstance(data, dict):
        return result, "invalid JSON object"

    # extract data fields and data values into lists
    data_fields = list(data.keys())
    data_values = list(data.values())

    # check if data fields match required fields
    if len(data_fields) != len(correct_fields) or sorted(correct_fields) != sorted(data_fields):
        return result, "invalid JSON fields"

    # check if data values exist
    elif '' in data_values or None in data_values:
        return result, "invalid JSON values"

    result = True
    return result, desc


def delete_dir_contents(dir):
    for file_name in os.listdir(dir):
        # construct full file path
        file = os.path.join(dir,file_name)
        if os.path.isfile(file):
            print('Deleting file:', file)
            os.remove(file)