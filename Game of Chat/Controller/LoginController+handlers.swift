//
//  LoginController+handlers.swift
//  Game of Chat
//
//  Created by Felix Lin on 10/15/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is invalid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            
            // successfully authenticated user
            let storageRef = Storage.storage().reference().child("/images/\(uid).png")
            if let uploadData = self.profileImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        let profilePicUrl = url?.absoluteString
                        let values = ["name": name, "email": email, "profileImageUrl": profilePicUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    })
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
