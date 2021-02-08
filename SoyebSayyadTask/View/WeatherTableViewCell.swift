//
//  WeatherTableViewCell.swift
//  SoyebSayyadTask
//
//  Created by Mac on 08/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDateandTime: UILabel!
      @IBOutlet weak var lblHumidity: UILabel!
      @IBOutlet weak var lblTempMin: UILabel!
      @IBOutlet weak var lblTempMax: UILabel!
      @IBOutlet weak var lblTemp: UILabel!
      @IBOutlet weak var lblCity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
