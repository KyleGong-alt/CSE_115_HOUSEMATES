import requests
import json


class TestHouse:
    def __init__(self):
        self.root_url = "http://localhost:8080"
        self.route_dict = {"create_house": self.root_url + "/create_house",
                           "get_house_members": self.root_url + "/get_house_members?",
                           "join_house": self.root_url + "/join_house",
                           "leave_house": self.root_url + "/leave_house"}
        self.json_headers = {'Content-Type': 'application/json'}

    def test_create_house(self, user_id):
        create_house_payload = json.dumps({
            "user_id": str(user_id)
        })
        url = self.route_dict["create_house"]
        response = requests.request("POST", url, headers=self.json_headers, data=create_house_payload)
        print(response.text)


houseApiTest = TestHouse()

houseApiTest.test_create_house(75)
