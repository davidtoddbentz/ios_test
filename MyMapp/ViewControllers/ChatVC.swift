//
//  ChatVC.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 06/02/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import Photos
import JSQMessagesViewController
import Firebase
import ApiAI
import SDWebImage

final class ChatVC: JSQMessagesViewController {
    
    // MARK: Properties
    private let imageURLNotSetKey = "NOTSET"
    
    var channelRef: DatabaseReference?
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    private var paAvatarImage: UIImage?
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = Auth.auth().currentUser?.uid
        FireBaseSynchroniser.sharedSynchroniser.chatHistory { (msgs) in
            if let msgs = msgs {
                for msg in msgs {
                    let messageText = msg["text"]
                    let senderId = msg["senderId"]
                    if senderId != nil, messageText != nil {
                        self.addMessage(withId: senderId!, name: senderId!, text: messageText!)
                        self.finishReceivingMessage()
                    }
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 72.0)
        self.view.frame = frame
    }
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = UIColor.white
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let msg = messages[indexPath.row]
        if msg.senderId == self.senderId {
            return JSQMessagesAvatarImage(avatarImage: #imageLiteral(resourceName: "brianChatAvatar"), highlightedImage: #imageLiteral(resourceName: "brianChatAvatar"), placeholderImage: #imageLiteral(resourceName: "brianChatAvatar"))
        } else {
            let imageData = UserDefaults.standard.object(forKey: "avatarImage")
            if var img = UIImage(data: imageData as! Data) {
                let radius = UInt(img.size.height / CGFloat(2.0))
                img = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: radius)
                return JSQMessagesAvatarImage(avatarImage: img, highlightedImage: img, placeholderImage: img)
            }
        }
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        switch senderId {
        case self.senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    // MARK: Firebase related methods
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        addMessage(withId: self.senderId, name: "me", text: text)
        
        
        FireBaseSynchroniser.sharedSynchroniser.send(text, senderId: self.senderId)
        let request = apiai.textRequest()
        request?.query = [text]
        request?.requestContexts = [AIRequestContext.init(name: "userNameSet", andParameters: ["name":User.sharedUser.name])]
        
        request?.setCompletionBlockSuccess({ (request, response) in
            let response = response as! [String: AnyObject]
            guard let result = response["result"] else { return }
            let res = result as! [String: AnyObject]
            if let fulfill = res["fulfillment"] {
                
                let fulfillment = fulfill as! [String: AnyObject]
                if let text = fulfillment["speech"] {
                    let textResponse = (fulfillment["speech"] as! String)
                    self.addMessage(withId: "api.ai", name: "bot", text: text as! String)
                    FireBaseSynchroniser.sharedSynchroniser.send(textResponse, senderId: "api.ai")
                    self.finishSendingMessage()
                }
            }
        }, failure: { (request, error) in
            print("fail")
        })
        apiai.enqueue(request)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    // MARK: UI and User Interaction
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.rnsBlueChat)
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.rnsBlackChat)
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
}
