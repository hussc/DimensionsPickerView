//
//  DimensionalTextField.swift
//  DimensionTextField
//
//  Created by Hussein AlRyalat on 11/6/19.
//  Copyright © 2019 Hussein AlRyalat. All rights reserved.
//

import UIKit


/**
 Can someone put a pull request to suggest a description of the class? 🤷‍♂️
 */
@IBDesignable open class DimensionsPickerView: UIControl {
    
    /**
     Represents the text fields count ( excluding the unit text field ), the minimum value is 1, any value less than this raises an exception.
     */
    @IBInspectable open var inputFieldsCount: Int = 2 {
        didSet {
            reloadViewsWithDefaultParameters()
        }
    }
    
    
    /**
     Controls the visability of labels between the text fields, like the x between the width and height dimensions.
     */
    @IBInspectable open var hasLabels: Bool = true {
        didSet {
            reloadApperanceOfLabels()
        }
    }
    
    /**
     The unit field appears at the trailing of the view and shows a simple non-editable unit text, like m or km.
     */
    @IBInspectable open var hasUnitField: Bool = true {
        didSet {
            reloadUnitFieldApperance()
        }
    }
    
    @IBInspectable open var spacingBetweenValueFields: CGFloat = 5 {
        didSet {
            textFieldsStackView.spacing = spacingBetweenValueFields
        }
    }
    
    @IBInspectable open var spacingBetweenUnitAndValues: CGFloat = 5 {
        didSet {
            containerStackView.spacing = spacingBetweenUnitAndValues
        }
    }
        
    /**
     A helper variable which let's you get the values from the text fields, because the view has multiple text fields, one may not have the value inputted in, so whenever the user did not enter a value in one of the fields, it will have a null value.
     
     Note: The count of the `values` array will always be the same as the `textFields` property and the `inputFieldsCount` property.
     */
    public var values: [Double?] {
        set {
            // trim the array so it's large or equal the text fields count.
            let trimmed = newValue.refilled(with: inputFieldsCount)
            let texts: [String?]
            
            // map the values into strings
            if let valueFormatter = self.valueToStringFormatter {
                texts = trimmed.map { valueFormatter(trimmed.index(of: $0)!, $0) }
            } else {
                texts = trimmed.map {
                    if let value = $0 {
                        return self.numberFormatter.string(from: NSNumber(value: value))
                    } else {
                        return nil
                    }
                }
            }
            
            for (index, textField) in valuesTextFields.enumerated() {
                textField.text = texts[index]
            }
        } get {
            // return the texts of the text fields mapped to double values :)
            let texts = valuesTextFields.map { $0.text }
            let values: [Double?]
            
            if let valueFormatter = self.stringToValueFormatter {
                values = texts.map { valueFormatter(texts.index(of: $0)!, $0) }
            } else {
                values = texts.map {
                    if let value = $0 {
                        return self.numberFormatter.number(from: value)?.doubleValue
                    } else {
                        return nil
                    }
                }
            }
            
            return values
        }
    }
    
    /**
     Use this property to insure all values are correct and entered by the user.
     */
    public var isValidContent: Bool {
        return values.filter { $0 == nil }.isEmpty
    }
    
    /**
     Computed property to get the value fields in the reciever, the fields count will always be equal to the input fields property.
     */
    public var valuesTextFields: [UITextField] {
        return textFieldsStackView.arrangedSubviews.compactMap { $0 as? UITextField }
    }
    
    /**
     Computed property to get the labels between the value fields if there is any, if the reciever `hasLabels` is true, the count of the labels will be `inputFieldsCount` - 1, and if not, the count will be zero.
     */
    public var labels: [UILabel] {
        return textFieldsStackView.arrangedSubviews.compactMap { $0 as? UILabel }
    }
    
    /**
     The unit text field that represents the unit value displayed in the trailing of the reciever, the view is nil if the reciever `hasUnitField` is off.
     */
    public var unitTextField: UITextField? {
        return pickersStackView.arrangedSubviews.compactMap { $0 as? UITextField }.first
    }
    
    /**
     Just like any regular iOS Control, this value controls the internal text fields `isEnabled` property
     */
    open override var isEnabled: Bool {
        didSet {
            for textField in valuesTextFields {
                textField.isEnabled = isEnabled
            }
        }
    }
    
    /**
     Customization block when converting from a value to a text displayed in the text field, this block will be called when you set the values of the reciever, which converts the the given values into strings to display.
     
    Note: the default number formatter will be used if the block is nil.
     */
    open var valueToStringFormatter: ((Int, Double?) -> String?)?
    
    /**
     Customization block to convert a string from the user input into a value, this block is called whenever you try to access the values property of the reciever, which takes the input the user has written and transforms it into double values
     
    Note: the default number formatter will be used if the block is nil.
     */
    open var stringToValueFormatter: ((Int, String?) -> Double?)?
    
