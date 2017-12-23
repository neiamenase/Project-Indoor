//
//  SuggestionTableViewCell.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 23/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
