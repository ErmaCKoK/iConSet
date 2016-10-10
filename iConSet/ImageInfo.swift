//
//  ImageInfo.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class ImageInfo: NSObject {
    
    private var folder: String
    private var URL: NSURL
    private var imageSize: BitmapImageSize
    private var isJPG: Bool
    
    var scale: Int
    
    var size: BitmapImageSize {
        get {
            return BitmapImageSize(width: imageSize.width * scale, height: imageSize.height * scale)
        }
    }
    
    var path: NSURL {
        get {
            let folder = self.URL.URLByDeletingLastPathComponent!
            
            let fileName = self.URL.name//.componentsSeparatedByString("_").last ?? "UNKNOW"
            
            let pref = scale == 1 ? "" : "@\(scale)x"
            let typeFyle = self.isJPG ? "jpg" :"png"
            return folder.URLByAppendingPathComponent(self.folder)!.URLByAppendingPathComponent("\(fileName)\(pref).\(typeFyle)")!
        }
    }
    
    init(URL: NSURL, scale: Int, imageSize: BitmapImageSize, folder: String, isJPG: Bool) {
        
        self.URL = URL
        self.scale = scale
        self.imageSize = imageSize
        self.folder = folder
        self.isJPG = isJPG
        
        super.init()
    }
    
    func drawImage(image: NSImage) -> NSImage {
        
        let size = NSSize(width: self.size.width, height: self.size.height)
        let sourceImage = image;
        
        let newImage = NSImage(size: size) //[[NSImage alloc] initWithSize:targetSize];
        newImage.lockFocus()
        
        var rect = NSRect()
        
        rect.size = size
        
        sourceImage.size = size
        NSGraphicsContext.currentContext()?.imageInterpolation = NSImageInterpolation.High
        
        sourceImage.drawInRect(rect, fromRect: NSZeroRect, operation: NSCompositingOperation.Copy, fraction: 1.0)
        
        //        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        //        [smallImage unlockFocus];
        //
        //        sourceImage.drawInRect(rect, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOut, fraction: 1.0)
        
        newImage.unlockFocus()
        
        return newImage//[newImage autorelease];
        
    }
    
    
}
