//
//  ImageInfo.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class ImageInfo: NSObject {
    
    private var named: String
    private var imageSize: BitmapImageSize
    private var type: NSBitmapImageFileType
    private var jpgComresionValue: NSNumber
    private var originalImage: NSImage
    
    var scale: Int
    
    var size: BitmapImageSize {
        return BitmapImageSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
    var name: String {
        let pref = scale <= 1 ? "" : "@\(scale)x"
        let typeFyle = self.type == .PNG ? "png" : "jpg"
        return "\(named)\(pref).\(typeFyle)"
    }
    
    init(image: NSImage, named: String, scale: Int, imageSize: BitmapImageSize, isJPG: Bool, jpgComresion: NSNumber) {
        
        self.named = named
        self.scale = scale
        self.imageSize = imageSize
        self.type = isJPGType ? .JPEG2000 : .PNG
        self.jpgComresionValue = jpgComresion
        self.originalImage = image
        
        super.init()
    }
    
    func data() -> Data? {
        
        // draw image
        let newImage = self.drawImage()
        
        // color space
        let targetColorSpace = NSColorSpace(cgColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!)!
        let imageRepNew = NSBitmapImageRep(data: newImage.tiffRepresentation!)!.retagging(with: targetColorSpace)!
        
        var properties: [String: Any] = [NSImageInterlaced : NSNumber(value: false)]
        
        if self.type == .JPEG2000 || self.type == .JPEG {
            properties[NSImageCompressionFactor] = self.jpgComresionValue
        }
        
        // image representation to data
        return imageRepNew.representation(using: self.type, properties: properties)
    }
    
    func drawImage() -> NSImage {
        
        let size = NSSize(width: self.size.width, height: self.size.height)
        let sourceImage = self.originalImage
        
        let newImage = NSImage(size: size) //[[NSImage alloc] initWithSize:targetSize];
        newImage.lockFocus()
        
        var rect = NSRect()
        
        rect.size = size
        
        sourceImage.size = size
        NSGraphicsContext.current()?.imageInterpolation = NSImageInterpolation.high
        
        sourceImage.draw(in: rect, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        
        //        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        //        [smallImage unlockFocus];
        //
        //        sourceImage.drawInRect(rect, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeSourceOut, fraction: 1.0)
        
        newImage.unlockFocus()
        
        return newImage//[newImage autorelease];
    }
    
    
}
