//
//  BaseService.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 03/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol JSONConstruable {
  init?(json: JSON)
}

enum BaseServiceResult<T:JSONConstruable> {
  case success(T)
  case error(NSError)
}

class BaseService<T:JSONConstruable> {
  
  var endpoint: Endpoint
  var parameters: [String: AnyObject]?
  
  init(endpoint: Endpoint) {
    self.endpoint = endpoint
  }
  
  func load(_ completion: @escaping (_ result: BaseServiceResult<T>) -> Void) -> Void {
    
    
//    Alamofire
//      
//      
//      .request(
//      .GET,
//      self.endpoint.stringURL(),
//      parameters: parameters,
//      encoding: .URL)
//      .validate()
//      .responseJSON { (response) -> Void in
//        
//        switch response.result {
//        case .Failure(let error):
//          let result = BaseServiceResult<T>.Error(error)
//          completion(result: result)
//        case .Success(let data):
//          let jsonData = JSON(data)
//          if let object = T(json: jsonData) {
//            let result = BaseServiceResult.Success(object)
//            completion(result: result)
//          } else {
//            let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("JSON", value: "Invalid JSON", comment: "")]
//            let error = NSError(domain: "BaseService", code: 1000, userInfo: userInfo)
//            let result = BaseServiceResult<T>.Error(error)
//            completion(result: result)
//          }
//        }
//    }
  }
}
