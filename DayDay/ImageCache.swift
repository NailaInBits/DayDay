//
//  ImageCache.swift
//  DayDay
//
//  Created by Nishat Anjum on 5/15/17.
//  Copyright © 2017 WePlay. All rights reserved.
//

import Foundation

class ImageCache
{
    static let sharedCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in 
            let cache = NSCache<AnyObject, AnyObject>()
            cache.name = "ImageCache"
            cache.countLimit = 200 // Max 200 images in memory.
            cache.totalCostLimit = 20*1024*1024 // Max 20MB used.
            return cache
    }()
}
