//
//  ChatListViewController.swift
//  Chat
//
//  Created by tzviki fisher on 01/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 70.0
let offset_Y_LabelHeader:CGFloat = 30.0 //from offset 0 to offset_HeaderStop
let start_X_LabelHeader_inOffset:CGFloat = 40.0 //from offset offset_Y_LabelHeader to offset_HeaderStop
let end_pos_headerLabel_y:CGFloat = 5.0

//let ratio_Y_LabelHeader:CGFloat = 0.4

class ChatListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ChatCellDelegate,UIScrollViewDelegate {
    func chatWith(_ partner: String) {
        self.chatWith=partner
//        print("partner name:\(partner)")
        performSegue(withIdentifier: SegueId.toChat, sender: self)
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var overlayHeaderLabel: UILabel!
    
    @IBOutlet weak var chatSeg: UISegmentedControl!
    @IBOutlet weak var SegContainer: UIView!
    var headerImageView:UIImageView!
    var partnerChat:Person?
    var chatWith:String?
    var deltaHeaderLabelY:CGFloat?
    var deltaHeaderLabelX:CGFloat?
    var end_pos_headerLabel_x:CGFloat?
    var start_pos_headerLabel_x:CGFloat?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName:"MemberCell",bundle:nil), forCellReuseIdentifier: "MemberCellId")
        let initialHeaderHeight = header.bounds.height
        tableView.contentInset = UIEdgeInsetsMake(initialHeaderHeight+SegContainer!.frame.size.height, 0, 0, 0)
        let rect:CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        deltaHeaderLabelY = (headerLabel.frame.origin.y - end_pos_headerLabel_y)
        let font = headerLabel.font
        let text = headerLabel.text
        let tempLabel:UILabel = UILabel()
        tempLabel.text = text
        tempLabel.font = font?.withSize(12)
        let endHeaderWidth:CGFloat = tempLabel.bounds.width
        
//        deltaHeaderLabelX = ((header.bounds.width-endHeaderWidth)/2.0 - headerLabel.frame.origin.x)
        deltaHeaderLabelX = 60.0
        start_pos_headerLabel_x = headerLabel.frame.origin.x
        tableView.scrollRectToVisible(rect, animated: false)
        tableView.delegate = self
