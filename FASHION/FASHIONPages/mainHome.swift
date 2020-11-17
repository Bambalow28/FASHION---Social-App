//
//  mainHome.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-07-25.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class mainHome: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let fetchUser = fetchUserPost()
    let userID = Auth.auth().currentUser?.uid

    var userPost = [fetchUserPost]()
    var urlString: URL?
    var refreshControl = UIRefreshControl()
    var ref: DatabaseReference!
    private let storage = Storage.storage().reference()
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        
//        navigationItem.titleView = UIImageView(image: UIImage(named: "AppLogo"))
        
        title = "News Feed"
        
        let nib = UINib(nibName: "SocialMediaCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SocialMediaCell")

        self.tableView.separatorStyle = .none
        
        fetchUsers()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userPost.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
        
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
        
        let user = userPost[indexPath.row]
        
        addPosts(cell, at: indexPath)

        if let imageID = user.userID {
            let postImageName = cell.postCaption.text!
            let imageShow: UIImageView = cell.postImage
            let storageRef = self.storage.child("images").child(imageID).child("Posts").child(postImageName)

            //DownloadURL to cache image
            storageRef.downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }

                let urlStringCheck = url.absoluteString
                UserDefaults.standard.set(urlStringCheck, forKey: "url")

                self.urlString = URL(string: urlStringCheck)
                imageShow.sd_setImage(with: storageRef)
            })
        }
        else {
            print("Error")
        }
        
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    func addPosts(_ cell: SocialMediaCell, at indexPath: IndexPath)
    {
        let user = userPost[indexPath.row]
        
        cell.postCaption?.text = user.postCaption
        cell.username?.text = user.username
        cell.timePosted?.text = user.timePosted
    }
    

    //Toolbar Controls
    @IBAction func homeBtnClicked(_ sender: Any) {
        transitionToHome()
    }
    @IBAction func closetHome(_ sender: Any) {
        transitionToClosetMenu()
    }
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    @IBAction func userProfileClicked(_ sender: Any) {
        transitionToProfile()
    }
    @IBAction func addPostClicked(_ sender: Any) {
        transitionToPost()
    }
    
    func fetchUsers(){
        //Retrieve Data from DB
        ref?.child("posts").observe(.childAdded, with: { (snapshot) in
            
            for each in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let dictionary = each.value as? [String: AnyObject] {

                    let user = fetchUserPost()
                    user.username = dictionary["username"] as? String
                    user.postCaption = dictionary["captionTxt"] as? String
                    user.userID = dictionary["userID"] as? String
                    user.timePosted = dictionary["timePosted"] as? String
                    self.userPost.append(user)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
 
        })
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
}
