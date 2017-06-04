//
//  SignUpViewController.swift
//  Amigos
//
//  Created by amarjit singh on 5/29/17.
//  Copyright © 2017 amarjit singh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
   
    @IBOutlet weak var confirmPassField: UITextField!
    
    @IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var firDatabase: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        let storage = FIRStorage.storage().reference(forURL: "gs://amigos-947c3.appspot.com")
        firDatabase = FIRDatabase.database().reference()
        
        userStorage = storage.child("users")

        // Do any additional setup after loading the view.
    }
   
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        guard nameField.text != "", emailField.text != "", passwordField.text != "",  confirmPassField.text != "" else{
            print("All fields must be filled before proceeding")
            return
        }
        if passwordField.text == confirmPassField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.nameField.text
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageField.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, uploadError) in
                        if uploadError != nil{
                            print(uploadError!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, urlError) in
                            if urlError != nil{
                                print(urlError!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo : [String : Any] = ["uid" : user.uid,
                                                               "full name" : self.nameField.text!,
                                                               "urlToImage" : url.absoluteString]
                                
                                self.firDatabase.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                
                                self.present(vc, animated: true, completion:nil)                             }
                            
                            
                        })
                        
                    })
                    
                    uploadTask.resume()
                }
            })
        }else{
            print("password does not match")
        }
    }
    
    @IBAction func selectPictureBtnPressed(_ sender: UIButton) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageField.image = image
            nextBtn.isHidden = false
 
        }
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
