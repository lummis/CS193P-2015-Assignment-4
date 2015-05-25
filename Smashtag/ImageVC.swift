//
//  ImageVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/24/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView: UIImageView?
    var originalSize: CGSize = CGSizeZero
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if imageView != nil {
            var imageV = imageView!
            originalSize = imageV.bounds.size
            println("imageView original frame: \(imageV.frame)")
            
            if let scrollViewSize = self.scrollView?.frame.size {
                let scaleX = scrollViewSize.width / originalSize.width
                let scaleY = scrollViewSize.height / originalSize.height
                var scale = min(scaleX, scaleY)
                let newWidth = originalSize.width * scale
                let newHeight = originalSize.height * scale
                let x = (scrollViewSize.width - newWidth) / 2
                let y = (scrollViewSize.height - newHeight) / 2
                imageV.frame = CGRectMake(x, y, newWidth, newHeight)
                scrollView.addSubview(imageV)
                scrollView.delegate = self
                scrollView.contentOffset = CGPointMake(0, 0)
            } else { println("no scrollView") }
        }
    }
    
    func updateUI() {
        if imageView != nil {
            var imageV = imageView!
            let startSize = imageV.bounds.size
            println("imageView starting frame: \(imageV.frame)")
            
            if let scrollViewSize = scrollView?.frame.size {
                println("scrollView.frame: \(scrollView.frame)")
                let scaleX = scrollViewSize.width / originalSize.width
                let scaleY = scrollViewSize.height / originalSize.height
                let scale = min(scaleX, scaleY)
                scrollView.zoomScale = scale
                println("zoomScale: \(scale)")
//                scrollView.addSubview(imageV)
//                scrollView.delegate = self
            } else { println("no scrollView") }
        }

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        println("viewForZooming...")
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        println("scrollViewDidZoom")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrollViewDidScroll")
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        println("did Rotate")
//        view.setNeedsLayout()
//        updateUI()
    }

}
