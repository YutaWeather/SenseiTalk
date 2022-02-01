//
//  STNewsTableViewCell.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/31.
//

import UIKit
import SDWebImage

protocol TapCollectionViewCell{
    
    func tapCollectionViewCell(indexPath:IndexPath)
    
}

class STNewsTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let flowLayout = UICollectionViewFlowLayout()

    static let identifier = "STNewsTableViewCell"

    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var urlToImageView = STImageView(frame: .zero)
    var articles:[Article] = [Article]()
    let newsManager = STNewsManager()
    var collectionView:UICollectionView?
    var tapCollectionViewCell:TapCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(indexPath:IndexPath,articles:[Article],categoryArticles:[Article]){
        
        switch indexPath.row{
        case 0:
            self.articles = articles
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView?.register(STNewsCollectionViewCell.self, forCellWithReuseIdentifier: STNewsCollectionViewCell.identifier)
            collectionView!.delegate = self
            collectionView!.dataSource = self

            let size = collectionView!.frame.height
            flowLayout.scrollDirection = .horizontal // 横スクロール
            flowLayout.itemSize = CGSize(width: size, height: size)
            collectionView!.collectionViewLayout = flowLayout
            self.contentView.addSubview(collectionView!)
            layoutCollectionView()

        default:
            urlToImageView.sd_setImage(with: URL(string: categoryArticles[indexPath.row - 1].urlToImage!))
            titleLabel.text = categoryArticles[indexPath.row - 1].title
            layoutUIForNews()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapCollectionViewCell?.tapCollectionViewCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.height
        
        return CGSize(width: size*2.5, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: STNewsCollectionViewCell.identifier, for: indexPath) as! STNewsCollectionViewCell
        
        for subview in cell.contentView.subviews{
              subview.removeFromSuperview()
        }
        
        cell.urlToImageView.image = nil
        cell.titleLabel.text = nil
        cell.configure(article: self.articles[indexPath.item])
        return cell
        
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func layoutCollectionView(){

        collectionView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            collectionView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView!.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        ])

    }
    
    func layoutUIForNews(){
        
        addSubview(urlToImageView)
        addSubview(titleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 200),
            urlToImageView.heightAnchor.constraint(equalToConstant: 100),


            titleLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding)

        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
