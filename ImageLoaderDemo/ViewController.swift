//
//  ViewController.swift
//  ImageLoaderDemo
//
//  Created by wangyaqing on 15/6/30.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var testImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadImage()
    {
        testImageView.frame = view.bounds
        testImageView.image = nil
        testImageView.startLoadingWithTintColor(UIColor.blackColor())
        
        weak var wSelf = self
        testImageView.sd_setImageWithURL(NSURL(string: "http://img15.3lian.com/2015/f2/169/d/6.jpg"), placeholderImage: nil, options: SDWebImageOptions.RefreshCached | SDWebImageOptions.CacheMemoryOnly, progress: { (receivedSize, expectedSize) -> Void in
            var p : CGFloat = (CGFloat)(receivedSize) / (CGFloat)(expectedSize)
    
            wSelf!.testImageView.updateImageDownlaodingProgress(progress: p)
            
            }) { (img, err, type, url) -> Void in
                
                wSelf!.testImageView.reveal()
        }

        testImageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(testImageView)
    }
    
}

