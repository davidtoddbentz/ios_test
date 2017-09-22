//
//  OrganizerViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 23/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class OrganizerViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var milestonesStackView: UIStackView!
    @IBOutlet weak var preferencesStackView: UIStackView!
    @IBOutlet weak var noTodosImgView: UIImageView!
    
    var todoElements = [ActionCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FireBaseSynchroniser.sharedSynchroniser.actionCards(chosenOnly: true) { (todoItems) in
            if let todo = todoItems {
                self.todoElements = todo
                self.tableView.reloadData()
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let mileGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapStackView))
        let prefGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapStackView))
        milestonesStackView.addGestureRecognizer(mileGestureRecognizer)
        milestonesStackView.isUserInteractionEnabled = true
        milestonesStackView.accessibilityIdentifier = "MilestonesStackView"
        milestonesStackView.isAccessibilityElement = true
        
        preferencesStackView.addGestureRecognizer(prefGestureRecognizer)
        preferencesStackView.isUserInteractionEnabled = true
        preferencesStackView.accessibilityIdentifier = "PreferencesStackView"
        preferencesStackView.isAccessibilityElement = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        self.tableView.reloadData()
    }
    
    func didTapStackView(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if view === milestonesStackView {
                self.performSegue(withIdentifier: "milestonesSegue", sender: self)
            } else if view === preferencesStackView {
                self.performSegue(withIdentifier: "preferencesSegue", sender: self)
            }
        }
    }
}

extension OrganizerViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.isHidden = (todoElements.count == 0)
        return todoElements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as! ToDoTableViewCell
        let todo = todoElements[indexPath.row]
        cell.setCell(todoItem: todo)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
}

