//
//  LoginViewController.swift
//  Amigos
//
//  Created by amarjit singh on 6/3/17.
//  Copyright © 2017 amarjit singh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmailField: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard loginEmailField.text != nil else {return}
        guard loginPasswordField.text != nil else {return}
        
        FIRAuth.auth()?.signIn(withEmail: loginEmailField.text!, password: loginPasswordField.text!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                
                self.present(vc, animated: true, completion: nil)
            }
            
        })
        
        
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
