//
//  NumberToBoolTransformer.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/26/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class NumberToBoolTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let number = value as? NSNumber {
            return number.boolValue
        }
        
        if let boolValue = value as? Bool {
            return NSNumber(value: boolValue)
        }
        
        return nil
    }
}
