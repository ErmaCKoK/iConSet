//
//  NSBitmapImageRepExtension.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

struct BitmapImageSize {
    var width = 0
    var height = 0
    
    init(width: CGFloat, height: CGFloat) {
        self.init(width: Int(width), height: Int(height))
    }
    
    init(width: Double, height: Double) {
        self.init(width: Int(width), height: Int(height))
    }
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

extension NSBitmapImageRep {
    
    class func imageRepWithPixelSize(pixelSize: BitmapImageSize) -> NSBitmapImageRep? {
        return NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixelSize.width, pixelsHigh: pixelSize.height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0)
    }
    
    func setImage(anImage: NSImage, quality: CGInterpolationQuality) {
        
        let w = self.pixelsWide
        let h = self.pixelsHigh
        let bpr = self.bytesPerRow
        let bps = self.bitsPerSample
        
        let cgImage = anImage.CGImageForProposedRect(nil, context:nil, hints:nil)
        let context = CGBitmapContextCreate(self.bitmapData, w, h, bps, bpr,  self.colorSpace.CGColorSpace!, CGImageAlphaInfo.PremultipliedLast.rawValue)
        //Considers CG's interpolation algorithms.
        CGContextSetInterpolationQuality(context!, quality);
        
        CGContextDrawImage(context!, CGRectMake(0, 0, CGFloat(w), CGFloat(h)), cgImage!);
    }
    
    class func sizeImageByURL(URL: NSURL) -> BitmapImageSize? {
        if let imageReps = NSBitmapImageRep.imageRepsWithContentsOfURL(URL) {
            
            var width = 0;
            var height = 0;
            
            for imageRep in imageReps {
                if imageRep.pixelsWide > width { width = imageRep.pixelsWide}
                if imageRep.pixelsHigh > height { height = imageRep.pixelsHigh}
            }
            
            return BitmapImageSize(width: width, height: height)
        }
        
        return nil
    }
    
}
