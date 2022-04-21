import json


#
# encode response into JSON
# status = 'success' OR 'failure'
#
def encode_response(status='success', code='', desc='', data=None):
    # build response dict
    response = {'status': status, 'code': code, 'description': desc, 'data': data}
    # convert response to JSON
    response_json = json.dumps(response)
    return response_json
