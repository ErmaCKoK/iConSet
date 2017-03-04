//
//  ImageInfo.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class ImageInfo: NSObject {
    
    private(set) var originalUrl: URL
    private var imageSize: BitmapImageSize
    private var type: NSBitmapImageFileType
    
    private var jpgComresionValue: NSNumber?
    
    private var originalImage: NSImage
    private var originalSize: BitmapImageSize
    
    var scale: Int
    
    var size: BitmapImageSize {
        return BitmapImageSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
    var name: String {
        let pref = scale <= 1 ? "" : "@\(scale)x"
        let typeFyle = self.type == .PNG ? "png" : "jpg"
        return "\(self.originalUrl.name)\(pref).\(typeFyle)"
    }
    
    var originName: String {
        return self.originalUrl.name
    }
    
    init?(url: URL, scale: Int, jpgComresion: NSNumber? = nil) {
        
        guard let originalImage = NSImage(contentsOf: url), let originalSize = NSBitmapImageRep.sizeImage(by: url) else { return nil }
        
        self.originalUrl = url
        
        self.originalImage = originalImage
        self.originalSize = originalSize
        
        let originalScale = url.scale
        self.imageSize = BitmapImageSize(width: self.originalSize.width/originalScale, height: self.originalSize.height/originalScale)
        
        self.scale = scale
        
        self.type = jpgComresion != nil ? .JPEG2000 : .PNG
        self.jpgComresionValue = jpgComresion
        
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
        
//        //fill the new image with white...
//        [[NSColor whiteColor] setFill];
//        [NSBezierPath fillRect:NSMakeRect(0, 0, imageSize.width, imageSize.height)];
        
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
