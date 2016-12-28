//
//  DragView.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

@objc protocol DragViewDelegate {
    
    @objc optional func dragViewEntered(_ dragView:DragView)
    @objc optional func dragViewExited(_ dragView:DragView)
    func dragView(_ dragView:DragView, didReciveURL url: URL)
    func dragView(_ dragView:DragView, didReciveURLs urls: [URL])
    
}

class DragView: NSView {

    var delegate: DragViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    // MARK: - Destination Operations
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
       if NSImage.canInit(with: sender.draggingPasteboard()) == true {
        
            let fileURL = NSURL(from: sender.draggingPasteboard()) as? URL
            
//            NSLog("test: \(fileURL?.lastPathComponent)")
            
            if fileURL?.lastPathComponent.hasSuffix(".png") == true ||
                fileURL?.lastPathComponent.hasSuffix(".jpg") == true ||
                fileURL?.lastPathComponent.hasSuffix(".jpeg") == true {
                self.delegate?.dragViewEntered?(self)
                return .copy
            }
       }
        
        return NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.delegate?.dragViewExited?(self)

    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        return true//NSImage.canInitWithPasteboard(sender.draggingPasteboard())
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {

        self.delegate?.dragViewExited?(self)
        
        //if let URL = NSURL(fromPasteboard: sender.draggingPasteboard()) {
       //     self.delegate?.dragView(self, didReciveURL: URL)
       // }
        
        if sender.draggingPasteboard().types?.contains(NSURLPboardType) == true {
            if let urls = sender.draggingPasteboard().readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
                self.delegate?.dragView(self, didReciveURLs: urls)
            }
        }
        
        return true
    }
    
}
