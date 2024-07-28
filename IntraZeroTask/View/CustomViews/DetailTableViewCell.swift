//
//  DetailTableViewCell.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    static let identifier = "DetailTableViewCell"
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func configureCell(key:String,value:String){
        titleLabel.text = "\(key):"
        subTitleLabel.text = value
    }
}
