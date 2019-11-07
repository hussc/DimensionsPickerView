//
//  UnderlineTextField.swift
//  DimensionsPickerView_Example
//
//  Created by Hussein AlRyalat on 11/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable class UnderlineTextField: UITextField {
    
    fileprivate var insets: UIEdgeInsets {
        .init(top: 0, left: 0, bottom: -underlineHeight, right: 0)
    }
    
    var underlineHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underlineView.frame = CGRect(x: 0, y: bounds.height - underlineHeight, width: bounds.width, height: underlineHeight)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    fileprivate func setup(){
        addSubview(underlineView)
    }
}
