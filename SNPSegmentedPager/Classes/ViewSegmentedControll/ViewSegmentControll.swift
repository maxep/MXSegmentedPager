//
//  ViewSegmentControll.swift
//  MXSegmentedPager
//
//  Created by farhad jebelli on 6/17/18.
//  Copyright © 2018 maxep. All rights reserved.
//

import UIKit

@objc open class ViewSegmentControll: UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var indicatorColor:[UIColor]?
    var indicatorHeigth: CGFloat = 0
    @objc open var selectedSegmentIndex:Int = 0;
    var tabViews:[SegmentedView]?
    var indicator:UIView?
    var indicatorLeading: NSLayoutConstraint?
    
    
    
    @objc open func setViews(_ views: [SegmentedView],heigth: CGFloat){
        self.tabViews = views
        indicatorHeigth = heigth
        views.forEach(addSubview(_:))
        for (offset,view) in views.enumerated() {
            view.index = offset
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: { () -> NSLayoutXAxisAnchor in if offset == 0 {return self.leadingAnchor} else {return views[offset-1].trailingAnchor}}()).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -indicatorHeigth).isActive = true
            if offset == views.count-1 {
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }else {
                view.widthAnchor.constraint(equalTo: views[views.count-1].widthAnchor).isActive = true
            }
            view.addTarget(self, action: #selector(pageSelected), for: UIControlEvents.touchUpInside)
            
        }
        if views.count > 0 {
            indicator = UIView();
            indicator?.backgroundColor = indicatorColor?[selectedSegmentIndex] ?? UIColor.black
            indicator?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(indicator!)
            indicator?.heightAnchor.constraint(equalToConstant: indicatorHeigth).isActive = true
            indicator?.widthAnchor.constraint(equalTo: views[0].widthAnchor).isActive = true
            indicator?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            indicatorLeading = indicator?.leadingAnchor.constraint(equalTo: views[selectedSegmentIndex].leadingAnchor)
            indicatorLeading?.isActive = true
        }
        
        
    }
    
    @objc open func setIndocatorColor(colors: [UIColor]){
        self.indicatorColor = colors
        indicator?.backgroundColor = colors[selectedSegmentIndex];
    }
    
    
    @objc func pageSelected(control: SegmentedView){
        selectedSegmentIndex = control.index!
        sendActions(for: .valueChanged);
    }
    
    @objc open func setSelectedSegmentIndex(_ index: Int, animated: Bool){
        UIView.animate(withDuration: 0.3, animations: {[unowned self] in
        self.indicatorLeading?.isActive = false
        self.indicator?.removeConstraint(self.indicatorLeading!)
        self.indicatorLeading = self.indicator?.leadingAnchor.constraint(equalTo: self.tabViews![index].leadingAnchor)
        self.indicatorLeading!.isActive = true
        self.selectedSegmentIndex = index
        self.indicator?.backgroundColor = self.indicatorColor?[index]
        self.layoutIfNeeded()
        })
    }
    
    
    
    
    

}
