//
//  ContainerViewController.swift
//  Chat
//
//  Created by tzviki fisher on 20/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 70.0
let offset_Y_LabelHeader:CGFloat = 30.0 //from offset 0 to offset_HeaderStop
let start_X_LabelHeader_inOffset:CGFloat = 40.0 //from offset offset_Y_LabelHeader to offset_HeaderStop
let end_pos_headerLabel_y:CGFloat = 5.0


class ContainerViewController: UIViewController,HeaderTableViewDelegate {

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
    var headerTableViewDelegate:HeaderTableViewDelegate?
    var ChatPageViewController: ChatPageViewController!
    var segDelegate:SegDelegate?
    var selectedSegIndex:Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller:ChatPageViewController = storyboard?.instantiateViewController(withIdentifier: "ChatPageViewControllerId") as! ChatPageViewController!
        controller.headerTableViewDelegate = self
        //I want to pass some value - For example: controller.id = 3
        addChildViewController(controller)
        controller.container = self
        segDelegate = controller
        self.view.insertSubview(controller.view, belowSubview: header)
        
        didMove(toParentViewController: controller)
//        let initialHeaderHeight = header.bounds.height

        deltaHeaderLabelY = (headerLabel.frame.origin.y - end_pos_headerLabel_y)
        let font = headerLabel.font
        let text = headerLabel.text
        let tempLabel:UILabel = UILabel()
        tempLabel.text = text
        tempLabel.font = font?.withSize(12)
   
        deltaHeaderLabelX = 60.0
        start_pos_headerLabel_x = headerLabel.frame.origin.x
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        header.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        chatSeg.selectedSegmentIndex = 0
        chatSeg.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        
    }
    //MARK: - SegmentedControll Index changed
    func mapTypeChanged(segControl: UISegmentedControl) //removing th
    {
        switch segControl.selectedSegmentIndex{
        case 0:
            if selectedSegIndex != 0 {
                segDelegate?.chatClicked()
            }
            break
        case 1:
            if selectedSegIndex != 1 {
                segDelegate?.eventsClicked()
            }
            break
        case 2:
            if selectedSegIndex != 2 {
                segDelegate?.groupsClicked()
            }
            break
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
    // MARK: - HeaderTableViewDelegate
    func didFinishSwipeLeft() {
        chatSeg!.selectedSegmentIndex = chatSeg!.selectedSegmentIndex + 1
    }
    func didFinishSwipeRight() {
        chatSeg!.selectedSegmentIndex = chatSeg!.selectedSegmentIndex - 1
    }
    func didScroll(withOffset offset: CGFloat) {
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
        }
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
