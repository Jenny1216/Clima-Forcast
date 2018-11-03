//
//  TempConversionButton.swift
//  rainyshinycloudyapp
//
//  Created by Jinisha Savani on 11/2/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit

class TempConversionButton: UIButton {

    var isCelcius = false
    @IBAction func degreeButton(_ sender: Any) {
        

        tempConversion(bool: !isCelcius)
    }
    
    func tempConversion(bool : Bool){
        
        isCelcius = bool

        let title = bool ? "˚F" : "˚C"
        setTitle(title, for: .normal)
        print(title)
        
        
    }
    
    
    
    
}
