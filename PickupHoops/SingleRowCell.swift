//
//  SingleRowCell.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/4/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit

class SingleRowCell: UITableViewCell
{

    @IBOutlet weak var lLocation: UILabel!
    @IBOutlet weak var lStartTime: UILabel!
    @IBOutlet weak var lNumPlayers: UILabel!
    @IBOutlet weak var lMinRating: UILabel!
    @IBOutlet weak var lTeam: UILabel!
    @IBOutlet weak var lWL: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
