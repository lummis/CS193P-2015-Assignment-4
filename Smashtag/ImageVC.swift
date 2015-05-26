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
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.5
            scrollView.delegate = self
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, barHeights(),
            view.frame.size.width, view.frame.size.height - barHeights())
        scrollView.contentOffset = CGPointMake(0, 0)
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector:"deviceDidRotate", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        autoZoom()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func deviceDidRotate() {
        println("device did Rotate")
        if !userDidZoom { autoZoom() }  // don't change the zoom scale if the user set it
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        println("viewForZooming...")
        return imageView
    }

    func barHeights() -> CGFloat {
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let navBarFrame = UINavigationController().navigationBar.frame
        return statusBarFrame.size.height + navBarFrame.size.height
    }
    
    // show as much of the image as possible but with no white space around it
    // set zoomScale so image fills scrollView in one direction and is larger than it in the other
    // only autoZoom when the view appears or rotates AND the user hasn't changed the zoom manually
    func autoZoom() {
        println("autoZoom; barHeights: \(barHeights())")
        
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, barHeights(),
            view.frame.size.width, view.frame.size.height - barHeights())
        
        let scaleX = scrollView.bounds.size.width / originalImageSize.width
        let scaleY = (scrollView.bounds.size.height) / originalImageSize.height
        scrollView.setZoomScale(max(scaleX, scaleY), animated: true)
        scrollView.contentOffset = CGPointMake(0, 0)
        userDidZoom = false     // this must be after setZoomScale
    }

    // in lecture he said this indicates that the user zoomed the view but it doesn't
    // this callback comes whenever the view is zoomed, by the used or by code
    func scrollViewDidZoom(scrollView: UIScrollView) {
        println("scrollViewDidZoom")
        userDidZoom = true  // if zoom caused by autoZoom this will immediately get set back to false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrollViewDidScroll")
        userDidScroll = true
    }
    
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    
//        println("did Transition")
//        if !userDidZoom { autoZoom() }
//    }

    
    // scrollView doesn't resize on rotate ???
//    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
//        println("did Rotate")
//        if !userDidZoom { autoZoom() }
//    }

}
