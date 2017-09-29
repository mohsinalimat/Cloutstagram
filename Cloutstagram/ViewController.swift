//
//  ViewController.swift
//  Cloutstagram
//
//  Created by sana on 2017-09-27.
//  Copyright © 2017 sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Make profile picture button
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        
        return button
    }()
    
    // Email text field
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        
        // Detect if form is filled out properly
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    // Username text field
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        
        // Detect if form is filled out properly
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    // Password text field
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true // For passwords
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        
        // Detect if form is filled out properly
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    // Signup button
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244) // Made our own method to set up colours better        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        // Action
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        // Disable button initially
        button.isEnabled = false
        
        return button
    }()
    
    // Check if user added a picture
    @objc func handlePlusPhoto() {
        
        // Image picker pull up picture selector
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // User picked a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        // If user edits the image or if user just uses the original picture
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            // Set profile picture default to the edited image
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            // Set profile picture default to the original image
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        // Make picture round after selecting with it's bounds
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 1
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // Check if text inputs were changed
    @objc func handleTextInputChange() {
        
        // Are the text fields empty
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        // Change button colour and ability
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleSignUp() {
        
        // Guard statement handling sign up
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            // If there was an error
            if let err = error {
                print("Failed to create user: " , err)
                return
            }
            
            // Succesffuly made a user
            print("Succesffuly created user: ", user?.uid ?? "")
        
            // Store profile picture chosen into the profile image child
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            // Give each picture a unique number
            let fileName = NSUUID().uuidString
            
            Storage.storage().reference().child("profile_image").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image: ", err)
                    return
                }
                
                // Grab the successfully uploaded picture
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                // Display it on console for tesing
                print("Successfully uploaded profile image :", profileImageUrl)
                
                // Save user information into DB
                guard let uid = user?.uid else { return }
                
                // User dictionary of values for DB
                let dictValues = ["username": username, "profileImageUrl": profileImageUrl] // Username values dictionary
                
                let values = [uid: dictValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save user info into DB: ", err)
                        return
                    }
                    
                    print("Successfully saved user info into DB!")
                    
                })
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add button to the screen
        view.addSubview(plusPhotoButton)
        
        // Anchor the plus button
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        // Constraint for Photo button
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        // Will load the input fields onto the screen
        setupInputFields()
    }
    
    // Setting up the screen information
    fileprivate func setupInputFields() {
        
        // Stack view containing all elements for signing up
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually // Allow all elems in stack view to take up equal space
        stackView.axis = .vertical // Order the elements in vertical order
        stackView.spacing = 10 // Space out 10 pixels
        
        // Add all in stackview onto the screen
        view.addSubview(stackView)
        
        // Anchoring
         stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
    }
}

extension UIView {
    
    // Making an anchoring extension
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}
