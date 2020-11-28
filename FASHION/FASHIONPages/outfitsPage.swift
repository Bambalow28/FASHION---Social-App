//
//  outfitsPage.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-30.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class outfitsPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var outfits: [String] = []
    let userID = Auth.auth().currentUser?.uid
    
    //Makes status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Outfits"

        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        viewOutfits()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outfits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "closetItem") as! CustomTableViewCell
        
        cell.cellVIew.layer.cornerRadius = 4
        cell.itemName.textColor = UIColor.white
        
        cell.cellVIew.layer.shadowColor = UIColor.black.cgColor
        cell.cellVIew.layer.shadowOpacity = 1
        cell.cellVIew.layer.shadowOffset = .zero
        cell.cellVIew.layer.shadowRadius = 2
        
        cell.itemImage.layer.cornerRadius =  cell.itemImage.frame.height/2
        
        
        cell.itemName?.text = outfits[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == .delete){
            
            let outfitID = outfits[indexPath.row]
            
            ref.child("users").child(userID!).child("Outfits").child(outfitID).removeValue()
            self.outfits.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
//            let desertRef = storage.child("images").child(itemsID)
//
//            // Delete the file
//            desertRef.delete { error in
//                if error != nil {
//                    print("Oops! Something Went Wrong!")
//                } else {
//                    print("Success! Photo Deleted!")
//                }
            }
            
            self.tableView.reloadData()
            
        }
    
    @IBAction func homeBtnClicked(_ sender: Any) {
        transitionToHome()
    }
    @IBAction func closetMenuClicked(_ sender: Any) {
        transitionToClosetMenu()
    }
    @IBAction func addPostClicked(_ sender: Any) {
        transitionToPost()
    }
    @IBAction func weatherClicked(_ sender: Any) {
        transitionToWeather()
    }
    @IBAction func userProfileClicked(_ sender: Any) {
        transitionToProfile()
    }
    @IBAction func backToRoot(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func viewOutfit(_ sender: Any) {
        transitionToViewOutfit()
    }
    
    @IBAction func createOutfit(_ sender: Any) {
        transitionToAddOutfit()
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
    
    func transitionToViewOutfit() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "viewOutfits") as! viewOutfits

        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func transitionToAddOutfit() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addOutfitController = storyBoard.instantiateViewController(withIdentifier: "addOutfit") as! addOutfit

        self.navigationController?.pushViewController(addOutfitController, animated: true)
    }
    
    func viewOutfits() {
        //Retrieve Data from DB
        ref?.child("users").child(userID!).child("Outfits").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects as! [DataSnapshot]
            {
                self.outfits.append(child.key)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }
        })
    }

}

extension outfitsPage: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        @unknown default:
            print("Oops!")
        }
    }
}
