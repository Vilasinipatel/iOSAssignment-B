//
//  CustomCollectionViewCell.swift
//  
//
//  Created by Villasini Patel on 14/07/18.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let itemName: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.text = "myText"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageContent = UIImageView()
        imageContent.image = UIImage.init(named: "PlaceHolder")
        imageContent.translatesAutoresizingMaskIntoConstraints = false
        return imageContent
        
    }()
    
    func SetUpViews(){
        addSubview(itemName)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":itemName]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":itemName]))
         addSubview(imageView)
        
    }
}
