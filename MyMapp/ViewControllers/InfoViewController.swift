//
//  InfoViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 28/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let transitionManager = MCMHeaderAnimated()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitleLabel: UILabel!
    var leaders = [Leader]()
    var  careers = [Career]()
    var elements = [IDable]()
    
    var lastSelected: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        FireBaseSynchroniser.sharedSynchroniser.leaders { (leaders) in
            if let l = leaders {
                self.leaders = l
                self.mergeArrays()
            }
        }
        FireBaseSynchroniser.sharedSynchroniser.careers { (careers) in
            if let c = careers {
                self.careers = c
                self.mergeArrays()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subtitleLabel.textColor = UIColor.rnsWildStrawberry
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.lastSelected = self.tableView.indexPathForSelectedRow
        if segue.identifier == "leaderDetailsSegue" {
            let leader = self.elements[lastSelected!.row] as! Leader
            
            let destination = segue.destination as! LeaderDetailsViewController
            destination.leader = leader
            
            destination.transitioningDelegate = self.transitionManager
            self.transitionManager.destinationViewController = destination
        } else if segue.identifier == "sokanuSegue" {
            let career = elements[lastSelected.row] as! Career
            let destination = segue.destination as! SoKanUViewController
            destination.url = career.linkURL
            
            destination.transitioningDelegate = self.transitionManager
            self.transitionManager.destinationViewController = destination
        }
    }
    
    func mergeArrays() {
        elements = (careers as [IDable]) + (leaders as [IDable])
        elements = elements.sorted { (obj1: IDable, obj2: IDable) -> Bool in
            return Int(obj1.id!)! < Int(obj2.id!)!
        }
        tableView.reloadData()
    }
}

extension InfoViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if elements[indexPath.row] is Leader {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoadmapTableViewCell") as! RoadmapTableViewCell
            let leader = elements[indexPath.row] as! Leader
            cell.setupView(leader)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CareerTableViewCell") as! CareerTableViewCell
            let career = elements[indexPath.row] as! Career
            cell.setupView(career)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if elements[indexPath.row] is Leader {
            self.performSegue(withIdentifier: "leaderDetailsSegue", sender: nil)
        } else {
            self.performSegue(withIdentifier: "sokanuSegue", sender: nil)
        }
    }
    
}

extension InfoViewController: MCMHeaderAnimatedDelegate {
    func headerView() -> UIView {
        
        if let cell = self.tableView.cellForRow(at: self.lastSelected) as? RoadmapTableViewCell {
            return cell.header
        }
        if let cell = self.tableView.cellForRow(at: self.lastSelected) as? CareerTableViewCell {
            return cell.header
        }
        return UIView()
    }
    
    func headerCopy(subview: UIView) -> UIView {
        
        if let cell = tableView.cellForRow(at: self.lastSelected) as? RoadmapTableViewCell {
            let header = UIView(frame: cell.header.frame)
            header.backgroundColor = UIColor.rnsMalachite
            return header
        }
        if let cell = tableView.cellForRow(at: self.lastSelected) as? CareerTableViewCell {
            let header = UIView(frame: cell.header.frame)
            header.backgroundColor = UIColor.rnsSokanuRed
            return header
        }
        return UIView()
    }
}
