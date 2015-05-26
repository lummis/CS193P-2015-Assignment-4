//
//  ImageVC.swift
//  Smashtag
//
//  Created by Robert Lummis on 5/24/15.
//  Copyright (c) 2015 ElectricTurkeySoftware. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    var imageView: UIImageView?
    var aspectRatio: CGFloat = 1    // height / width
    var originalImageSize: CGSize = CGSizeZero
    var userDidZoom: Bool = false
    var userDidScroll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("in viewDidLoad; scrollView frame: \(scrollView.frame)")
        if let imageV = imageView {
            originalImageSize = imageV.bounds.size
            aspectRatio = originalImageSize.height / originalImageSize.width
            scrollView.addSubview(imageV)
            scrollView.contentSize = originalImageSize
            scrollView.maximumZoomScale = 2.0
            scrollView.minimumZoomScale = 0.5
            scrollView.delegate = self

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, barHeights(),
            view.frame.size.width, view.frame.size.height - barHeights())
        scrollView.contentOffset = CGPointMake(0, 0)
        
        println("view frame: \(view.frame)")
        println("scrollView frame: \(scrollView.frame)")
        println("barHeights: \(barHeights())")

        if !userDidZoom { autoZoom() }
    }
    
    func barHeights() -> CGFloat {
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let navBarFrame = UINavigationController().navigationBar.frame
        return statusBarFrame.size.height + navBarFrame.size.height
    }
    
    // show as much of the image as possible but with no white space around it
    // set zoomScale so image fills scrollView in one direction and is larger than it in the other
    func autoZoom() {
        println("in autoZoom; barHeights: \(barHeights())")
        
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, barHeights(),
            view.frame.size.width, view.frame.size.height - barHeights())
        
        let scaleX = scrollView.bounds.size.width / originalImageSize.width
        let scaleY = (scrollView.bounds.size.height) / originalImageSize.height
        scrollView.zoomScale = max(scaleX, scaleY)
        scrollView.contentOffset = CGPointMake(0, 0)
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
    
    // scrollView doesn't get resized on rotate ???
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        println("did Rotate")
        let navBar = UINavigationController().navigationBar
        let navBarHeight = navBar.bounds.size.height
        println("navBarHeight: \(navBarHeight)")
//        scrollView.frame = CGRectMake(0, barHeights(), view.frame.size.width, view.frame.size.height - barHeights())
        println("view frame: \(view.frame)")
        println("scrollView frame: \(scrollView.frame)")
        if !userDidZoom { autoZoom() }
    }

}
