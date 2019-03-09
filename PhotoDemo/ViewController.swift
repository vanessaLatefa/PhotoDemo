//
//  ViewController.swift
//  PhotoDemo
//
//  Created by Vanessa Latefa Pampilo on 3/5/19.
//  Copyright © 2019 Vanessa Latefa Pampilo. All rights reserved.
//

import UIKit
import MessageUI


//NavConDelegate is to allow the app to navigate with our app to the other app
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var myTextField: UITextField!
    
    
    @IBOutlet weak var addTextButton: UIButton!
    
    @IBOutlet weak var sendMailButton: UIButton!
    
    
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        myTextField.delegate = self
       
    }

    //completion  means executed when it finishes its task
    @IBAction func capturePressed(_ sender: Any) {
        print("capture pressed")
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ myTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    //this is gonna call this method when you finished capturing the image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
             print("received image \(image.size)")
            
            //TO DO : display the image
            imageView.image = image.resizeImage(newWidth: 100)
            
        }
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addText(_ sender: Any) {
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: imageView.bounds)
        
        let attributes : [NSAttributedString.Key : Any] =
            [
                .font : UIFont.systemFont(ofSize: 50.0),
                .foregroundColor : UIColor.black,
                    .backgroundColor : UIColor.white
        ]

        var addedText : String = myTextField.text!
        
        let string = NSAttributedString(string: addedText, attributes: attributes)
        string.draw(at: CGPoint(x: 50, y: 100))
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    
    
    @IBAction func sendMailPressed(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail(){
            let mailVC = MFMailComposeViewController()
            
            mailVC.mailComposeDelegate = self
            
            mailVC.setToRecipients(["dan.nielsen2006@gmail.com"])
            mailVC.setSubject("Image to you !!")
            mailVC.setMessageBody("Hello there!", isHTML: false)
            
            let image = imageView.image?.resizeImage(newWidth: 150)
            //let imageData = image?.pngData()! as! NSData
            //mailVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "image.png")
       
            if let imageD = image?.pngData(){
                let imageData = imageD as NSData
                mailVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "image.png")
                
                
            }
            self.present(mailVC,animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage{
    
    func resizeImage(newWidth : CGFloat) -> UIImage{
        
        let newHeight = newWidth * ( self.size.height / self.size.width )
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        self.draw(in : CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}


