//
//  DropEventService.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 27/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth


protocol DropEventServiceDelegate {
    func didFinishUploadingPhoto()
    func didFailUploadingPhoto()
    func updateProgressPercentage(_ progressPercentage: Float)
}

class DropEventService: NSObject {
    
    var key: String! = nil
    var photoName: String
    var photo: UIImage! = nil
    var policy: String! = nil
    var signature: String! = nil
    let AWSAccessKeyID = "AKIAITRUF2GSRBWIZ4MQ"
    var etag: String! = nil
    var delegate: DropEventServiceDelegate!
    var progress:(Float) -> Void = { prog in
        print(prog)
    }
    
    init(photoName: String, progress: @escaping (_ percent: Float) -> Void) {
        self.photoName = photoName
        self.progress = progress
        super.init()
    }
    
    func sendPOSTsignatureRequestForPhotoNamed() {
        generateKey()
        
        let headers = ["Content-Type":"application/json"]
        let body = [
            "conditions": [
                ["acl": "public-read"],
                ["bucket": "dropeventphotos"],
                ["Content-Type": "image/png"],
                ["success_action_status": "200"],
                ["key": key],
                ["x-amz-meta-qqfilename": photoName]
            ],
            "expiration": "2016-06-23T18:00:45.783Z"
        ] as [String : Any]
        
        Alamofire.request("https://dropevent.com/s3/signature", method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: headers).validate()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = response.result.value
                    if let policy = (json as! [String: AnyObject])["policy"] {
                        self.policy = policy as! String
                    }
                    if let signature = (json as! [String: AnyObject])["signature"] {
                        self.signature = signature as! String
                    }
                    print("policy: \(self.policy)")
                    print("signature: \(self.signature)")
                    self.sendPOSTImageRequest()
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    self.delegate?.didFailUploadingPhoto()
                }
        }
    }
    
    func sendPOSTImageRequest() {
        
        // let headers = ["Content-Type":"multipart/form-data; boundary=__X_PAW_BOUNDARY__"]
        
        let data = UIImageJPEGRepresentation(photo, 1.0)!
        //    let stringFile = String(data: data, encoding: NSUTF8StringEncoding)
        //    data = stringFile!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        Alamofire.upload(
                         multipartFormData: { multipartFormData in
                            multipartFormData.append(self.key.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"key")
                            multipartFormData.append("AKIAITRUF2GSRBWIZ4MQ".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"AWSAccessKeyid")
                            multipartFormData.append("image/png".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"Content-Type")
                            multipartFormData.append("200".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"success_action_status")
                            multipartFormData.append("public-read".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"acl")
                            multipartFormData.append(self.photoName.data(using: String.Encoding.utf8,  allowLossyConversion: false)!, withName :"x-amz-meta-qqfilename")
                            multipartFormData.append(self.policy.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"policy")
                            multipartFormData.append(self.signature.data(using: String.Encoding.utf8,  allowLossyConversion: false)!, withName :"signature")
                            multipartFormData.append(data, withName :"file", fileName: self.photoName, mimeType: "image/png")
        },
                         to: "https://dropeventphotos.s3.amazonaws.com/",
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    DispatchQueue.main.async {
                                        let totalBytesWritten = progress.completedUnitCount
                                        let totalBytesExpectedToWrite = progress.totalUnitCount
                                        let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                                        self.progress(percent)
                                        self.delegate?.updateProgressPercentage(percent)
                                        
                                    }
                                })
                                print("upload: \(upload)")
                                upload.responseJSON { response in
                                    if let etag = upload.response!.allHeaderFields["Etag"] {
                                        self.etag = etag as! String
                                        self.postSuccessRequest()
                                    }
                                }
                            case .failure(let encodingError):
                                debugPrint(encodingError)
                                self.delegate?.didFailUploadingPhoto()
                            }
        })
    }
    
    func postSuccessRequest() {
        
        let headers = [
            "Cookie":"connect.sid=s%3Alcr0jTDirao7fhmWLlTy8xNG.qm1WFvtjNHoDSg87KWyA0%2BAsYzTRhKp%2FxBFfknIVi6c; GEAR=local-555c1d514382ec0b85000169",
            "Content-Type":"application/x-www-form-urlencoded",
            ]
        let keyWithoutExtension = key.substring(to: key.range(of: ".", options: .backwards, range: nil)!.lowerBound)
        
        let parameters = [
            "email": "test@gmail.com",
            "key": self.key,
            "uuid": keyWithoutExtension,
            "name": self.photoName,
            "bucket": "dropeventphotos",
            "etag": self.etag
        ]
        
        let url = "https://dropevent.com/s3/\(EnvironmentService.getValueForKey(key: "kDropEventKey"))/success"
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
        //Alamofire.request(, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    self.delegate?.didFinishUploadingPhoto()
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                    self.delegate?.didFailUploadingPhoto()
                }
        }
    }
    
    func generateKey() {
        key = "\(NSUUID.init().uuidString).png"
        //  let photoURL = NSURL(string: photoName)!
        //  key = key.stringByAppendingString(".\(photoURL.pathExtension!)")
    }
    
}
