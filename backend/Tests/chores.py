import requests
import json

url = "http://localhost:8080/create_chore"

url = "http://localhost:8080/get_chores?"

url = "http://localhost:8080/get_chores_by_user?user_id=1"

url = "http://localhost:8080/get_chores_by_house_code"

url = "http://localhost:8080/edit_chore"

url = "http://localhost:8080/assign_chore"

url = "http://localhost:8080/unassign_chore"

url = "http://localhost:8080/get_assignees?chore_id=29"

url = "http://localhost:8080/delete_chore"


payload = json.dumps({
  "name": "New Test Create Chore",
  "desc": "Just testing",
  "due_date": "2022-05-31 00:08:48",
  "house_code": "AKZXCOPQ",
  "assignees": [
    1,
    2,
    3,
    4
  ]
})
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
