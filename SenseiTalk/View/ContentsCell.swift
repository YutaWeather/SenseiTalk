//
//  ContentsCell.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import SDWebImage

class ContentsCell: UITableViewCell {

    static let identifier = "ContentsCell"
    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var subTitleLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    var urlToImageView = STImageView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(newsContentsModel:NewsContentsModel){
        urlToImageView.sd_setImage(with: URL(string: newsContentsModel.urlToImage!))
        titleLabel.text = newsContentsModel.title
        
        layoutUI()
    }

    func layoutUI(){
        addSubview(urlToImageView)
        addSubview(titleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 50),
            urlToImageView.heightAnchor.constraint(equalToConstant: self.frame.height - padding),
       

            titleLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),

        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
