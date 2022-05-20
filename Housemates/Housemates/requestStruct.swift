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

struct choreResponse: Codable{
    let status: String
    let code: Int
    let description: String
    let data: [chore]?
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
