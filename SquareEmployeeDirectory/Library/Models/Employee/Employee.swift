//
//  Employee.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import Foundation


struct Employee: Hashable, Identifiable, Codable {
     
    var id: String
    var fullName: String
    var phoneNumber: String?
    var emailAddress: String
    var biography: String?
    var photoURLSmall: String?
    var photoURLLarge: String?
    var team: String
    var type: String // TODO
    
    
    var photoURL: URL? {
        guard let rawImageLink = photoURLLarge ?? photoURLSmall else {
            return nil
        }
        
        return URL(string: rawImageLink)
    }
    
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography = "biography"
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case team = "team"
        case type = "employee_type"
    }
    
//    "uuid" : "some-uuid",
//    "full_name" : "Eric Rogers",
//    "phone_number" : "5556669870",
//    "email_address" : "erogers.demo@squareup.com",
//    "biography" : "A short biography describing the employee.",
//    "photo_url_small" : "https://some.url/path1.jpg",
//    "photo_url_large" : "https://some.url/path2.jpg",
//    "team" : "Seller",
//    "employee_type" : "FULL_TIME",
}
