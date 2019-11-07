//
//  ViewController.swift
//  DimensionsPickerView
//
//  Created by hussc on 11/07/2019.
//  Copyright (c) 2019 hussc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sizePickerView: SizeDimensionsPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupApperanceOfSizePicker()
        sizePickerView.addTarget(self, action: #selector(sizePickerValueChanged), for: .valueChanged)
    }
    
    fileprivate func setupApperanceOfSizePicker(){
        sizePickerView.textFieldConfigureBlock = { index, field in
            switch index {
            case 0:
                field.placeholder = "w"
            case 1:
                field.placeholder = "h"
            default:
                break
            }
        }
        
        sizePickerView.pickerFieldConfigureBlock = { field in
            field.text = "m"
        }
        
        
        sizePickerView.tintColor = UIColor(red: 0.10588235408067703, green: 0.7372549176216125, blue: 0.6117647290229797, alpha: 1.0)
        sizePickerView.spacingBetweenValueFields = 0
        sizePickerView.spacingBetweenUnitAndValues = 15
        
        sizePickerView.layer.cornerRadius = 6
        sizePickerView.layer.borderColor = UIColor(white: 0.96, alpha: 1).cgColor
        sizePickerView.layer.borderWidth = 1.5
    }
    
    fileprivate func reloadButtonState(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func sizePickerValueChanged(){
        print(sizePickerView.values)
        print(sizePickerView.isValidContent)
    }
}

