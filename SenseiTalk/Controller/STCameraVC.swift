//
//  STCameraVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/12.
//

import UIKit


class STCameraVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.showsCameraControls = true
            self.present(cameraPicker, animated: true, completion: nil)
         }
    }
    
    func openAlubum(){
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        if let pickedImage = info[.editedImage] as? UIImage
//        {
//            imageView.image = pickedImage
//            picker.dismiss(animated: true, completion: nil)
//            
//        }
//
//        
//    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openActionSheet(){
        let alert = UIAlertController(title: "選択してください。", message:"", preferredStyle:.actionSheet)
        
        // アクションを生成.
        let camera = UIAlertAction(title: "カメラ", style:.default, handler: {
            (action: UIAlertAction!) in
            
            self.openCamera()
        })
        
        let album = UIAlertAction(title: "アルバム", style:.default, handler: {
            (action: UIAlertAction!) in
            self.openAlubum()
        })
        // アクションを追加.
        alert.addAction(camera)
        alert.addAction(album)
        
        self.present(alert, animated: true, completion: nil)
    }

}

