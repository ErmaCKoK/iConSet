//
//  NSURLExtension.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

extension NSURL {

    private var wholeName: String? {
        get {
            return self.lastPathComponent?.componentsSeparatedByString(".").first
        }
    }
    
    var name: String! {
        get {
            return self.wholeName?.componentsSeparatedByString("@").first
        }
    }
    
    var scale: Int? {
        get {
            var prefix = self.wholeName?.componentsSeparatedByString("@").last
            prefix = prefix?.stringByReplacingOccurrencesOfString("x", withString: "").stringByReplacingOccurrencesOfString("X", withString: "")
            if let p = prefix {
                return Int(p)
            }
            return nil
        }
    }
}
