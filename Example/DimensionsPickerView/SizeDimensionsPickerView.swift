//
//  SizeDimensionsPickerView.swift
//  DimensionsPickerView_Example
//
//  Created by Hussein AlRyalat on 11/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DimensionsPickerView

class SizeDimensionsPickerView: DimensionsPickerView {
    
    override func buildValueTextField() -> UITextField {
        let field = UnderlineTextField()
        field.underlineView.backgroundColor = UIColor(white: 0.96, alpha: 1)
        return field
    }
}
