//
//  MainCollectionViewController.swift
//  iOSAssignment-B
//
//  Created by Villasini Patel on 14/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MainCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var contentData = [JsonContentModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.refreshControl = refreshCollectionController
        collectionView?.backgroundColor = UIColor.gray
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier:Constants.collectionViewReusableCellId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchTheContentDetail()
    }
    lazy var refreshCollectionController: UIRefreshControl = {
        let  refreshController =  UIRefreshControl()
        refreshController.tintColor = UIColor.black
        refreshController.addTarget(self, action: #selector(refreshContentData), for: .valueChanged)
        return refreshController
    }()
    
    @objc func refreshContentData(){
        FetchTheContentDetail()
        refreshCollectionController.endRefreshing()
    }
    
    func FetchTheContentDetail(){
        if Reachability.isConnectedToNetwork(){
        Alamofire.request(Constants.jsonUrl).responseString(completionHandler: {(response) in
            switch response.result{
            case.success(let value):
                let jsonContent =  JSON.init(parseJSON: value)
                let topicTitle = jsonContent[Constants.titleKey]
                self.navigationItem.title = topicTitle.stringValue
                self.contentData.removeAll()
                for array in jsonContent[Constants.rowsContentKey].arrayValue{
                    self.contentData.append(JsonContentModel.init(json: array))
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
        }else{
            ShowAlertDialog(Constants.networkErrorMessageTitle, message: Constants.networkErrorMessage)
        }
    }
    
    func ShowAlertDialog(_ messageTitle: String,message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.okOptionText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func GetImageData(parameters: String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        GetImagesDownloaded(parameters,completionHandler: completionHandler)
    }
    
    func GetImagesDownloaded(_ imageUrl: String,completionHandler: @escaping (Data?, NSError?) -> ()){
        Alamofire.request(imageUrl)
            .validate().responseData(completionHandler:{data in
                switch data.result {
                case .success:
                    completionHandler(data.data, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)

                    print(error.localizedDescription)
                    break
                }
        })
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.collectionViewReusableCellId, for: indexPath) as! CustomCollectionViewCell
        collectionCell.itemName.text =  contentData[indexPath.row].title
        collectionCell.itemDescription.text = contentData[indexPath.row].description
        collectionCell.thumbNailImageView.image = #imageLiteral(resourceName: "PlaceHolder")
        GetImageData(parameters: contentData[indexPath.row].imageHref) { responseObject, error in
            if((responseObject) != nil){
                collectionCell.thumbNailImageView.image = UIImage(data: responseObject!)
            }
        }
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfItemDesc = view.frame.width-20;
        let size = CGSize(width: approximateWidthOfItemDesc, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        let estimatedItemDescFrame = NSString(string: contentData[indexPath.row].description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: view.frame.width, height: estimatedItemDescFrame.height + 220)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