//        print("initialHeaderHeight=\(initialHeaderHeight)")
        addSegementedControll()
    }
    override func viewDidAppear(_ animated: Bool) {
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        header.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let count = appDelegate.members?.count {
            print("count: \(count)")
            return count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCellId") as! MemberCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.members) != nil {
            let member:Person = appDelegate.members![indexPath.row]
            cell.userName = member.userName
            cell.isOnline = member.isOnline
            cell.delegate = self
        }
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCellId") as! MemberCell
        return cell.frame.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row:\(indexPath.row)")
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30.0))
        let segmentedControl = UISegmentedControl(items: ["אנשים","קבוצות","אירועים"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        headView.addSubview(segmentedControl)
        let horizontalConstraintLeading = NSLayoutConstraint(item: headView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: segmentedControl, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let horizontalConstraintTrailing = NSLayoutConstraint(item: headView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: segmentedControl, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([horizontalConstraintLeading,horizontalConstraintTrailing])
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
 */
    func mapTypeChanged(segControl: UISegmentedControl) //removing th
    {
        switch segControl.selectedSegmentIndex{
        case 0: break
            //mapView.mapType = .standard
        case 1: break
//            mapView.mapType = .hybrid
        case 2: break
//            mapView.mapType = .satellite
        default:
            break
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.toChat {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.name = self.chatWith
        }
    }
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = tableView.contentOffset.y
        offset = offset + header.bounds.height + SegContainer!.frame.size.height
//        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        let headerLabelTransform = CATransform3DIdentity
        var segContainerTransform = CATransform3DIdentity
        // PULL DOWN -----------------
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            
            let segContainerVariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            segContainerTransform =  CATransform3DTranslate(headerTransform, 0, segContainerVariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            //            print("headerScaleFactor=\(headerScaleFactor) headerSizevariation=\(headerSizevariation)")
            header.layer.transform = headerTransform
            SegContainer.layer.transform = segContainerTransform
            // SCROLL UP/DOWN ------------
        } else {
            let headerSizeVariation = min(offset_HeaderStop, offset )
            headerTransform = CATransform3DTranslate(headerTransform, 0, -(headerSizeVariation), 0)
            segContainerTransform = headerTransform
            header.layer.transform = headerTransform
            SegContainer.layer.transform = segContainerTransform
            // HEADER LABEL ------------
            if deltaHeaderLabelY == nil {
                return}
            let ratio_Y_LabelHeader:CGFloat = deltaHeaderLabelY!/offset_HeaderStop
            
            let headerLabelSizeVariationY = min(offset*ratio_Y_LabelHeader-headerSizeVariation,deltaHeaderLabelY!-offset_HeaderStop)
//            print("offset*ratio_Y_LabelHeader=\(offset*ratio_Y_LabelHeader) deltaHeaderLabel=\(deltaHeaderLabel!) offset=\(offset) headerLabelSizeVariationY=\(headerLabelSizeVariationY)")
            var headerLabelTransform = CATransform3DTranslate(headerLabelTransform, 0, -headerLabelSizeVariationY, 0)
            overlay.alpha = min((1.0/70.0)*offset,1.0)
        
            
            if offset > start_X_LabelHeader_inOffset {
                let ratio_X_LabelHeader:CGFloat = deltaHeaderLabelX!/(offset_HeaderStop-start_X_LabelHeader_inOffset)
                let ratioPixel:CGFloat = 5.0/(offset_HeaderStop-start_X_LabelHeader_inOffset)
                let headerLabelSizeVariationX = min( (offset-start_X_LabelHeader_inOffset)*ratio_X_LabelHeader,deltaHeaderLabelX!+start_pos_headerLabel_x!)
                headerLabelTransform = CATransform3DTranslate(headerLabelTransform, headerLabelSizeVariationX, 0, 0)
                let headerLabelFontSize = max(17.0-(offset-start_X_LabelHeader_inOffset)*ratioPixel, 12.0)
                headerLabel.font = headerLabel.font.withSize(headerLabelFontSize)
                headerLabel.sizeToFit()
            }
            headerLabel.layer.transform = headerLabelTransform
            overlayHeaderLabel.font = headerLabel.font
            overlayHeaderLabel.frame = headerLabel.frame
            
//            if ( tableView.contentOffset.y>=(-120.0)) && (tableView.contentOffset.y<=(-50.0) ) {
//                tableView.contentInset = UIEdgeInsetsMake(-tableView.contentOffset.y, 0, 0, 0);
//            } else {
//                tableView.contentInset = UIEdgeInsetsMake(50.0, 0, 0, 0);
//            }
            
            print("contextInset=\(tableView.contentInset.top) offset=\(tableView.contentOffset.y)")
        }
    }
    func addSegementedControll() {
        let headerSegView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30.0))
        let segmentedControl = UISegmentedControl(items: ["אנשים","קבוצות","אירועים"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        headerSegView.addSubview(segmentedControl)
        
        let horizontalConstraintLeading = NSLayoutConstraint(item: headerSegView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: segmentedControl, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0.0)
        let horizontalConstraintTrailing = NSLayoutConstraint(item: headerSegView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: segmentedControl, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let headerSegViewVerticalConstrainst = NSLayoutConstraint(item: headerSegView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view!, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0 )
        headerSegViewVerticalConstrainst.identifier = "SegmentConstaintId"
        headerSegView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerSegView)
        
        NSLayoutConstraint.activate([horizontalConstraintLeading, horizontalConstraintTrailing,headerSegViewVerticalConstrainst])
        
    }
//    func chatWith(_ partner: Person) {
//        print("tap!")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if (appDelegate.members) != nil {
//            for member in appDelegate.members! {
//                if member.userName == partner.userName {
//                    if partner.isOnline {
//                        self.partnerChat = partner
//                        performSegue(withIdentifier: SegueId.chatId, sender: self)
//                        break
//                    }
//                    
//                }
//            }
//        }
//    }
    // MARK: - ChatCellDelegate

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
