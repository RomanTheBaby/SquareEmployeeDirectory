//
//  Employee.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import Foundation


struct Employee: Hashable, Identifiable, Codable, Equatable {
    
    var id: String
    var fullName: String
    var phoneNumber: String?
    var emailAddress: String
    var biography: String?
    var photoURLSmall: URL?
    var photoURLLarge: URL?
    var team: String
    var type: EmployeeType
    
    
    // MARK: - Type
    
    enum EmployeeType: String, Hashable, Equatable, Codable {
        case fullTime = "FULL_TIME"
        case partTime = "PART_TIME"
        case contractor = "CONTRACTOR"
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
    
}
    
extension Employee {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.phoneNumber = try? container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.emailAddress = try container.decode(String.self, forKey: .emailAddress)
        self.biography = try container.decodeIfPresent(String.self, forKey: .biography)
        
        if let rawPhotoURLSmall = try? container.decodeIfPresent(String.self, forKey: .photoURLSmall) {
            self.photoURLSmall = URL(string: rawPhotoURLSmall)
        }
        
        if let rawPhotoURLLarge = try? container.decodeIfPresent(String.self, forKey: .photoURLLarge) {
            self.photoURLLarge = URL(string: rawPhotoURLLarge)
        }
        
        self.team = try container.decode(String.self, forKey: .team)
        
        let rawType = try container.decode(String.self, forKey: .type)
        
        if let type = EmployeeType(rawValue: rawType) {
            self.type = type
        } else {
            throw NSError(code: 502, localizedDescription: "Not supported employee type: \(rawType)")
        }
    }
    
}
