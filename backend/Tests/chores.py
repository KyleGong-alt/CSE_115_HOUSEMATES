import requests
import json


class TestChores:
  def __init__(self):
    self.root_url = "http://localhost:8080"
    self.route_dict = {"get_chores": self.root_url + "/get_chores?",
                       "get_chores_by_user": self.root_url + "/get_chores_by_user?",
                       "get_chores_by_house_code": self.root_url + "/get_chores_by_house_code?",
                       "get_assignees": self.root_url + "/get_assignees?",
                       "create_chore": self.root_url + "/create_chore",
                       "edit_chore": self.root_url + "/edit_chore",
                       "assign_chore": self.root_url + "/assign_chore",
                       "unassign_chore": self.root_url + "/unassign_chore",
                       "delete_chore": self.root_url + "/delete_chore"
                       }
    self.json_headers = {'Content-Type': 'application/json'}

  def test_get_chores(self, user_id):
    payload = json.dumps({"user_id": str(user_id)})
    url = self.route_dict["create_house"]
    response = requests.request("POST", url, headers=self.json_headers, data=payload)
    # print(response.text)

    response_data = json.loads(response.text)
    # print(response_data)

    assert (response_data["description"] == "successful query")
    print("/create_house ... success")

  def test_get_house_members(self, house_code):
    params = "house_code=" + house_code
    url = self.route_dict["get_house_members"] + params
    response = requests.request("GET", url)
    # print(response.text)

    response_data = json.loads(response.text)
    # print(response_data)

    assert (response_data["description"] == "successful query")
    print("/get_house_members ... success")

  def test_join_house(self, user_id, house_code):
    payload = json.dumps({
      "user_id": str(user_id),
      "house_code": house_code
    })
    url = self.route_dict["join_house"]
    response = requests.request("POST", url, headers=self.json_headers, data=payload)
    # print(response.text)

    response_data = json.loads(response.text)
    # print(response_data)

    assert (response_data["description"] == "successful join house")
    print("/join_house ... success")

  def test_leave_house(self, user_id):
    payload = json.dumps({
      "user_id": str(user_id),
    })
    url = self.route_dict["leave_house"]
    response = requests.request("POST", url, headers=self.json_headers, data=payload)
    # print(response.text)

    response_data = json.loads(response.text)
    # print(response_data)

    assert (response_data["description"] == "successful leave house")
    print("/leave_house ... success")


if __name__ == "__main__":
  print("-" * 35)
  print("House API Unit Testing ...\n")
  # houseApiTest = TestHouse()
  # houseApiTest.test_create_house(75)
  # houseApiTest.test_get_house_members("AKZXCOPQ")
  # houseApiTest.test_join_house(61, "AKZXCOPQ")
  # houseApiTest.test_leave_house(61)
  print("\nFinished Running Tests ...")
  print("-" * 35)


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





