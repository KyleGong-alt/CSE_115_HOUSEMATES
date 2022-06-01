//
//  ServerExtension.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import Foundation

struct chore: Codable {
    let id: Int
    let name: String
    let due_date: String
    let house_code: String
    let description: String?
}

struct user: Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let house_code: String?
    let mobile_number: String
    let email: String
    let password: String
}

struct rule: Codable {
    let id: Int
    let title: String
    let description: String
    let voted_num: Int
    let valid: Int
    let voted_no: Int
    let voted_yes: Int
}

struct ruleResponse: Codable {
    let status: String
    let code: Int
    let description: String
    let data: [rule]?
}


struct choreResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [chore]?
}

struct userResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: user?
}

struct multiUserResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [user]?
}

struct postResponse: Codable{
    let status: String
    let code: Int
    let description: String
}

struct chorePostResponse: Codable {
    let status: String
    let code: Int
    let description: String
    let data: chore
}


var currentUser: user?
//var choreList = [chore]()
//var choreAssigneesList = [[user]]()
//var unassignedChoreList = [chore]()
//var assignedchoreList = [chore]()
//var approvedRuleList = [rule]()
//var unapprovedRuleList = [rule]()
var memberList = [user]()

func getHouseMembers() {
    var components = URLComponents(string: "http://127.0.0.1:8080/get_house_members")!
    components.queryItems = [
        URLQueryItem(name: "house_code", value: currentUser?.house_code)
    ]
    components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    
    var request = URLRequest(url: components.url!)

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "GET"
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        var result:multiUserResponse
        do {
            result = try JSONDecoder().decode(multiUserResponse.self, from: data!)
            
            if result.code != 200 {
                return
            }
            
            memberList = result.data ?? []
            
        } catch {
            print(error.localizedDescription)
        }
    }
    dataTask.resume()
}
