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
    
    class func imageRepWithPixelSize(_ pixelSize: BitmapImageSize) -> NSBitmapImageRep? {
        return NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixelSize.width, pixelsHigh: pixelSize.height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0)
    }
    
    func setImage(_ anImage: NSImage, quality: CGInterpolationQuality) {
        
        let w = self.pixelsWide
        let h = self.pixelsHigh
        let bpr = self.bytesPerRow
        let bps = self.bitsPerSample
        
        let cgImage = anImage.cgImage(forProposedRect: nil, context:nil, hints:nil)
        let context = CGContext(data: self.bitmapData, width: w, height: h, bitsPerComponent: bps, bytesPerRow: bpr,  space: self.colorSpace.cgColorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        //Considers CG's interpolation algorithms.
        context!.interpolationQuality = quality;
        
        context!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(w), height: CGFloat(h)));
    }
    
    class func sizeImage(by URL: URL) -> BitmapImageSize? {
        if let imageReps = NSBitmapImageRep.imageReps(withContentsOf: URL) {
            
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
