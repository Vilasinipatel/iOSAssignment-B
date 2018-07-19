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
    var inValidImagePresent = false as Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.refreshControl = refreshCollectionController
        collectionView?.backgroundColor = UIColor.gray
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier:Constants.collectionViewReusableCellId)
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTheContentDetail()
    }
    lazy var refreshCollectionController: UIRefreshControl = {
        let  refreshController =  UIRefreshControl()
        refreshController.tintColor = UIColor.black
        refreshController.addTarget(self, action: #selector(refreshContentData), for: .valueChanged)
        return refreshController
    }()
    
    @objc func refreshContentData(){
        fetchTheContentDetail()
        refreshCollectionController.endRefreshing()
    }
    
    func fetchTheContentDetail(){
        if (Reachability.isConnectedToNetwork()){
        Alamofire.request(Constants.jsonUrl).responseString(completionHandler: {(response) in
            switch response.result{
            case.success(let value):
                let jsonContent =  JSON.init(parseJSON: value)
                let topicTitle = jsonContent[Constants.titleKey]
                self.contentData.removeAll()
                self.inValidImagePresent = false;
                for itemContent in jsonContent[Constants.rowsContentKey].arrayValue{
                    let item = JsonContentModel.init(json: itemContent) as JsonContentModel!
                    if(!(item?.title.isEmpty)!){
                        self.contentData.append(item!)
                    }
                }
                DispatchQueue.main.async {
                    self.navigationItem.title = topicTitle.stringValue
                    self.collectionView?.reloadData()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlertDialog(Constants.errorTitle, message: error.localizedDescription)
                }
                print(error.localizedDescription)
            }
        })
        }else{
            showAlertDialog(Constants.networkErrorMessageTitle, message: Constants.networkErrorMessage)
        }
    }
    
    func showAlertDialog(_ messageTitle: String,message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.okOptionText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
     func isValidUrl (urlString: String?) -> Bool {
        guard let urlString = urlString else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
       let regEx = Constants.urlRegex
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
    
    func getImageData(parameters: String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        getImagesDownloaded(parameters,completionHandler: completionHandler)
    }
    
   
    
    
    func getImagesDownloaded(_ imageUrl: String,completionHandler: @escaping (Data?, NSError?) -> ()){
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
        if(isValidUrl(urlString: contentData[indexPath.row].imageHref)){
            getImageData(parameters: contentData[indexPath.row].imageHref) { responseObject, error in
                if((responseObject) != nil){
                    collectionCell.thumbNailImageView.image = UIImage(data: responseObject!)
                }
            }
        }else{
            if(!self.inValidImagePresent){
                self.showAlertDialog(Constants.imageInvalidUrlMessageTitle, message: Constants.imageInvalidUrlMessage)
                self.inValidImagePresent = true
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

        let approximateViewWidth = view.frame.width;
        let approximateHeightImages = 200.0 as CGFloat
        let approximateWidthOfItemDesc = approximateViewWidth-20;
        let size = CGSize(width: approximateWidthOfItemDesc, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.descFont]
        let estimatedItemDescFrame = NSString(string: contentData[indexPath.row].description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    return CGSize(width: approximateViewWidth, height: estimatedItemDescFrame.height + approximateHeightImages + 70)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


