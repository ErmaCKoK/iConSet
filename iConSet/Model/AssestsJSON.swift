//
//  AssestsJSON.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 3/3/17.
//  Copyright © 2017 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class AssestsJSON: NSObject {
    
    var json: [String: Any]
    
    override init() {
        self.json = [String: Any]()
        super.init()
    }
    
    func append(_ imageInfo: ImageInfo) {
        var images: [Any]
        
        if let array = json["images"] as? [Any] {
            images = array
        } else {
            images = [Any]()
        }
        
        images.append(["idiom" : "universal", "filename" : imageInfo.name, "scale" : "\(imageInfo.scale)x"])
        json["images"] = images
    }
    
    func save(to folder: URL) {
        
        json["info"] = ["version" : (1), "author" : "xcode"]
        
        let date = try! JSONSerialization.data(withJSONObject: self.json, options: JSONSerialization.WritingOptions.prettyPrinted)
        try! date.write(to: folder.appendingPathComponent("Contents.json"), options: [.atomic])
    }
    
}
