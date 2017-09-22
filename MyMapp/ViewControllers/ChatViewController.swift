///*
// The MIT License (MIT)
// 
// Copyright (c) 2015-present Badoo Trading Limited.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// */
//
//import UIKit
//import Firebase
//import NMessenger
//import ApiAI
//import AsyncDisplayKit
//
//class DemoChatViewController: NMessengerViewController {
//    
//    var interstitialPresented = false
//    
//    var messages: [TextContentNode]? = []
//    var apiai: ApiAI {
//        get {
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            return (appDelegate?.apiai)!
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadMessages()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//    }
//    
//    
//    func loadMessages() {
//        FireBaseSynchroniser.sharedSynchroniser.chatHistory { (messages) in
//            if let m = messages {
//                self.messages = m
//                let start = m.count > 10 ? m.count - 10 : 0
//                let end = m.count
//                for message in (self.messages?[start...end-1])! {
//                    let messageText = message.textMessageNode.attributedString?.string ?? ""
//                    let messageIncoming = message.isIncomingMessage
//                    var msg = super.sendText(messageText, isIncomingMessage: messageIncoming)
//                    self.decorateMessage(msg)
//                }
//            }
//        }
//    }
//    
//    func decorateMessage(_ msg: GeneralMessengerCell) {
//        if msg is MessageNode {
//            let msgNode = msg as! MessageNode
//            let avatar = ASImageNode()
//            avatar.image = #imageLiteral(resourceName: "davidbeckham").scaledToFit(CGSize(width: 40, height: 40))
//            avatar.setNeedsDisplayWithCompletion({ (completed) in
//                avatar.cornerRadius = 10.0
//            })
//            msgNode.avatarNode = avatar
//            msgNode.avatarNode?.layer.cornerRadius = 10.0
//            msgNode.layer.cornerRadius = 10.0
//            msgNode.avatarInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//            
//        }
//    }
//    
//    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
//        FireBaseSynchroniser.sharedSynchroniser.send(text, isIncoming: isIncomingMessage)
//        let request = apiai.textRequest()
//        request?.query = [text]
//        request?.requestContexts = [AIRequestContext.init(name: "userNameSet", andParameters: ["name":User.sharedUser.name])]
//        
//        request?.setCompletionBlockSuccess({ (request, response) in
//            let response = response as! [String: AnyObject]
//            guard let result = response["result"] else { return }
//            let res = result as! [String: AnyObject]
//            if let fulfill = res["fulfillment"] {
//                
//                let fulfillment = fulfill as! [String: AnyObject]
//                if let text = fulfillment["speech"] {
//                    let textResponse = (fulfillment["speech"] as! String)
//                    let msg = super.sendText(textResponse, isIncomingMessage: true)
//                    self.decorateMessage(msg)
//                    FireBaseSynchroniser.sharedSynchroniser.send(textResponse, isIncoming: true)
//                }
//            }
//        }, failure: { (request, error) in
//            print("fail")
//        })
//        apiai.enqueue(request)
//        let msg = super.sendText(text, isIncomingMessage: isIncomingMessage)
//        decorateMessage(msg)
//        return msg
//    }
//    
//    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            if appDelegate.interstitialView == nil {
//                let interstitialView = InterstitialView(frame: self.view.frame)
//                appDelegate.interstitialView = interstitialView
//            }
//            
//            if !interstitialPresented {
//                self.view.addSubview(appDelegate.interstitialView!)
//                interstitialPresented = true
//                self.tabBarController?.tabBar.isHidden = true
//            } else {
//                appDelegate.interstitialView?.removeFromSuperview()
//                interstitialPresented = false
//                self.tabBarController?.tabBar.isHidden = false
//            }
//        }
//    }
//    
//}
