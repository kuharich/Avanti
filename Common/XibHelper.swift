//
//  XibHelper.swift
//  AvantiMarket
//
//  Created by Tero Jankko on 3/14/16.
//  Copyright © 2016 Byndl. All rights reserved.
//

import UIKit

class XibHelper: NSObject {
    
    class func XibFileName(_ filename: String) -> String {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            return filename + "_iPad"
        }
        else {
            return filename
        }
    }
    
    class func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
}
