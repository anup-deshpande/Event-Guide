//
//  EventTableViewCell.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import UIKit
import SDWebImage

class EventTableViewCell: UITableViewCell {

    // Label outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    // ImageView outlets
    @IBOutlet weak var thumbnail: UIImageView!
    
    var event: Event?{
        didSet{
            setCellValues()
        }
    }
    
    var isFavorite: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellStyles()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellValues(){
        guard let event = event else { return }
        guard let isFavorite = isFavorite else { return }
        
        title.text = event.title
        
        // Check if event date is fixed
        if !event.dateTbd{
            
            // Date is decided, Check if time is fixed
            if !event.timeTbd{
                let eventDate = DateFormatter.dayMonthYearTimeFormat.string(from: event.datetimeLocal)
                dateTime.text = "\(eventDate)"
            }else{
                let eventDate = DateFormatter.dayMonthYearFormat.string(from: event.datetimeLocal)
                dateTime.text = "\(eventDate) Time TBD"
            }
        }else{
            dateTime.text = "Date and Time TBD"
        }
        
        if let thumbnailURL = event.performers.first?.image{
            thumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
            thumbnail.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: UIImage(systemName: "photo"))
        }else{
            thumbnail.image = UIImage(systemName: "photo")
        }

        favoriteLabel.isHidden = !isFavorite
    }
    
    func setCellStyles(){
        thumbnail.layer.cornerRadius = 10
        thumbnail.clipsToBounds = true
    }

}
