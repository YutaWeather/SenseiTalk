//
//  STLoginVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import Firebase

class STLoginVC: STCameraVC,DoneSend {

    var profileImageView = STImageView(frame: .zero, image: UIImage(named: "avatar-placeholder")!)
    var userNameTextField = STTextField(textAlignment: .left, fontSize: 10)
    var createUserButton = STButton(backgroundColor: .systemBlue, title: "登録する")
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func layoutUI(){
        
        let padding:CGFloat = 50
        view.addSubview(profileImageView)
        view.addSubview(userNameTextField)
        view.addSubview(createUserButton)
        
        profileImageView.isUserInteractionEnabled = true

        createUserButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        NSLayoutConstraint.activate([
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -padding*2),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            userNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: padding),
            userNameTextField.heightAnchor.constraint(equalToConstant: 20),
            
            createUserButton.leadingAnchor.constraint(equalTo: userNameTextField.leadingAnchor,constant: padding),
            createUserButton.trailingAnchor.constraint(equalTo: userNameTextField.trailingAnchor,constant: -padding),
            createUserButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: padding),
            createUserButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
    }
    
    func configure(){
        
        view.backgroundColor = .systemYellow
        layoutUI()
        
    }
    
    @objc func register(){
        
        //firebase
        Auth.auth().signInAnonymously { (result, error) in
            let sendDBModel = STSendDBModel()
            sendDBModel.doneSend = self
            sendDBModel.sendProfileData(userName: self.userNameTextField.text!, profileImageData: (self.profileImageView.image?.jpegData(compressionQuality: 0.3))!)
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){

        openActionSheet()
    }
    
    func doneSendData() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            profileImageView.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
    }

}
