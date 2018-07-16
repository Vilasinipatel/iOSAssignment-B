//
//  JsonContentModel.swift
//  iOSAssignment-B
//
//  Created by Villasini Patel on 15/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JsonContentModel{
    var title: String = ""
    var description: String = ""
    var imageHref: String = ""
    
    init(json: JSON) {
        title = json[Constants.titleKey].stringValue
        description = json[Constants.itemDescKey].stringValue
        imageHref = json[Constants.itemImageRef].stringValue
    }
    
}


