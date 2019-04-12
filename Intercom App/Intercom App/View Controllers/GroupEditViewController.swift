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
        DispatchQueue.global().async {
            TeamImporter.shared.getUserAndFetchAllDetails()
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let name = groupName.text {
            GroupController.shared.editGroupName(groupID: group!.groupID, groupName: name)
            GroupController.shared.postActivity(groupID: group!.groupID, massage: "Changed Group Name")
           
        }
        navigationController?.popViewController(animated: true)
    
            dismiss(animated: true, completion: nil)
       
       // navigationController?.show(groupListViewController, sender: group) 
    }
    @IBAction func deleteGroup(_ sender: Any) {
        GroupController.shared.deleteGroupRequest(groupID: group!.groupID)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupName.resignFirstResponder()
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteSegue" {
            let destination = segue.destination as! InviteUserTableViewController
            destination.group = self.group
        }
    }

}
