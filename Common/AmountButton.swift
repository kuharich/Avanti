//
//  AmountButton.swift
//  AvantiMarket
//
//  Created by Mark Kuharich on 3/10/16.
//  Copyright © 2016 Byndl. All rights reserved.
//

import UIKit

class AmountButton: UIButton {
    var firstRow: UILabel?
    var secondRow: UILabel?
    var selectedBackgroundColor: UIColor?
    var selectedTextColor: UIColor?
    var notSelectedBackgroundColor: UIColor?
    var notSelectedTextColor: UIColor?
    var amount: NSDecimalNumber?
    var bonus: NSDecimalNumber?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setTitle("", for: UIControlState())
        self.setTitle("", for: UIControlState.selected)
        self.setTitleColor(UIColor.clear, for:UIControlState())
        self.setTitleColor(UIColor.clear, for:UIControlState.selected)
        
        let radius = CGFloat(3.0)
        self.layer.cornerRadius = radius;
        let buttonFrame:CGRect = self.frame
        
        self.firstRow = UILabel(frame: CGRect(x: 0, y: 0, width: buttonFrame.size.width, height: buttonFrame.size.height*0.7))
        self.secondRow = UILabel(frame: CGRect(x: 0, y: buttonFrame.size.height*0.55, width: buttonFrame.size.width, height: buttonFrame.size.height*0.3))
        
        self.firstRow!.textAlignment = NSTextAlignment.center
        
        self.secondRow!.textAlignment = NSTextAlignment.center
        
        self.addSubview(self.firstRow!)
        self.addSubview(self.secondRow!)
    }
    
    
    func select() {
        self.isSelected = true
        self.backgroundColor = self.selectedBackgroundColor
        self.firstRow!.textColor = self.selectedTextColor
        self.secondRow!.textColor = self.selectedTextColor
        
    }
    
    func deselect() {
        self.isSelected = false
        self.backgroundColor = self.notSelectedBackgroundColor
        self.firstRow!.textColor = self.notSelectedTextColor
        self.secondRow!.textColor = self.notSelectedTextColor
    }
    
    func setLayout() {
        self.firstRow!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.7)
        self.secondRow!.frame = CGRect(x: 0, y: self.frame.size.height*0.55, width: self.frame.size.width, height: self.frame.size.height*0.3)
        self.secondRow!.isHidden = false
        if (self.bonus == 0.0) {
            self.firstRow!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.secondRow!.isHidden = true
        }
    }
    
    
    func setTexts(_ firstRowText: String,  secondRowText: String) {
        self.firstRow!.text = firstRowText
        self.secondRow!.text = secondRowText
        
        self.secondRow!.text = secondRowText;

        self.setTitle(firstRowText, for: UIControlState())
        self.setTitle(firstRowText, for: UIControlState.selected)
        
        self.setLayout()
    }
    
    func setSums(_ amount: NSDecimalNumber,  bonus: NSDecimalNumber) {
        self.amount = amount
        self.bonus = bonus
        self.setLayout()
    }
    
    func getTotalAmount() -> NSDecimalNumber {
        if let a = amount, let b = bonus {
            return a.adding(b)
        }
        if let a = amount { // b must be nil
            return a
        }
        return 0.0;
    }
    
    func getAmount() -> NSDecimalNumber {
        if let a = amount { // b must be nil
            return a
        }
        return 0.0;
    }

    func getBonus() -> NSDecimalNumber {
        if let b = bonus { // b must be nil
            return b
        }
        return 0.0;
    }
    
    func setFonts(_ firstFont:UIFont,  secondFont:UIFont)
    {
        self.firstRow!.font = firstFont;
        self.secondRow!.font = secondFont;
    }
    
    func setColors(_ selectedTextColor: UIColor,  selectedBackgroundColor: UIColor) {
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.notSelectedBackgroundColor = selectedTextColor
        self.notSelectedTextColor = selectedBackgroundColor
    }
    
    func setColors(_ selectedTextColor: UIColor,  selectedBackgroundColor: UIColor, notSelectedTextColor: UIColor, notSelectedBackgroundColor: UIColor) {
        self.selectedTextColor = selectedTextColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.notSelectedBackgroundColor = notSelectedBackgroundColor
        self.notSelectedTextColor = notSelectedTextColor
    }
    
    func selected() -> Bool {
        return self.isSelected
    }
}
