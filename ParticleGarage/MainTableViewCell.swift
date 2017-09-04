//
//  MainTableViewCell.swift
//  ParticleController
//
//  Created by JakkritS on 3/19/2559 BE.
//  Copyright © 2559 App Illustrator. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceTypeImageView: UIImageView!
    @IBOutlet weak var connectivityView: ChainIcon!
    @IBOutlet weak var deviceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
