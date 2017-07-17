//
//  ViewController.swift
//  Chat
//
//  Created by tzviki fisher on 28/06/2017.
//  Copyright © 2017 tzviki fisher. All rights reserved.
//

import UIKit

struct SegueId {
    static let userNameId:String = "UserNameId"
    static let chatId:String = "chatId"
    static let toChat:String = "ToChatId"
}
class LoginViewController: UIViewController,UITextFieldDelegate  {

    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var tvMail: UITextField!
    @IBOutlet weak var tvPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvMail.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextClicked(_ sender: Any) {
        self.tvMail.resignFirstResponder()
        self.tvPassword.resignFirstResponder()
        
//        self.performSegue(withIdentifier: SegueId.userNameId, sender: self)
        
    }
    func isValidEmail(testStr:String) -> Bool {
        return true
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.userNameId {
            print("segue:/(segue!.identifier)" )
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let  str = self.tvMail.text else {return false}
        if isValidEmail(testStr: str) {
            self.error.text = ""
            return true
        } else {
            self.error.isHidden=false
            self.error.text = "מייל לא תקין"
            return false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.error.text = ""
    }
}
//extension LoginViewController: UITextFieldDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.error.text = ""
//    }
//}

