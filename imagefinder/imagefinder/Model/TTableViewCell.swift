//
//  TTableViewCell.swift
//  imagefinder
//
//  Created by Lukas Holmberg on 2020-02-06.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class TTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
