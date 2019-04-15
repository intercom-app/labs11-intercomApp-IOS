//
//  ProfileEditController.swift
//  Intercom App
//
//  Created by Lotanna Igwe-Odunze on 3/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ProfileEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Properties
    var updatedImage: UIImage?
    var pulledUser: Users?

    //Outlets
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    @IBOutlet weak var firstnameField: UITextField!
    
    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    //Actions
    @IBAction func choosePhotoClicked(_ sender: UIButton) {
        
        //Check if there's even a photo library.
        guard UIImagePickerController.isSourceTypeAvailable (.photoLibrary) else {
            NSLog("The photo library is unavailable")
            return }
        
        //Initiate the Image Picker.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self //Set the delegate
        imagePicker.sourceType = .photoLibrary
        
        //Display the image picker on the screen.
        present(imagePicker, animated: true, completion: nil)
    }
    
    //What happens when an image is successfully selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        //set the picked image to your class property for use
        updatedImage = info[.originalImage] as? UIImage
        
        profilePhotoView.image = updatedImage
    }
    
    //What happens if the user cancels picking an image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Just dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //What happens when the user clicks save
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        
        UserManager.shared.localUser?.displayName = usernameField.text ?? pulledUser!.displayName
        UserManager.shared.localUser?.firstName = firstnameField.text
        UserManager.shared.localUser?.lastName = lastnameField.text
        UserManager.shared.localUser?.email = emailField.text ?? pulledUser?.email
        UserManager.shared.localUser?.phoneNumber = Int(phoneField.text!)
        UserManager.shared.localUser?.photo = updatedImage
        
        navigationController?.popViewController(animated: true)
        

        
    }
    
    
    
}
