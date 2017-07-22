//
//  ChatListViewController.swift
//  Chat
//
//  Created by tzviki fisher on 01/07/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

//let offset_HeaderStop:CGFloat = 70.0
//let offset_Y_LabelHeader:CGFloat = 30.0 //from offset 0 to offset_HeaderStop
//let start_X_LabelHeader_inOffset:CGFloat = 40.0 //from offset offset_Y_LabelHeader to offset_HeaderStop
//let end_pos_headerLabel_y:CGFloat = 5.0

//let ratio_Y_LabelHeader:CGFloat = 0.4

class ChatPageViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource ,HeaderTableViewDelegate{
    func didScroll(withOffset offset: CGFloat) {
        headerTableViewDelegate?.didScroll(withOffset:offset)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
    }
    let pages = ["ChatContentController", "EventsContentController"]
    var headerTableViewDelegate:HeaderTableViewDelegate?
    // MARK: - HeaderTableViewDelegate


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - HeaderTableViewDelegate

    override func viewDidAppear(_ animated: Bool) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventsContentController")
        setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
            direction: .forward,
            animated: true,
            completion: nil)
    }
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    let controller:ChatListViewController = self.storyboard?.instantiateViewController(withIdentifier: pages[index-1]) as! ChatListViewController
                    controller.headerTableViewDelegate = self
                    return controller
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds // Why? I don't know.
            }
            else if view is UIPageControl {
//                view.removeFromSuperview()
                //                view.backgroundColor = UIColor.clear
            }
        }
    }

    /*
     func pageViewController(_ pageViewController: UIPageViewController,
     viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
     }
     
     func pageViewController(_ pageViewController: UIPageViewController,
     viewControllerAfter viewController: UIViewController) -> UIViewController? {
     
     }
     
     func presentationCount(for pageViewController: UIPageViewController) -> Int {
     
     }
     
     func presentationIndex(for pageViewController: UIPageViewController) -> Int {
     
     }
     */


}
