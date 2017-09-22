//
//  Endpoints.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 22/04/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import Foundation


enum Endpoint: String {
    case Root
    case Prelogin
    
    func buildURL(_ append: String? = nil) -> String {
      let baseURL = EnvironmentService.getValueForKey(key: "kBackendURL")

        if let append = append {
            return "\(baseURL)\(append)"
        } else {
            return "\(baseURL)"
        }
    }
    
    func stringURL() -> String {
      
        switch self {
        case .Root:
            return self.buildURL()
        case .Prelogin:
            return self.buildURL("Views/SocialLoginViewController")
        }
        
    }
}
