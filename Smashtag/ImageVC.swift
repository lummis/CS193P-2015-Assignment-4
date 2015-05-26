//
//  ImageVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/24/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView?
    var aspectRatio: CGFloat = 1    // height / width
    var originalImageSize: CGSize = CGSizeZero
    var userDidZoom: Bool = false
    var userDidScroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        if let imageV = imageView {
            originalImageSize = imageV.bounds.size
            aspectRatio = originalImageSize.height / originalImageSize.width
            scrollView.addSubview(imageV)
            scrollView.contentSize = originalImageSize
            scrollView.maximumZoomScale = 2.0
            scrollView.minimumZoomScale = 0.5
            scrollView.delegate = self
            view.addSubview(scrollView)
            autoZoom()
        }
    }
    
    // show as much of the image as possible but with no white space around it
    // set zoomScale so image fills scrollView in one direction and is larger than it in the other
    func autoZoom() {
        let navBar = UINavigationController().navigationBar
        let navBarHeight = navBar.bounds.size.height
        println(navBarHeight)
        let scaleX = scrollView.bounds.size.width / originalImageSize.width
        let scaleY = (scrollView.bounds.size.height - navBarHeight) / originalImageSize.height
        scrollView.zoomScale = max(scaleX, scaleY)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        if imageView != nil {
//            var imageV = imageView!
//            originalImageSize = imageV.bounds.size
//            println("imageView original frame: \(imageV.frame)")
//            
//            if let scrollViewSize = self.scrollView?.frame.size {
//                let scaleX = scrollViewSize.width / originalImageSize.width
//                let scaleY = scrollViewSize.height / originalImageSize.height
//                var scale = min(scaleX, scaleY)
//                let newWidth = originalImageSize.width * scale
//                let newHeight = originalImageSize.height * scale
//                let x = (scrollViewSize.width - newWidth) / 2
//                let y = (scrollViewSize.height - newHeight) / 2
//                imageV.frame = CGRectMake(x, y, newWidth, newHeight)
//                scrollView.addSubview(imageV)
//                scrollView.delegate = self
//                scrollView.contentOffset = CGPointMake(0, 0)
//            } else { println("no scrollView") }
//        }
//    }
    
//    func updateUI() {
//        if imageView != nil {
//            var imageV = imageView!
//            let startSize = imageV.bounds.size
//            println("imageView starting frame: \(imageV.frame)")
//            
//            if let scrollViewSize = scrollView?.frame.size {
//                println("scrollView.frame: \(scrollView.frame)")
//                let scaleX = scrollViewSize.width / originalImageSize.width
//                let scaleY = scrollViewSize.height / originalImageSize.height
//                let scale = min(scaleX, scaleY)
//                scrollView.zoomScale = scale
//                println("zoomScale: \(scale)")
////                scrollView.addSubview(imageV)
////                scrollView.delegate = self
//            } else { println("no scrollView") }
//        }
//
//    }
    
    func updateUI() {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        println("viewForZooming...")
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        println("scrollViewDidZoom")
        userDidZoom = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrollViewDidScroll")
        userDidScroll = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        println("did Rotate")
//        view.setNeedsLayout()
        updateUI()
    }

}
