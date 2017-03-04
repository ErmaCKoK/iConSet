//
//  AssestsJSON.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 3/3/17.
//  Copyright © 2017 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class AssestsJSON: NSObject {
    
    var imageInfos = [ImageInfo]()
    
    convenience init(imageInfos: [ImageInfo]) {
        self.init()
        self.imageInfos = imageInfos
    }
    
    override init() {
        super.init()
    }
    
    func append(_ imageInfo: ImageInfo) {
        self.imageInfos.append(imageInfo)
    }
    
    func save(to folder: URL) {
        
        var json = [String: Any]()
        
        var images = [Any]()
        for index in (1...3) {
            
            var dic = ["idiom" : "universal", "scale" : "\(index)x"]
            
            if let imageInfo = self.imageInfos.first(where: { $0.scale == index }) {
                dic["filename"] = imageInfo.name
            }
            
            images.append(dic)
        }
        
        if images.count > 0 {
            json["images"] = images
        }
        
        json["info"] = ["version" : (1), "author" : "xcode"]
        
        let date = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        try! date.write(to: folder.appendingPathComponent("Contents.json"), options: [.atomic])
    }
    
}
