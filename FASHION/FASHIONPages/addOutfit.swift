//
//  addOutfit.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-11-18.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import UIKit
import Firebase

class addOutfit: UIViewController {
    
    @IBOutlet weak var outfitName: UITextField!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var botBtn: UIButton!
    @IBOutlet weak var shoesBtn: UIButton!
    @IBOutlet weak var accessoriesBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    let userID = Auth.auth().currentUser?.uid
    
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Outfit"
        
        ref = Database.database().reference()
        
        topBtn.layer.cornerRadius = 10
        topBtn.layer.masksToBounds = false
        topBtn.layer.cornerRadius = 10
        topBtn.layer.shadowColor = UIColor.black.cgColor
        topBtn.layer.shadowOpacity = 0.5
        topBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        topBtn.layer.shadowRadius = 8
        
        botBtn.layer.cornerRadius = 10
        botBtn.layer.masksToBounds = false
        botBtn.layer.cornerRadius = 10
        botBtn.layer.shadowColor = UIColor.black.cgColor
        botBtn.layer.shadowOpacity = 0.5
        botBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        botBtn.layer.shadowRadius = 8
        
        shoesBtn.layer.cornerRadius = 10
        shoesBtn.layer.masksToBounds = false
        shoesBtn.layer.cornerRadius = 10
        shoesBtn.layer.shadowColor = UIColor.black.cgColor
        shoesBtn.layer.shadowOpacity = 0.5
        shoesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        shoesBtn.layer.shadowRadius = 8
        
        accessoriesBtn.layer.cornerRadius = 10
        accessoriesBtn.layer.masksToBounds = false
        accessoriesBtn.layer.cornerRadius = 10
        accessoriesBtn.layer.shadowColor = UIColor.black.cgColor
        accessoriesBtn.layer.shadowOpacity = 0.5
        accessoriesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        accessoriesBtn.layer.shadowRadius = 8
    }
    
    @IBAction func topBtnClicked(_ sender: Any) {
        topBtn.layer.backgroundColor = CGColor(red: 231.0/255.0, green: 84.0/255.0, blue: 128.0/255.0, alpha: 1.0)

    }
    
    @IBAction func bottomClicked(_ sender: Any) {
        topBtn.layer.backgroundColor = CGColor(red: 231.0/255.0, green: 84.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    }
    
    @IBAction func shoesClicked(_ sender: Any) {
        topBtn.layer.backgroundColor = CGColor(red: 231.0/255.0, green: 84.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    }
    
    @IBAction func accessoriesClicked(_ sender: Any) {
        topBtn.layer.backgroundColor = CGColor(red: 231.0/255.0, green: 84.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    }
    
    @IBAction func homeClicked(_ sender: Any) {
        transitionToHome()
    }
    
    @IBAction func closetMenuClicked(_ sender: Any) {
        transitionToClosetMenu()
    }
    
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    
    @IBAction func profileClicked(_ sender: Any) {
        transitionToProfile()
    }
    
    @IBAction func addPostClicked(_ sender: Any) {
        transitionToPost()
    }
    
    @IBAction func createBtnClicked(_ sender: Any) {
        createOutfit()
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func transitionToHome() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainHome") as! mainHome
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToClosetMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "closetMenu") as! closetMenu
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToWeather() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "weatherHome") as! weatherHome
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToProfile() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "userProfile") as! userProfile
        
        let navController = UINavigationController(rootViewController: newViewController)
        
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func transitionToPost() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "makePosts") as! makePosts
        
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func createOutfit() {

        if outfitName.text == "" {
            createBtn.setTitle("Error!", for: .normal)
            createBtn.layer.backgroundColor = UIColor.systemRed.cgColor
            
            let sec = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.createBtn.setTitle("Create", for: .normal)
                self.createBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            }
        }
        else {
            //Firebase Saving
            self.ref?.child("users").child(userID!).child("Outfits").child(self.outfitName.text!).setValue([
                "outfitName": self.outfitName.text!
            ])
            
            createBtn.setTitle("Created!", for: .normal)
            createBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            
            let sec = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                self.createBtn.setTitle("Create", for: .normal)
                self.createBtn.layer.backgroundColor = UIColor.systemGreen.cgColor
            }
        }
    }
    
}
