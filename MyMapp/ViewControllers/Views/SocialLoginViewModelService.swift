//
//  SocialLoginViewModelService.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 25/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import Foundation

class SocialLoginViewModelService: BaseService<SocialLoginViewModel> {
  
  init() {
    let endpoint = Endpoint.Prelogin
    super.init(endpoint: endpoint)
  }
}
