//
//  GroupDetailViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController, UITextFieldDelegate {

    
    var group: Group?
    

    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupName.delegate = self
        updateView()
    }
    
    
    func updateView() {
        
        groupName.text = group?.name
        createdAt.text = group?.createdAt
        title = group?.name
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let name = groupName.text {
            GroupController.shared.putRequest(groupID: group!.id!, groupName: name)
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteGroup(_ sender: Any) {
        GroupController.shared.deleteRequest(groupID: group!.id!)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteNewUser(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupName.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
