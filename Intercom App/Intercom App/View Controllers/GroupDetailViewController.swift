//
//  GroupDetailViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {

    
    var group: Group?
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }
    
    
    func updateView() {
        
        groupName.text = group?.name
        createdAt.text = group?.createdAt
        
    }
    
    @IBAction func deleteGroup(_ sender: Any) {
        GroupController.shared.deleteRequest(groupID: group!.id!)
        dismiss(animated: true, completion: nil)
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
