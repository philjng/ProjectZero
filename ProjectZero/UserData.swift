//
//  UserData.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import Foundation

struct UserData {
    
    private let userDataKey = "userData"
    
    var name: String = ""
    var hostname: String = ""
    
    var hasDataFilled: Bool {
        return !name.isEmpty
    }
    
    public init(){
        
        if let dictionary = UserDefaults.standard.dictionary(forKey: userDataKey) {
            
            name = dictionary["name"] as? String ?? ""
            hostname = dictionary["name"] as? String ?? ""

        }
    }
    
    public func save() {
        
        var dictionary : Dictionary = Dictionary<String, Any>()
        dictionary["name"] = name
        dictionary["hostname"] = hostname
        UserDefaults.standard.set(dictionary, forKey: userDataKey)
        print("the user's name : ",name,"is successfully saved!")
    }
    
}
