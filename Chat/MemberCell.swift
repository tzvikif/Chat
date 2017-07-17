//
//  MemberCell.swift
//  Chat
//
//  Created by tzviki fisher on 30/06/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

protocol ChatCellDelegate:NSObjectProtocol {
    func chatWith(_ partner:String) -> Void
}

class MemberCell: UITableViewCell{
    var isOnline:Bool = false {
        didSet {
            if self.isOnline == true {
                self.isOnlineView.backgroundColor=UIColor.green
            } else {
                self.isOnlineView.backgroundColor=UIColor.red
            }
        }
    }
    var tapGesture:UITapGestureRecognizer!
    var userName:String!  {
        didSet {
            self.lblUserName.text = self.userName
        }
    }
    var partner:Person? = nil
    var delegate:ChatCellDelegate?
    
    
    @IBOutlet weak var isOnlineView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUserName.text=userName
        if (isOnline) {
            isOnlineView.backgroundColor = UIColor.green
        } else {
            isOnlineView.backgroundColor = UIColor.red
        }
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
//        self.tapGesture.cancelsTouchesInView=false
//        self.tapGesture?.numberOfTapsRequired=1
        self.ivIcon!.addGestureRecognizer(self.tapGesture!)
        self.ivIcon!.isUserInteractionEnabled = true
    }

//    @IBAction func chatIconPressed(_ sender: Any) {
//        if let method = delegate?.chatWith {
//            method(self.partner!)
//        }
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print("chat icons tapped!")
        self.delegate?.chatWith(self.userName)
    }
    
}
