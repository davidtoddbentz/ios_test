//
//  ToDoTableViewCell.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 23/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var completedBtn: UIButton!
    var todoItem: ActionCard?
    
    func setCell(todoItem: ActionCard) {
        self.todoItem = todoItem
        self.lblTitle.text = todoItem.title
        let image = todoItem.completed == true ? UIImage(named: "todoSelected") : UIImage(named: "todoDeselected")
        self.completedBtn.setImage(image, for: .normal)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchCompletionButton(_ sender: Any) {
        if let completed = todoItem?.completed {
            todoItem?.completed = !completed
        } else {
            todoItem?.completed = true
        }
        FireBaseSynchroniser.sharedSynchroniser.actionCardWithID((todoItem?.id!)!, setCompleted: (todoItem?.completed!)!)
        setCell(todoItem: todoItem!)
    }

}
