//
//  UIImageView+Loader.swift
//  ImageLoaderDemo
//
//  Created by wangyaqing on 15/6/30.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

import UIKit
var loaderViewKey : UInt8 = 0

public extension UIImageView
{
    
    private var loaderView : CircularLoaderView! {
        
        var view = objc_getAssociatedObject(self, &loaderViewKey) as? CircularLoaderView
        if view == nil
        {
            view = CircularLoaderView()
            
            objc_setAssociatedObject(self, &loaderViewKey, view!, UInt(OBJC_ASSOCIATION_RETAIN))
        }

        return view
    }
    
    //pragma mark
    func startLoading()
    {
        loaderView.frame = self.bounds
        self.addSubview(loaderView)
        loaderView.progress = 0
    }
    
    func startLoadingWithTintColor(color: UIColor)
    {
        startLoading()
        loaderView.tintColor = color
    }
    
    func updateImageDownlaodingProgress(#progress : CGFloat)
    {
        loaderView.progress = progress;
    }
    
    func reveal()
    {
        loaderView.reveal()
    }
    
}
