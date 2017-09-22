//
//  Screen.swift
//  FirebaseWeekend
//
//  Created by BJSS on 25/05/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit
import Firebase

class FirebaseObject: NSObject {

  let key: String!
  var nodeID: NSInteger!
  var type: NSInteger!

  init(snapshot: FIRDataSnapshot) {
    key = snapshot.key
    type = snapshot.value!["type"]
    nodeID = snapshot.value!["id"]
  }

  func toAnyObject() -> AnyObject {
    return [
      "id": nodeID,
      "type": self.type
    ]
  }

  func stringValue(data: String?) -> String {
    return data != nil ? data! : ""
  }
}
