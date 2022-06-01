import requests
import json


class TestChores:
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

    def test_get_chores(self):
        pass

    def test_get_chores_by_user(self):
        pass

    def test_get_chores_by_house_code(self):
        pass

    def test_get_assignees(self):
        pass

    def test_create_chore(self):
        pass

    def test_edit_chore(self):
        pass

    def test_assign_chore(self):
        pass

    def test_unassign_chore(self):
        pass

    def test_delete_chore(self):
        pass


if __name__ == "__main__":
    print("-" * 35)
    print("Chores API Unit Testing ...\n")
    choreApiTest = TestChores()
    choreApiTest.test_get_chores()
    choreApiTest.test_get_chores_by_user()
    choreApiTest.test_get_chores_by_house_code()
    choreApiTest.test_get_assignees()
    choreApiTest.test_create_chore()
    choreApiTest.test_edit_chore()
    choreApiTest.test_assign_chore()
    choreApiTest.test_unassign_chore()
    choreApiTest.test_delete_chore()
    print("\nFinished Running Tests ...")
    print("-" * 35)
