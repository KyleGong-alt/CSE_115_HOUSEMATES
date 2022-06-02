import requests
import json
import string
import random


class TestRules:

    # holds generated title names during testing.
    random_names = dict()

    # Created rule_id
    rule_id = None

    def __init__(self):
        self.root_url = "http://localhost:8080"
        self.route_dict = {"get_house_rules": self.root_url + "/get_house_rules",
                           "create_house_rules": self.root_url + "/create_house_rules",
                           "delete_house_rule": self.root_url + "/delete_house_rule",
                           "get_approved_house_rules": self.root_url + "/get_approved_house_rules",
                           "get_not_approved_house_rules": self.root_url + "/get_not_approved_house_rules",
                           "get_unvoted_house_rules": self.root_url + "/get_unvoted_house_rules",
                           "update_house_rule_voted_num": self.root_url + "/update_house_rule_voted_num"
                           }
        self.json_headers = {'Content-Type': 'application/json'}

    def test_get_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        self.rule_id = response_data["data"][-1]["id"]
        # print(response_data["data"][-1])

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")

    def test_create_house_rules(self, house_code):
        # generate random name for signup to avoid duplicate title
        letters = string.ascii_lowercase
        random_name = ''.join(random.choice(letters) for _ in range(10))
        # generate a new name if it already exists
        while random_name in self.random_names:
            random_name = ''.join(random.choice(letters) for _ in range(10))
        # track the new name
        self.random_names[random_name] = 'seen'

        payload = json.dumps({"title": "Randomized Test " + random_name,
                                "description":"Clean the dishes",
                                "house_code": house_code,
                                "voted_num":"0",
                                "valid": "0"})
        url = self.route_dict["create_house_rules"]
        response = requests.request("POST", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert(response_data["status"] == "success")
        print("/create_house_rules ... success")

    def test_delete_house_rule(self):
        payload = json.dumps({"house_rule_id": str(self.rule_id)})
        url = self.route_dict["delete_house_rule"]
        response = requests.request("DELETE", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert(response_data["status"] == "success")
        print("/delete_house_rule ... success")

    def test_get_approved_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_approved_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_approved_house_rules ... success")

    def test_get_not_approved_house_rules(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_not_approved_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_not_approved_house_rules ... success")

    def test_get_unvoted_house_rules(self, user_id, house_code):
        params = "?user_id=" + str(user_id) + "&house_code=" + house_code
        url = self.route_dict["get_unvoted_house_rules"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_house_rules ... success")

    def test_votes(self, user_id = 56, house_code = 'AKZXCOPQ', update_value = -1):
        sql_getRule = "SELECT id FROM house_rules WHERE title = 'Dont Delete Me'"

        house_rule_json = json.dumps({"title": 'Dont Delete Me',
                                      "description": 'test',
                                      "house_code": 'DBSGALUC',
                                      "voted_num": "0",
                                      "valid": "0"
                                      })
        postUrl = self.route_dict["create_house_rules"]
        postResponse = requests.request("POST", postUrl, headers=self.json_headers, data=house_rule_json)


        getUrl = self.route_dict["get_house_rules"]+"?house_code=DBSGALUC"
        getResponse = requests.request("GET", getUrl)
        response_data = json.loads(getResponse.text)
        id_for_house_rule = response_data['data'][0]['id'];


        update_vote_data = json.dumps({"user_id": 79,
                                      "rule_id": id_for_house_rule,
                                      "update_value": 1
                                      })
        voteUrl = self.route_dict["update_house_rule_voted_num"]
        requests.request("PUT", voteUrl,headers=self.json_headers, data = update_vote_data)
        voteResponse = requests.request("PUT", voteUrl, headers=self.json_headers, data = update_vote_data)

        vote_response_data = json.loads(voteResponse.text)
        assert (vote_response_data["description"] == "User has already voted")
        print("/update_house_rule_voted_num ... success")





if __name__ == "__main__":
    print("-" * 35)
    print("House Rules API Unit Testing ...\n")
    houseApiTest = TestRules()
    houseApiTest.test_create_house_rules("AKZXCOPQ")
    houseApiTest.test_get_house_rules("AKZXCOPQ")
    houseApiTest.test_delete_house_rule()
    houseApiTest.test_get_approved_house_rules("AKZXCOPQ")
    houseApiTest.test_get_not_approved_house_rules("AKZXCOPQ")
    houseApiTest.test_get_unvoted_house_rules(78, "AKZXCOPQ")
    houseApiTest.test_votes()
    print("\nFinished Running Tests ...")
    print("-" * 35)
