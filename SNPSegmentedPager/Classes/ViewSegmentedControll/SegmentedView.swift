//
//  SegmentedView.swift
//  MXSegmentedPager
//
//  Created by farhad jebelli on 6/17/18.
//  Copyright © 2018 maxep. All rights reserved.
//

import UIKit

@objc open class SegmentedView: UIControl {
     open var segmentViewIsSelected:Bool? {
        didSet{
            
        }
    }
    
    var index:Int?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
