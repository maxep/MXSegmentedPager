// MXViewController.swift
//
// Copyright (c) 2017 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SNPSegmentedPager

class MXViewController: MXSegmentedPagerController {

    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedPager.backgroundColor = .white
        
        // Parallax Header       
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 150
        segmentedPager.parallaxHeader.minimumHeight = 20
        
        // Segmented Control customization
//        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
//        segmentedPager.segmentedControl.backgroundColor = .white
//        segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
//        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.orange]
//        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
//        segmentedPager.segmentedControl.selectionIndicatorColor = .orange
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func views(for segmentedPager: MXSegmentedPager) -> [SegmentedView] {
        let view1 = SegmentedView()
        view1.backgroundColor = UIColor.blue
        
        let view2 = SegmentedView()
        view2.backgroundColor = UIColor.red
        
        let view3 = SegmentedView()
        view3.backgroundColor = UIColor.cyan
        
        return [view1,view2,view3];
    }
    
    override func indicatorColor(for segmentedPager: MXSegmentedPager) -> [UIColor] {
        return [UIColor.blue.withAlphaComponent(0.5),UIColor.red.withAlphaComponent(0.5),UIColor.cyan.withAlphaComponent(0.5)]
    }
    
    override func indicatorHeigth(for segmentedPager: MXSegmentedPager) -> CGFloat {
        return 5
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
}
