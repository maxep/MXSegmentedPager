//
//  MXHeaderView.swift
//  MXSegmentedPager-Swift
//
//  Created by Maxime Epain on 01/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

import UIKit

class MXHeaderView: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MXHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
