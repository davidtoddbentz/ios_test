//
//  SocialLoginViewController.swift
//  BaseProject
//
//  Created by Andrea Scuderi on 06/05/2016.
//  Copyright © 2016 Andrea Scuderi. All rights reserved.
//

import UIKit

class SocialLoginViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var skipLoginButton: UIBarButtonItem!
    @IBOutlet weak var loginButtonsView: LoginButtonsView!
    
    
    var viewModel: SocialLoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let logoImage = UIImage(named: "logo")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Style
    
    func updateView() {
        self.setupStyle()
        self.loginButtonsView.delegate = self
        self.collectionView.reloadData()
    }
    
    func setupStyle() {
        //guard let viewModel = self.viewModel else { return }
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        
        guard sender == self.pageControl else { return }
        let indexPath = IndexPath(row: self.pageControl.currentPage, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let vc = segue.destination as? LoginViewController {
            
            if let cell = self.collectionView.visibleCells.last,
                let indexPath = self.collectionView.indexPath(for: cell) {
                
                vc.backgroundImage = self.viewModel?.items[(indexPath as NSIndexPath).row].image
            }
        }
    }
}

extension SocialLoginViewController : LoginActionDelegate {
    
    
    @IBAction func signIn(_ sender: Any?) {
        
        self.performSegueWithIdentifier(.Login, sender: self)
    }
    
    @IBAction func signUp(_ sender: Any?) {
        
        self.performSegueWithIdentifier(.SignUp, sender: self)
    }
    
    @IBAction func skipLogin(_ sender: Any?) {
        
        AmazonClientManager.sharedInstance.authenticationProvider(with: .Undefined)?.startSession()
        
    }
    
}

extension SocialLoginViewController : UIScrollViewDelegate {
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let cell = self.collectionView.visibleCells.last,
            let indexPath = self.collectionView.indexPath(for: cell) {
            self.pageControl.currentPage = (indexPath as NSIndexPath).row
        }
    }
}

extension SocialLoginViewController : UICollectionViewDelegate {
    
    
}

extension SocialLoginViewController : UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let viewModel = self.viewModel else { return 0 }
        
        let count = viewModel.items.count
        self.pageControl.numberOfPages = count
        return count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialLoginCollectionViewCell", for: indexPath) as? SocialLoginCollectionViewCell {
            cell.viewModel = self.viewModel?.items[(indexPath as NSIndexPath).row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SocialLoginViewController : UICollectionViewDelegateFlowLayout {
    
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
