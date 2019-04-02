//
//  AddTableViewCell.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class AddTableViewCell: UITableViewCell {

    weak var peer: Peer!
    weak var delegate: AddTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("add button pressed for peer \(String(describing: peer.peerID.displayName))")
        delegate?.addTableViewCellAddButtonPressed(on: peer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // By not calling super.setSelected(), I stop the cell from hilighting on a tap
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol AddTableViewCellDelegate: AnyObject {
    func addTableViewCellAddButtonPressed(on peer: Peer)
}
