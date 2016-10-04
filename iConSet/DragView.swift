//
//  DragView.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

@objc protocol DragViewDelegate {
    
    optional func dragViewEntered(dragView:DragView)
    optional func dragViewExited(dragView:DragView)
    func dragView(dragView:DragView, didReciveURL url: NSURL)
    func dragView(dragView:DragView, didReciveURLs urls: [NSURL])
    
}

class DragView: NSView {

    var delegate: DragViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.registerForDraggedTypes([NSFilenamesPboardType])
    }
    
    // MARK: - Destination Operations
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        
       if NSImage.canInitWithPasteboard(sender.draggingPasteboard()) == true {
            let fileURL = NSURL(fromPasteboard: sender.draggingPasteboard())
            
//            NSLog("test: \(fileURL?.lastPathComponent)")
            
            if fileURL?.lastPathComponent?.hasSuffix(".png") == true ||
                fileURL?.lastPathComponent?.hasSuffix(".jpg") == true ||
                fileURL?.lastPathComponent?.hasSuffix(".jpeg") == true {
                self.delegate?.dragViewEntered?(self)
                return .Copy
            }
       }
        
        return .None
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        self.delegate?.dragViewExited?(self)

    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        
        return true//NSImage.canInitWithPasteboard(sender.draggingPasteboard())
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {

        self.delegate?.dragViewExited?(self)
        
        //if let URL = NSURL(fromPasteboard: sender.draggingPasteboard()) {
       //     self.delegate?.dragView(self, didReciveURL: URL)
       // }
        
        if sender.draggingPasteboard().types?.contains(NSURLPboardType) == true {
            if let urls = sender.draggingPasteboard().readObjectsForClasses([NSURL.self], options: nil) as? [NSURL] {
                self.delegate?.dragView(self, didReciveURLs: urls)
            }
        }
        
        return true
    }
    
}
