//
//  ServerExtension.swift
//  Housemates
//
//  Created by Jackson Tran on 4/29/22.
//

import Foundation

struct test: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [users]?
}

struct users: Codable {
    let id: Int
    let email:  String
    let first_name: String
    let last_name: String
    let password: String
    let mobile_number: String
    let house_code: String?
}

func temp(){
    let url = URL(string: "http://127.0.0.1:8080/list_users")!
    
    var request = URLRequest(url: url)
    
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpMethod = "GET"
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        var result:test
        do {
            result = try JSONDecoder().decode(test.self, from: data!)
            print(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    dataTask.resume()
}
