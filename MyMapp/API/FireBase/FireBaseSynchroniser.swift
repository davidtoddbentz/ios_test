    //
    //  FireBaseSynchroniser.swift
    //  BaseProject
    //
    //  Created by Bazyl Reinstein on 15/11/2016.
    //  Copyright © 2016 BJSS Ltd. All rights reserved.
    //
    
    import UIKit
    import Firebase
    import FirebaseStorage
    import NMessenger
    
    class FireBaseSynchroniser: NSObject {
        
        static let sharedSynchroniser = FireBaseSynchroniser()
        let ref = Database.database().reference()
        
        func add(user: String, service: Service, completion: @escaping (Void) -> Void) {
            self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                let users = snapshot.value as? [String: AnyObject] ?? [:]
                if users[user] == nil {
                    self.ref.child("users").child(user).setValue(["username" : user])
                    self.ref.child("users/\(user)/preferences/avatar").setValue("0")
                    self.ref.child("users/\(user)/preferences/parentEmail").setValue("briansparents@icloud.com")
                    self.ref.child("users/\(user)/preferences/counselorEmail").setValue("brianscounselor@gmail.com")
                    self.setDeviceToken()
                }
                completion()
            })
        }
        
        func setAvatar(id: String, completion: @escaping (Void) -> Void) {
            guard let userID = User.sharedUser.name else { return }
            self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                let users = snapshot.value as? [String: AnyObject] ?? [:]
                if users[userID] != nil {
                    self.ref.child("users/\(userID)/preferences/avatar").setValue(id)
                }
                completion()
            })
        }
        
        func getAvatar(completion: @escaping (String) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/preferences").observe(.value, with: { (snapshot) in
                let user = snapshot.value as? [String: AnyObject]
                if let user = user, let avatar = user["avatar"] {
                    if avatar is String {
                        completion(avatar as! String)
                    }
                }
            })
        }
        
        func getAvatars(completion: @escaping ([Avatar]) -> Void) {
            self.ref.child("Avatars").observeSingleEvent(of: .value, with: { (snapshot) in
                let avatars = snapshot.value as? [[String: String]] ?? [[:]]
                var avatarArray = [Avatar]()
                for avatar in avatars {
                    if let name = avatar["name"], let imageURL = avatar["imageURL"], let id = avatar["id"] {
                        let avatar = Avatar(name: name, imageURL: imageURL, id: id)
                        avatarArray.append(avatar)
                    }
                }
                completion(avatarArray)
            })
        }
        
        func getParentEmail(completion: @escaping (String) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/preferences").observe(.value, with: { (snapshot) in
                let user = snapshot.value as? [String: AnyObject]
                if let user = user, let parentEmail = user["parentEmail"] {
                    if parentEmail is String {
                        completion(parentEmail as! String)
                    }
                }
            })
        }
        
        func getCounselorEmail(completion: @escaping (String) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/preferences").observe(.value, with: { (snapshot) in
                let user = snapshot.value as? [String: AnyObject]
                if let user = user, let counselorEmail = user["counselorEmail"] {
                    if counselorEmail is String {
                        completion(counselorEmail as! String)
                    }
                }
            })
        }
        
        func getCollegeInfo(completion: @escaping ([College]) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/plexus/0").observe(.value, with: { (snapshot) in
                let plexusPayload = snapshot.value as? [[String: AnyObject]]
                if let plexusPayload = plexusPayload {
                    var colleges = [College]()
                    for college in plexusPayload {
                        let collegeObject = College()
                        if college["SchoolName"] is String {
                            collegeObject.schoolName = (college["SchoolName"] as! String)
                        }
                        if college["SchoolLocation"] is String {
                            collegeObject.schoolLocation = (college["SchoolLocation"] as! String)
                        }
                        
                        if college["InStateTuition"] is String {
                            collegeObject.inStateTuition = (college["InStateTuition"] as! String)
                        }
                        if college["OutOfStateTuition"] is String {
                            collegeObject.outOfStateTuition = (college["OutOfStateTuition"] as! String)
                        }
                        if college["StudentBodySize"] is String {
                            collegeObject.studentBodySize = (college["StudentBodySize"] as! String)
                        }
                        if college["FourYearGraduationRate"] is String {
                            collegeObject.graduationRate = "\(college["FourYearGraduationRate"] as! String)%"
                        }
                        if college["SchoolSentiment"] is String {
                            collegeObject.schoolSentiment = (college["SchoolSentiment"] as! String)
                        }
                        if college["PercentAdmitted"] is String {
                            collegeObject.acceptanceRate = "\((college["PercentAdmitted"] as! String))%"
                        }
                        if college["SchoolKeyTopic1"] is String {
                            collegeObject.keyTopic1 = "\((college["SchoolKeyTopic1"] as! String))"
                        }
                        if college["SchoolKeyTopic2"] is String {
                            collegeObject.keyTopic2 = "\((college["SchoolKeyTopic2"] as! String))"
                        }
                        if college["SchoolKeyTopic3"] is String {
                            collegeObject.keyTopic3 = "\((college["SchoolKeyTopic3"] as! String))"
                        }
                        
                        
                        
                        if college["AverageHSGPA"] is String {
                            let str = college["AverageHSGPA"] as! String
                            collegeObject.averageHSGPA = str
                        }
                        if college["SchoolRank"] is String {
                            collegeObject.schoolRank = (college["SchoolRank"] as! String)
                        }
                        
                        if college["SchoolURLPlexuss"] is String {
                            collegeObject.webURLPlexuss = (college["SchoolURLPlexuss"] as! String)
                        }
                        if college["RequireTestScoresForAdmissionPLX"] is String {
                            collegeObject.satACTScorePLX = (college["RequireTestScoresForAdmissionPLX"] as! String)
                        }
                        if college["RequireTestScoresForAdmissionSC"] is String {
                            collegeObject.satACTScoreSC = (college["RequireTestScoresForAdmissionSC"] as! String)
                        }
                        if college["SchoolURLCollegeConfidential"] is String {
                            collegeObject.webURLCollegeConfidential = (college["SchoolURLCollegeConfidential"] as! String)
                        }
                        
                        
                        
                        colleges.append(collegeObject)
                    }
                    completion(colleges)
                }
            })
        }
        
        func setFavouriteCollege(_ college: College) {
            guard let userID = User.sharedUser.name else { return  }
            
            var rank = ""
            var sentiment = ""
            if let schoolSentiment = college.schoolSentiment,
                let sentimentValue = Double(schoolSentiment) {
                sentiment = sentimentValue < 0 ? "unhappy" : "happy"
                rank = "\(abs(sentimentValue * 100))"
            }
            
            self.ref.child("users/\(userID)/context/favoriteCollegeName").setValue(college.schoolName)
            self.ref.child("users/\(userID)/context/favoriteCollegeSentiment").setValue(sentiment)
            self.ref.child("users/\(userID)/context/favoriteCollegeRating").setValue(rank)
            self.ref.child("users/\(userID)/context/favoriteCollegeCClink").setValue(college.webURLCollegeConfidential)
            self.ref.child("users/\(userID)/context/favoriteCollegePlexussLink").setValue(college.webURLPlexuss)
        }
        
        func setDeviceToken() {
            
            guard let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"),
                let userID = User.sharedUser.name
                else { return }
            
            self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let userProfile = snapshot.value as? [String: AnyObject] ?? [:]
                if userProfile["devices"] == nil {
                    self.ref.child("users").child(userID).child("devices").setValue(["0": deviceToken])
                } else {
                    // TODO
                    // Need to check if the token exists, and if not add - Currently just overriting device 0
                    //let devices = userProfile["devices"] as! [[String: AnyObject]]
                    //let deviceCount = userProfile["devices"]!.count!
                    self.ref.child("users").child(userID).child("devices/0").setValue(deviceToken)
                }
            })
        }
        
        
        func chatHistory(completion: @escaping ([[String: String]]?) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
                var chatArray = [[String: String]]()
                if snapshot.value == nil {
                    return
                }
                let snapshot = snapshot.value as! [String: AnyObject]
                if snapshot["chat"] == nil {
                    return
                }
                let chatHistory = snapshot["chat"] as! [[String: AnyObject]]
                for message in chatHistory {
                    let messageUID = Int(message["uid"] as! String)
                    self.currentUID = max(self.currentUID, messageUID! + 1)
                    chatArray.append(message as! [String : String])
                }
                completion(chatArray)
            })
        }
        
        var currentUID: Int = 0
        
        func send(_ text: String, senderId: String) {
            guard let userID = User.sharedUser.name else { return  }
            let chatRef = self.ref.child("users/\(userID)")
            chatRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let messageUID = "\(self.currentUID)"
                self.currentUID += 1
                let message = ["uid" : messageUID,
                               "text": text,
                               "senderId": senderId] as [String : Any]
                let userProfile = snapshot.value as? [String: AnyObject] ?? [:]
                if userProfile["chat"] == nil {
                    chatRef.child("chat").setValue([messageUID: message])
                } else {
                    chatRef.child("chat/\(messageUID)").setValue(message)
                }
            })
        }
        
        func leaders(completion: @escaping ([Leader]?) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)").observe(.value, with: { (snapshot) in
                if snapshot == nil {
                    return
                }
                var snapshot = snapshot.value as! [String: AnyObject]
                if snapshot["videos"] == nil {
                    return
                }
                snapshot = snapshot["videos"] as! [String: AnyObject]
                if snapshot["data"] == nil {
                    return
                }
                let data = snapshot["data"] as! [[String: AnyObject]]
                
                var leaders = [Leader]()
                for (index, element) in data.enumerated() {
                    var videos = [Video]()
                    let leader = Leader()
                    
                    leader.id = String(index)
                    if let name = element["full_name"] {
                        leader.name = name as? String
                    }
                    if let company = element["company"] {
                        leader.company = company as? String
                    }
                    if let profession = element["occupation"] {
                        leader.profession = profession as? String
                    }
                    if let quote = element["quote"] {
                        leader.quote = quote as? String
                    }
                    if let milestone = element["milestone"] {
                        leader.biography = milestone as? [String]
                    }
                    
                    if let _ = element["profile"] {
                        let prof = element["profile"] as? [String: AnyObject]
                        if let profileImagePath = prof?["path"]! {
                            leader.profilePicture = profileImagePath as? String
                        }
                    }
                    
                    if let joinData = element["join_data"] as! [[String: AnyObject]]? {
                        for var video in joinData {
                            let vid = Video()
                            if let desc = video["description"] {
                                vid.desc = desc as? String
                            }
                            if let score = video["_score"] {
                                vid.score =  score as? CGFloat
                            }
                            if let duration = video["duration"] {
                                vid.duration = duration as? Int
                            }
                            if let manifestURL = video["manifest_url"] {
                                vid.manifestURL = manifestURL as? String
                            }
                            if let thumbURL = video["thumb_url"] {
                                vid.thumbURL = thumbURL as? String
                            }
                            if let title = video["title"] {
                                vid.title = title as? String
                            }
                            
                            vid.author = leader.name
                            videos.append(vid)
                        }
                        leader.videos = videos
                    }
                    leaders.append(leader)
                }
                completion(leaders)
            })
        }
        
        func actionCards(chosenOnly showChosenOnly: Bool, completion: @escaping ([ActionCard]?) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)").observe(.value, with: { (snapshot) in
                if snapshot.value == nil {
                    return
                }
                var snapshot = snapshot.value as! [String: AnyObject]
                if snapshot["actionCard"] == nil {
                    return
                }
                let data = snapshot["actionCard"] as! [[String: AnyObject]]
                
                var actionCards = [ActionCard]()
                for (index, element) in data.enumerated() {
                    let actionCard = ActionCard()
                    actionCard.id = "\(index)"
                    if let isChosen = element["chosen"] {
                        if showChosenOnly && (isChosen as? Bool) == false {
                            continue
                        }
                        actionCard.chosen = isChosen as? Bool
                    }
                    if let job = element["job"] {
                        actionCard.job = job as? String
                    }
                    if let title = element["title"] {
                        actionCard.title = title as? String
                    }
                    if let videoURL = element["videoURL"] {
                        actionCard.videoURL = videoURL as? String
                    }
                    if let thumbnail = element["thumbnail"] {
                        actionCard.thumbnail = thumbnail as? String
                    }
                    if let completed = element["completed"] {
                        actionCard.completed = completed as? Bool
                    }
                    
                    actionCards.append(actionCard)
                    
                }
                completion(actionCards)
            })
        }
        
        func actionCardWithID(_ id: String) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/actionCard").child(id).child("chosen").setValue(true)
        }
        
        func actionCardWithID(_ id: String, setCompleted completed: Bool) {
            guard let userID = User.sharedUser.name else { return  }
            self.ref.child("users/\(userID)/actionCard").child(id).child("completed").setValue(completed)
        }
        
        
        func careers(completion: @escaping ([Career]?) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            let chatRef = self.ref.child("users/\(userID)")
            chatRef.observe(.value, with: { (snapshot) in
                var careerArray = [Career]()
                if snapshot.value == nil {
                    return
                }
                let snapshot = snapshot.value as! [String: AnyObject]
                if snapshot["sku"] == nil {
                    return
                }
                let careers = snapshot["sku"] as! [[String: AnyObject]]
                for (index, tempCareer) in careers.enumerated() {
                    let career = Career()
                    career.id = String(index)
                    if let avgSalary = tempCareer["average_salary"] {
                        career.averageSalary = avgSalary as? String
                    }
                    if let employment = tempCareer["employment"] {
                        career.employment = employment as? String
                    }
                    if let growth = tempCareer["growth"] {
                        career.growth = growth as? String
                    }
                    if let intRating = tempCareer["interest_rating"] {
                        career.interestRating = intRating as? String
                    }
                    if let jobTitle = tempCareer["job_title"] {
                        career.jobTitle = jobTitle as? String
                    }
                    if let profileImage = tempCareer["profile_image"] {
                        career.profileImage = profileImage as? String
                    }
                    if let education = tempCareer["education"] {
                        career.education = education as? String
                    }
                    if let salary = tempCareer["salary"] {
                        career.salary = salary as? String
                    }
                    if let linkURL = tempCareer["link_url"] {
                        career.linkURL = linkURL as? String
                    }
                    if let salaryRating = tempCareer["salary_rating"] {
                        career.salaryRating = salaryRating as? String
                    }
                    careerArray.append(career)
                }
                completion(careerArray)
            })
        }
        
        func videos(completion: @escaping ([Video]?) -> Void) {
            guard let userID = User.sharedUser.name else { return  }
            let videoRef = self.ref.child("users/\(userID)")
            
            videoRef.observe(.value, with: { (snapshot) in
                if snapshot.value == nil {
                    return
                }
                var snapshot = snapshot.value as! [String: AnyObject]
                if snapshot["videos"] == nil {
                    return
                }
                snapshot = snapshot["videos"] as! [String: AnyObject]
                if snapshot["data"] == nil {
                    return
                }
                let data = snapshot["data"] as! [[String: AnyObject]]
                
                
                var videos = [Video]()
                for var element in data {
                    
                    if let name = element["full_name"] {
                        if let joinData = element["join_data"] as! [[String: AnyObject]]? {
                            for var video in joinData {
                                let vid = Video()
                                vid.desc = video["description"]! as? String
                                vid.score = video["_score"]! as? CGFloat
                                vid.duration = video["duration"]! as? Int
                                vid.manifestURL = video["manifest_url"]! as? String
                                vid.thumbURL = video["thumb_url"]! as? String
                                vid.title = video["title"]! as? String
                                vid.author = name as? String
                                videos.append(vid)
                            }
                        }
                    }
                }
                completion(videos)
            })
        }
        
        func uploadAvatar(_ avatarName: String, withImage image: UIImage?, completion: @escaping (Void) -> Void) {
            var localImage: UIImage
            if let image = image {
                localImage = image
            } else {
                localImage = #imageLiteral(resourceName: "uploadYourOwn")
            }
            
            let scaledImage = localImage.scaledToFit(CGSize(width: 150, height: 150))
            guard let data = UIImagePNGRepresentation(scaledImage) else { return }
            var downloadURL = ""
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let avatarsRef = storageRef.child("avatars/\(avatarName).png")
            
            let _ = avatarsRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print(error)
                    return
                }
                if let url = metadata.downloadURL() {
                    downloadURL = url.absoluteString
                    print(downloadURL)
                    self.ref.child("Avatars").observeSingleEvent(of: .value, with: { (snapshot) in
                        let avatars = snapshot.value as? [[String: String]] ?? [[:]]
                        let numOfAvatars = avatars.count
                        
                        self.ref.child("Avatars").child("\(numOfAvatars)").setValue(["id" : String(numOfAvatars)])
                        self.ref.child("Avatars/\(numOfAvatars)/imageURL").setValue(downloadURL)
                        self.ref.child("Avatars/\(numOfAvatars)/name").setValue(avatarName)
                        completion()
                    })
                }
            }
            
        }
        
        
    }
