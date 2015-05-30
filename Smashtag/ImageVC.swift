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
    var originalImageSize: CGSize = CGSizeZero
    var userDidZoom: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"deviceDidRotate", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let imageV = imageView {
            originalImageSize = imageV.bounds.size
            scrollView.addSubview(imageV)
            scrollView.contentSize = originalImageSize
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.5
            scrollView.delegate = self
            autoZoom()
        }
    }
    
    func deviceDidRotate() {
        if !userDidZoom { autoZoom() }  // don't change the zoom scale if the user set it
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func barHeights() -> (topBarHeight: CGFloat, bottomBarHeight: CGFloat) {
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        let navBarFrame = UINavigationController().navigationBar.frame
        let tabBarFrame = UITabBarController().tabBar.frame
        let topBarHeight = statusBarFrame.size.height + navBarFrame.size.height
        let bottomBarHeight = tabBarFrame.size.height
        return (topBarHeight, bottomBarHeight)
    }
    
    // show as much of the image as possible but with no white space around it
    // set zoomScale so image fills scrollView in one direction and is larger than it in the other
    // autoZoom when the view appears or when it rotates AND the user hasn't changed the zoom manually
    //
    // the scrollView extends from the top of the view to the top of the tab bar
    // IOW the top of the scrollView is behind the status bar and nav bar
    // the image goes from the bottom of the top bars to the bottom of the scrollView
    func autoZoom() {
        let (topBarHeight, bottomBarHeight) = barHeights()
        let scaleX = scrollView.frame.size.width / originalImageSize.width
        let scaleY = (scrollView.frame.size.height - topBarHeight) / originalImageSize.height
        scrollView.setZoomScale(max(scaleX, scaleY), animated: true)
        scrollView.contentOffset = CGPointMake(0, -topBarHeight)
        
        // this must be after setZoomScale because that causes userDidZoom to be set true
        // this is only valid because autoZoom is never called after the user has manually zoomed
        userDidZoom = false
    }

    // in lecture he said this callback means the user zoomed the view but that's not right
    // this callback comes whenever the view is zoomed, whether by the used or by code
    func scrollViewDidZoom(scrollView: UIScrollView) {
        println("scrollViewDidZoom")
        userDidZoom = true  // if zoom caused by autoZoom this will immediately get set back to false
    }

}
