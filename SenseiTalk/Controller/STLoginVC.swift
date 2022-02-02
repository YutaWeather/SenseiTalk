//
//  STLoginVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import Firebase
import Lottie

class STLoginVC: STCameraVC,DoneSend {

    var profileImageView = STImageView(frame: .zero, image: UIImage(named: "avatar-placeholder")!)
    var userNameTextField = STTextField(textAlignment: .left, fontSize: 10)
    var createUserButton = STButton(backgroundColor: .systemBlue, title: "登録する")
    var tapGesture = UITapGestureRecognizer()
    var introScrollView = UIScrollView()
    let loadingView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIntroView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        introScrollView.frame = view.frame
    }
    
    func configureIntroView(){

        introScrollView.backgroundColor = .white
        introScrollView.isPagingEnabled = true
        introScrollView.contentSize = CGSize(width: view.frame.size.width * 4, height: view.frame.size.height)
        introScrollView.frame = view.frame
        view.addSubview(introScrollView)

        for i in 0...3{
            let onboardLabel = STTitleLabel(textAlignment: .center, fontSize: 20)
            onboardLabel.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height - 150, width: view.frame.size.width, height: 30)
            onboardLabel.text = STConstLottie.onboardStringArray[i]

            let animationView = AnimationView()
            let animation = Animation.named("\(STConstLottie.onboardFileArray[i])")
            animationView.frame = CGRect(x: CGFloat(i) * self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()

            introScrollView.addSubview(animationView)
            introScrollView.addSubview(onboardLabel)
            
            if i == 3{
                let startButton = STButton(backgroundColor: .systemBlue, title: "はじめる")
                startButton.frame = CGRect(x:CGFloat(i) * self.view.frame.size.width + view.frame.size.width/4, y: onboardLabel.frame.origin.y + 50, width: view.frame.size.width/2, height: 50)
                startButton.addTarget(self, action: #selector(startTap), for: .touchUpInside)
                introScrollView.addSubview(startButton)
            }
        }

    }
    
    @objc func startTap(){
        
        self.introScrollView.removeFromSuperview()
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
       
        let animation = Animation.named("load")

        loadingView.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.5
        loadingView.animation = animation
        loadingView.contentMode = .scaleAspectFit
        loadingView.loopMode = .loop
        view.addSubview(loadingView)
        loadingView.play()
        
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
        loadingView.removeFromSuperview()
        dismiss(animated: true, completion: nil)
       
    }
    
    func createTopMenuNav() -> UINavigationController{
        let pageVC = PageViewController()
        let nav = UINavigationController(rootViewController: pageVC)
        nav.tabBarItem = UITabBarItem(title: "タイムライン", image:UIImage(named: ""), tag: 0)
        return nav
    }

    func createTopMenuNav2() -> UINavigationController{
        let newsVC = STNewsVC()
        let nav = UINavigationController(rootViewController: newsVC)
        nav.tabBarItem = UITabBarItem(title: "ニュース", image:UIImage(named: ""), tag: 1)
        return nav
    }

    func createTopMenuNav3() -> UINavigationController{
        let profileVC = STProfileVC()
        let nav = UINavigationController(rootViewController: profileVC)
        nav.tabBarItem = UITabBarItem(title: "プロフィール", image:UIImage(named: ""), tag: 2)
        return nav
    }

    
    func createTabbar() -> UITabBarController{
        
        let tabbar = UITabBarController()
        tabbar.tabBar.backgroundColor = .white
        tabbar.viewControllers = [createTopMenuNav(),createTopMenuNav2(),createTopMenuNav3()]
        
        return tabbar
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            profileImageView.image = pickedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
    }

}
