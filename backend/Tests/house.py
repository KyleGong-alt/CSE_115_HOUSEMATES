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
        payload = json.dumps({"user_id": str(user_id)})
        url = self.route_dict["create_house"]
        response = requests.request("POST", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert(response_data["description"] == "successful query")
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
    houseApiTest = TestHouse()
    houseApiTest.test_create_house(1)
    houseApiTest.test_get_house_members("DBSGALUC")
    houseApiTest.test_join_house(61, "DBSGALUC")
    houseApiTest.test_leave_house(61)
    print("\nFinished Running Tests ...")
    print("-" * 35)

