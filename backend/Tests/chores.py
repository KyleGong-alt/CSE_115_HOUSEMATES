import requests
import json


class TestChores:

    # Holds Chores_id to be deleted
    rule_id = None

    def __init__(self):
        self.root_url = "http://localhost:8080"
        self.route_dict = {"get_chores": self.root_url + "/get_chores",
                           "get_chores_by_user": self.root_url + "/get_chores_by_user",
                           "get_chores_by_house_code": self.root_url + "/get_chores_by_house_code",
                           "get_assignees": self.root_url + "/get_assignees",
                           "create_chore": self.root_url + "/create_chore",
                           "edit_chore": self.root_url + "/edit_chore",
                           "assign_chore": self.root_url + "/assign_chore",
                           "unassign_chore": self.root_url + "/unassign_chore",
                           "delete_chore": self.root_url + "/delete_chore"
                           }
        self.json_headers = {'Content-Type': 'application/json'}

    def test_get_chores(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_chores"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_chores ... success")

    def test_get_chores_by_user(self, user_id):
        params = "?user_id=" + str(user_id)
        url = self.route_dict["get_chores_by_user"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "")
        print("/get_chores_by_user ... success")

    def test_get_chores_by_house_code(self, house_code):
        params = "?house_code=" + house_code
        url = self.route_dict["get_chores_by_house_code"] + params
        response = requests.request("GET", url)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_chores_by_house_code ... success")

    def test_get_assignees(self, chore_id):
        params = "?chore_id=" + str(chore_id)
        url = self.route_dict["get_assignees"] + params
        response = requests.request("GET", url)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successful query")
        print("/get_assignees ... success")

    def test_create_chore(self, name, desc, due_date, house_code, assignees):
        payload = json.dumps({
            "name": name,
            "desc": desc,
            "due_date": due_date,
            "house_code": house_code,
            "assignees": assignees
        })
        url = self.route_dict["create_chore"]
        response = requests.request("POST", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)
        self.rule_id = response_data["data"]["id"]
        # print(response_data["data"][-1])

        assert (response_data["description"] == "create chore successful")
        print("/create_chore ... success")

    def test_edit_chore(self, name, desc, due_date, house_code, assignees):
        payload = json.dumps({
            "chore_id": str(self.rule_id),
            "name": name,
            "due_date": due_date,
            "description": desc,
            "house_code": house_code,
            "assignees": assignees
        })
        url = self.route_dict["edit_chore"]
        response = requests.request("PUT", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "successfully updated chore")
        print("/edit_chore ... success")

    def test_assign_chore(self, user_id, house_code):
        payload = json.dumps({
            "user_id": user_id,
            "chore_id": str(self.rule_id),
            "house_code": house_code
        })
        url = self.route_dict["assign_chore"]
        response = requests.request("POST", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "chore assignment successful")
        print("/assign_chore ... success")

    def test_unassign_chore(self, user_id):
        payload = json.dumps({
            "user_id": user_id,
            "chore_id": str(self.rule_id)
        })
        url = self.route_dict["unassign_chore"]
        response = requests.request("PUT", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert (response_data["description"] == "chore unassignment successful")
        print("/unassign_chore ... success")

    def test_delete_chore(self):
        payload = json.dumps({"chore_id": str(self.rule_id)})
        url = self.route_dict["delete_chore"]
        response = requests.request("DELETE", url, headers=self.json_headers, data=payload)
        # print(response.text)

        response_data = json.loads(response.text)
        # print(response_data)

        assert(response_data["status"] == "success")
        print("/delete_chore ... success")


if __name__ == "__main__":
    print("-" * 35)
    print("Chores API Unit Testing ...\n")
    choreApiTest = TestChores()
    choreApiTest.test_create_chore("Unit Testing", "Unit Testing", "2022-05-31 10:00:00", "DBSGALUC", [81, 82])
    choreApiTest.test_get_chores("DBSGALUC")
    choreApiTest.test_get_chores_by_user(1)
    choreApiTest.test_get_chores_by_house_code("DBSGALUC")
    choreApiTest.test_get_assignees(75)
    choreApiTest.test_edit_chore("Unit Testing!", "Unit Testing chores", "2022-06-20 11:00:00", "DBSGALUC", [80, 79])
    choreApiTest.test_assign_chore(81, "DBSGALUC")
    choreApiTest.test_unassign_chore(81)
    choreApiTest.test_delete_chore()
    print("\nFinished Running Tests ...")
    print("-" * 35)
