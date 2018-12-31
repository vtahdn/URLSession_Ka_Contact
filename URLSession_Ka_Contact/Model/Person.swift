//
//  Person.swift
//  URLSession_Ka_Contact
//
//  Created by Viet Asc on 12/31/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import Foundation

// Profile Object

class Person {
    
    var id: String?
    var name: String?
    var phone: Int?
    var email: String?
    var city: String?
    var image: String?
    
    init(infomation: [String: AnyObject?]) {
        
        let id = infomation["id"] as? String
        self.id = id
        let name = infomation["name"] as? String
        self.name = name
        let phone = infomation["phone"] as? Int
        self.phone = phone
        let email = infomation["email"] as? String
        self.email = email
        let city = infomation["city"] as? String
        self.city = city
        let image = infomation["image"] as? String
        self.image = image
        
    }
    
}
