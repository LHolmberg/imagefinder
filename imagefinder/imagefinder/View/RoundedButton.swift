//
//  RoundedButton.swift
//  imagefinder
//
//  Created by Lukas Holmberg on 2020-02-06.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    }
}
