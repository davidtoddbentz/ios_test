/*
* Copyright 2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import Foundation
import AWSCore


@objc class Constants: NSObject {
    
    // MARK: Required: Amazon Cognito Configuration
    
    static let CognitoRegionType = AWSRegionType.USEast1
    
    //TODO: It should be environement based
    static let CognitoIdentityPoolID = "us-east-1:aaf79079-eeb9-424b-b76c-e418c9b9d6ad"
  
    // MARK: Required: Amazon Cognito User Pool
  
    static let CognitoIdentityUserPoolId = "us-east-1_b03LCiyMe"
    static let CognitoIdentityUserPoolAppClientId = "20av3pfpkb3acbk38i5didsilk"
    static let CognitoIdentityUserPoolAppClientSecret = "1ki3fkokf0h2toig5h354194apqb4mk7mdgj3dh6a7h8jk72jrjj"
  
    // MARK : Required: Amazon S3
  
//    static let S3BucketName = EnvironmentService.getValueForKey("kS3BucketName")
//  
//    // MARK : Required Amazon SNS
    static let SNSPlatformApplicationArn = "kSNSPlatformApplicationArn"
    static let SNSPlatformTopic = "kSNSPlatformTopic"
  
    // MARK: Optional: Enable Facebook Login
    
    /**
    * OPTIONAL: Enable FB Login
    *
    * To enable FB Login
    * 1. Add FacebookAppID in App plist file
    * 2. Add the appropriate URL handler in project (should match FacebookAppID)
    */
    
    // MARK: Optional: Enable Google Login
    
    /**
    * OPTIONAL: Enable Google Login
    *
    * To enable Google Login
    * 1. Add the client ID generated in the Google console below
    * 2. Add the appropriate URL handler in project (Should be the same as BUNDLE_ID)
    */
    
    static let GoogleClientID = "ENTER_CLIENT_ID"
    
    // MARK: Optional: Enable Amazon Login
    
    // MARK: Optional: Enable Twitter/Digits Login
    
    /**
    * OPTIONAL: Enable Twitter/Digits Login
    *
    * To enable Twitter Login
    * 1. Add your API keys and Consumer secret
    *    If using Fabric, the Fabric App will walk you through this
    */
    
    // MARK: Optional: Enable Developer Authentication
    
    /**
    * OPTIONAL: Enable Developer Authentication Login
    *
    * This sample uses the Java-based Cognito Authentication backend
    * To enable Dev Auth Login
    * 1. Set the values for the constants below to match the running instance
    *    of the example developer authentication backend
    */
  
    //KeyChain Constants
    static let BYOIProvider = "BYOI"
  
    // This is the default value, if you modified your backend configuration
    // update this value as appropriate
    static let DeveloperAuthAppName = "awscognitodeveloperauthenticationsample"
    // Update this value to reflect where your backend is deployed
    // !!!!!!!!!!!!!!!!!!!
    // Make sure to enable HTTPS for your end point before deploying your
    // app to production.
    // !!!!!!!!!!!!!!!!!!!
    //static let DeveloperAuthEndPoint = EnvironmentService.getValueForKey("kDeveloperAuthEndPoint")
    // Set to the provider name you configured in the Cognito console.
    //static let DeveloperAuthProviderName = EnvironmentService.getValueForKey("kDeveloperAuthProviderName")
    
    /*******************************************
    * DO NOT CHANGE THE VALUES BELOW HERE
    */
    
    static let DeviceTokenKey = "DeviceToken"
    static let CognitoDeviceTokenKey = "CognitoDeviceToken"
    static let CognitoPushNotif = "CognitoPushNotification"
    static let GoogleClientScope = "https://www.googleapis.com/auth/userinfo.profile"
    static let GoogleOIDCScope = "openid"
    
}
