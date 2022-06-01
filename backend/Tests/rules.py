import requests
import json


class TestRules:
    def __init__(self):
        self.root_url = "http://localhost:8080"
        self.route_dict = {"get_house_rules": self.root_url + "/get_house_rules",
                           "create_house_rules": self.root_url + "/create_house_rules",
                           "delete_house_rule": self.root_url + "/delete_house_rule",
                           "get_approved_house_rules": self.root_url + "/get_approved_house_rules",
                           "get_not_approved_house_rules": self.root_url + "/get_not_approved_house_rules",
                           "get_unvoted_house_rules": self.root_url + "/get_unvoted_house_rules"
                           }
        self.json_headers = {'Content-Type': 'application/json'}

    def test_get_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")

    def test_get_approved_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_approved_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")

    def test_get_not_approved_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_not_approved_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")

    def test_get_unvoted_house_rules(self, user_id, house_code):
        params = "?user_id=" + str(user_id) + "&house_code=" + house_code
        url = self.route_dict["get_unvoted_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")



if __name__ == "__main__":
    print("-" * 35)
    print("House Rules API Unit Testing ...\n")
    houseApiTest = TestRules()
    houseApiTest.test_get_house_rules("AKZXCOPQ")
    # houseApiTest.test_get_house_members("AKZXCOPQ")
    # houseApiTest.test_join_house(61, "AKZXCOPQ")
    # houseApiTest.test_leave_house(61)
    houseApiTest.test_get_approved_house_rules("AKZXCOPQ")
    houseApiTest.test_get_not_approved_house_rules("AKZXCOPQ")
    houseApiTest.test_get_unvoted_house_rules(78, "AKZXCOPQ")
    print("\nFinished Running Tests ...")
    print("-" * 35)