    open var textFieldConfigureBlock: ((Int, UITextField) -> Void)?
    open var labelConfigureBlock: ((Int, UILabel) -> Void)?
    open var pickerFieldConfigureBlock: ((UITextField) -> Void)?

    
    public var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = 2
        return numberFormatter
    }()
    
    fileprivate let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    fileprivate let textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    fileprivate let pickersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        basicSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        basicSetup()
    }
    
    fileprivate func basicSetup(){
        addSubview(containerStackView)
                
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

                
        containerStackView.addArrangedSubview(textFieldsStackView)
        containerStackView.addArrangedSubview(pickersStackView)
        
        /* listen to changes to the notification center notification recieved from the text fields */
        reloadViewsWithDefaultParameters()
    }
    
    fileprivate func reloadViewsWithDefaultParameters(){
        reloadViews(with: max(1, inputFieldsCount), hasLabels: self.hasLabels, hasPickerTextField: self.hasUnitField)
    }
    
    fileprivate func reloadUnitFieldApperance(){
        pickersStackView.isHidden = !hasUnitField
    }
    
    fileprivate func reloadApperanceOfLabels(){
        self.labels.forEach {
            $0.isHidden = !self.hasLabels
        }
    }
    
    fileprivate func reloadViews(with textFieldsCount: Int,
                                 hasLabels: Bool,
                                 hasPickerTextField: Bool){
        
        
        clearTextFieldsStack()
        clearPickersStack()
        
        setupTextFieldsWithLabels(of: textFieldsCount, hasLabels: hasLabels)
        
        setupPickerTextField()
        
        if let firstTextField = valuesTextFields.first {
            pickersStackView.widthAnchor.constraint(equalTo: firstTextField.widthAnchor).isActive = true
            return
        }
    }
    
    fileprivate func customizeNumberField(textField: UITextField, for index: Int){
        self.textFieldConfigureBlock?(index, textField)
        textField.delegate = self
    }
    
    fileprivate func customizePickerField(textField: UITextField){
        self.pickerFieldConfigureBlock?(textField)
        textField.delegate = self
    }
    
    fileprivate func customizeLabel(label: UILabel, for index: Int){
        self.labelConfigureBlock?(index, label)
    }
    
    fileprivate func clearTextFieldsStack(){
        // remove all text fields and labels
        textFieldsStackView.arrangedSubviews.forEach {
            textFieldsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    fileprivate func clearPickersStack(){
        pickersStackView.arrangedSubviews.forEach {
            pickersStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    fileprivate func setupTextFieldsWithLabels(of count: Int, hasLabels: Bool){
        // we need to add (n) text fields, and (n - 1) labels.
        // as we always need to start with text field and then a label, we need to put a text field whenever i % 2 == 0 ( or i == 0 ), and a label whenever i % 2 != 0.
        for i in 0..<(count + (count - 1)) {
            if i == 0 || i % 2 == 0 {
                // put a textField
                let textField = self.buildUITextField()
                
                // and how to compute the i? we did it :)
                customizeNumberField(textField: textField, for: max(0, i - 1))
                textFieldsStackView.addArrangedSubview(textField)
                
                // and if the text field is not the first one, make sure it's size equals the first text field :)
                if i != 0 {
                    textField.widthAnchor.constraint(equalTo: valuesTextFields.first!.widthAnchor).isActive = true
                }
            } else {
                // put a label
                let label = self.buildLabel()
                customizeLabel(label: label, for: i - 1)
                label.isHidden = !hasLabels
                textFieldsStackView.addArrangedSubview(label)
            }
        }
    }
    
    // adds the picker text field to the view.
    fileprivate func setupPickerTextField(){
        let textField = self.buildPickerTextField()
        customizePickerField(textField: textField)
        pickersStackView.addArrangedSubview(textField)
    }
}

//MARK: UITextField Delegate
extension DimensionsPickerView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(values)
        
        if textField == unitTextField {
            // return. just ended editing.
            return textField.resignFirstResponder()
        }
        
        if let index = valuesTextFields.firstIndex(of: textField){
            // do we have a next index to switch to?
            let nextIndex = index + 1
            if nextIndex < inputFieldsCount {
                let nextTextField = valuesTextFields[nextIndex]
                return nextTextField.becomeFirstResponder()
            } else {
                if let pickerField = self.unitTextField {
                    if !pickerField.becomeFirstResponder(){
                        textField.resignFirstResponder()
                    } else {
                        return true
                    }
                } else {
                    textField.resignFirstResponder()
                }
            }
        } else {
            return textField.resignFirstResponder()
        }
        
        return textField.resignFirstResponder()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // always allow editing for picker text field
        if textField == unitTextField {
            return true
        }

        // Handle backspace/delete
        guard !string.isEmpty else {
            // Backspace detected, allow text change, no need to process the text any further
            return true
        }
        
        

        // Check for invalid input characters

        // Length Processing
        // Need to convert the NSRange to a Swift-appropriate type
        if let text = textField.text, let range = Range(range, in: text) {

            let proposedText = text.replacingCharacters(in: range, with: string)
            
            guard numberFormatter.number(from: proposedText) != nil else {
                return false
            }
            
            return true
        }

        // Allow text change
        return true
    }
}


//MARK: Builder
extension DimensionsPickerView {
    open func buildUITextField() -> UITextField {
        let textField = UITextField()
        // maybe we want to add some customization here?

        textField.font = UIFont(name: "AvenirNext-Medium", size: 15)
        textField.textAlignment = .center
        textField.setContentCompressionResistancePriority(.required, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor(white: 0.94, alpha: 1)

        return textField
    }
    
    open func buildPickerTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "unit"
        textField.textAlignment = .center
        textField.font = UIFont(name: "AvenirNext-Medium", size: 15)
        textField.isEnabled = false

        return textField
    }
    
    open func buildLabel() -> UILabel {
        let label = UILabel()
        label.text = "x"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }
}

internal extension Array where Element == Optional<Double> {
    func refilled(with desiredCount: Int) -> [Double?] {
        var finalArray = [Double?](repeating: nil, count: desiredCount)
        
        
        if count < desiredCount {
            // fill the array with the items from the given array, or null for empty positions
            
            for (index, item) in self.enumerated() {
                finalArray[index] = item
            }
            
            return finalArray
        } else {
           // the count of the array is more than the desired count, so we need to trim the array.
            return Array(self[0..<desiredCount])
        }
    }
}
