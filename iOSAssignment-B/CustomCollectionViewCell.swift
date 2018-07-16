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
        let itemNameDetail = UILabel()
        itemNameDetail.font = UIFont.titleFont
        itemNameDetail.backgroundColor = UIColor.white
        itemNameDetail.translatesAutoresizingMaskIntoConstraints = false
        return itemNameDetail
    }()
    
    let thumbNailImageView: UIImageView = {
        let imageContent  = UIImageView()
        imageContent.translatesAutoresizingMaskIntoConstraints = false
        return imageContent
    }()
    
    let itemDescription: UILabel = {
        let itemDesc  = UILabel()
        itemDesc.font = UIFont.descFont
        itemDesc.numberOfLines = 0
        itemDesc.translatesAutoresizingMaskIntoConstraints = false
        return itemDesc
    }()
    
    let separatorLineView: UIView = {
        let separatorLine  = UIView()
        separatorLine.backgroundColor = UIColor.black
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        return separatorLine
    }()
    func SetUpViews(){
        backgroundColor = UIColor.white
        addSubview(itemName)
        addSubview(thumbNailImageView)
        addSubview(itemDescription)
        addSubview(separatorLineView)
        addConstraintsWithTheFormat(format:"H:|-10-[v0]-10-|", views: itemName)
        addConstraintsWithTheFormat(format:"H:|-10-[v0(150)]-10-|", views:thumbNailImageView)
        addConstraintsWithTheFormat(format:"H:|-10-[v0]-10-|", views:itemDescription)
        addConstraintsWithTheFormat(format:"H:|[v0]|", views:separatorLineView)
        addConstraintsWithTheFormat(format:"V:|-10-[v0(20)]-10-[v1(150)]-10-[v2]-10-[v3(1)]|", views: itemName,thumbNailImageView,itemDescription,separatorLineView)
        
    }
}
extension UIView{
    func addConstraintsWithTheFormat(format: String,views: UIView...) {
        var viewDict = [String: UIView]()
        for (index,view) in views.enumerated()
        {
            let key = "v\(index)"
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views:viewDict))    }
}
