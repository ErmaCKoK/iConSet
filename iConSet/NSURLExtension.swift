//
//  NSURLExtension.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

extension URL {

    private var wholeName: String? {
        return self.lastPathComponent.components(separatedBy: ".").first
    }
    
    var name: String! {
        return self.wholeName?.components(separatedBy: "@").first
    }
    
    var scale: Int? {
        var prefix = self.wholeName?.components(separatedBy: "@").last
        prefix = prefix?.replacingOccurrences(of: "x", with: "").replacingOccurrences(of: "X", with: "")
        if let p = prefix {
            return Int(p)
        }
        return nil
    }
}
