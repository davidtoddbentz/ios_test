//
//  CollegesViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 11/01/2017.
//  Copyright © 2017 BJSS Ltd. All rights reserved.
//

import UIKit

class CollegesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton1: UIButton!
    @IBOutlet weak var filterButton2: UIButton!
    @IBOutlet weak var filterButton3: UIButton!
    @IBOutlet weak var favouriteFilter: UIButton!
    
    
    var colleges: [College] = []
    var lastSelected: IndexPath!
    fileprivate let transitionManager = MCMHeaderAnimated()
    var isFilteredForFavourites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        filterButton1.setupFilterButton()
        filterButton2.setupFilterButton()
        filterButton3.setupFilterButton()
        
        FireBaseSynchroniser.sharedSynchroniser.getCollegeInfo { (colleges) in
            self.colleges = colleges
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plexussSegue" {
            var array = [College]()
            if isFilteredForFavourites {
                array = colleges.filter({ (college) -> Bool in
                    college.isFavourite == true
                })
            } else {
                array = colleges
            }
            let college = colleges[lastSelected.row]
            let destination = segue.destination as! CollegeWebView
            destination.transitioningDelegate = self.transitionManager
            destination.url = college.webURLPlexuss
            self.transitionManager.destinationViewController = destination
            destination.transitioningDelegate = self.transitionManager
        }
    }
    @IBAction func didTapFavouriteFilter(_ sender: Any) {
        isFilteredForFavourites = !isFilteredForFavourites
        favouriteFilter.setImage(isFilteredForFavourites ? #imageLiteral(resourceName: "heartSelected") : #imageLiteral(resourceName: "heartDeselected"), for: .normal)
        
        self.tableView.reloadData()
    }

}

extension CollegesViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteredForFavourites {
            return colleges.filter({ (college) -> Bool in
                college.isFavourite == true
            }).count
        } else {
            return colleges.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollegeTableViewCell", for: indexPath) as! CollegeTableViewCell
        var array = [College]()
        if isFilteredForFavourites {
            array = colleges.filter({ (college) -> Bool in
                college.isFavourite == true
            })
        } else {
            array = colleges
        }
        let college = array[indexPath.row]
        cell.setupView(college)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelected = indexPath
        self.performSegue(withIdentifier: "plexussSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 383.0
    }
}

extension CollegesViewController: CollegeTableViewCellDelegate {
    func didTouchFavouriteButton() {
        self.tableView.reloadData()
    }
}

extension CollegesViewController: MCMHeaderAnimatedDelegate {
    func headerView() -> UIView {
        
        if let cell = self.tableView.cellForRow(at: self.lastSelected) as? HeaderedTableViewCell {
            return cell.header
        }
        return UIView()
    }
    
    func headerCopy(subview: UIView) -> UIView {
        
        if let cell = tableView.cellForRow(at: self.lastSelected) as? CollegeTableViewCell {
            let header = UIView(frame: cell.header.frame)
            header.backgroundColor = UIColor.rnsDarkSkyBlue
            return header
        }
        return UIView()
    }
}

extension UIButton {
    func setupFilterButton() {
        self.layer.cornerRadius = 4.0
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
