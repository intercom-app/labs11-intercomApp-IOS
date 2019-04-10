//
//  GroupDetailViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupEditViewController: UIViewController, UITextFieldDelegate {

    
    var group: Groups?
    let groupListViewController = GroupListViewController()

    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupName.delegate = self
        updateView()
    }
    
    
    func updateView() {
        
        groupName.text = group?.groupName
        createdAt.text = group?.groupCreatedAt
        title = group?.groupName
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let name = groupName.text {
            GroupController.shared.putRequest(groupID: group!.groupID, groupName: name)
           
        }
       // navigationController?.show(groupListViewController, sender: group) 
    }
    @IBAction func deleteGroup(_ sender: Any) {
        GroupController.shared.deleteRequest(groupID: group!.groupID)
        navigationController?.popViewController(animated: true)
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupName.resignFirstResponder()
        return true
    }
    

}
