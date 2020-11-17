//
//  supportBtn.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-13.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

class supportBtn: UIViewController{

    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var submitBtn: customButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var message: UITextView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
            
            view.addGestureRecognizer(tap)
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
            view.insertSubview(supportView, aboveSubview: blurEffectView)
            
        } else {
            view.backgroundColor = .black
        }
        
        supportView.layer.cornerRadius = 10
        supportView.layer.masksToBounds = true
        supportView.layer.borderWidth = 3.0
        supportView.layer.borderColor = UIColor.lightGray.cgColor
        message.layer.cornerRadius = 4
        
        name.attributedPlaceholder = NSAttributedString(string: "Name (Optional)",attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_textFeld: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        
        if(name.text == "" && message.text == "")
        {
            self.submitBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.submitBtn.setTitle("Error!", for: .normal)
            self.submitBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.submitBtn.layer.backgroundColor = UIColor.systemIndigo.cgColor
                
                self.submitBtn.setTitle("Submit", for: .normal)
            }
        }
        
        else if(name.text == "")
        {
            ref?.child("Support").childByAutoId().setValue([
            "message": message.text
            ])
            
            self.submitBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            submitBtn.setTitle("Success!", for: .normal)
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        else if(message.text == "")
        {
            self.submitBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            self.submitBtn.setTitle("Error!", for: .normal)
            self.submitBtn.shake()
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.submitBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
                self.submitBtn.setTitle("Submit", for: .normal)
            }
        }
        else
        {
            ref?.child("Support").child(name.text!).setValue([
            "message": message.text
            ])
            
            self.submitBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            submitBtn.setTitle("Success!", for: .normal)
            
            let sec = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + sec)
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)


        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        submitBtn.layer.add(animation, forKey: "shake")
    }
}
