//
//  AvatarCreationView.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 31/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit
import ImagePicker

protocol AvatarCreationDelegate {
    func didFinishCreatingAvatar()
}

class AvatarCreationView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTxtField: UITextField!
    var imagePickerController: ImagePickerController?
    var delegate: AvatarCreationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let v = Bundle.main.loadNibNamed("AvatarCreationView", owner: self, options: nil)?.first as! UIView
        self.backgroundColor = UIColor.lightGray
        self.backgroundColor = UIColor.clear
        v.layer.cornerRadius = 30.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        v.clipsToBounds = true
        v.frame = self.frame
        self.addSubview(v)
        avatarButton.imageView?.contentMode = .scaleAspectFill
        
    }
    
    @IBAction func didTouchAvatarButton(_ sender: Any) {
        imagePickerController = ImagePickerController()
        if let imagePickerController = imagePickerController {
            imagePickerController.delegate = self
            imagePickerController.imageLimit = 1
            
            if let vc = self.delegate as? UIViewController {
                vc.present(imagePickerController, animated: true, completion: {
                    self.avatarButton.imageView?.layer.cornerRadius = self.avatarButton.bounds.height / 2.0
                })
            }
        }
    }
    
    @IBAction func didTouchDoneButton(_ sender: Any) {
        FireBaseSynchroniser.sharedSynchroniser.uploadAvatar(nameTxtField.text ?? "avatar", withImage: avatarButton.imageView?.image) {
            self.delegate?.didFinishCreatingAvatar()
        }
    }

}

extension AvatarCreationView: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePickerController?.dismiss(animated: true, completion: nil)
        avatarButton.setImage(images[0], for: .normal)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
}
