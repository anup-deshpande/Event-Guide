//
//  EventDetailViewController.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import UIKit
import RealmSwift
import SDWebImage

class EventDetailViewController: UIViewController {

    // Imageview outlet
    @IBOutlet weak var thumbnail: UIImageView!
    
    // Label outlets
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var shortAddress: UILabel!
    @IBOutlet weak var fullAddress: UILabel!
    
    // Button outlets
    @IBOutlet weak var favoriteEvent: UIButton!
    @IBOutlet weak var bookTickets: UIButton!
    
    let realm = try! Realm()
    
    var event: Event?
    
    var isFavorite: Bool?{
        didSet{
            guard let isFavourite = isFavorite else { return }
            if isFavourite{
                favoriteEvent.setTitle("Favorited", for: .normal)
                favoriteEvent.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                favoriteEvent.setTitle("Favorite", for: .normal)
                favoriteEvent.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEventValues()
        setStyles()
    }
    
    func loadEventValues(){
        
        guard let event = event else { return }
        let favoriteEventIDs = realm.objects(RealmEvent.self).filter{ $0.id == event.id }
        if favoriteEventIDs.isEmpty{
            isFavorite = false
        }else{
           isFavorite = true
        }
    
        eventTitle.text = event.title
        shortAddress.text = event.venue.nameV2
        fullAddress.text = event.venue.fullAddress
        
        // Check if event date is fixed
        if event.dateTbd == false{
            
            let dateFormatter = DateFormatter()
            
            // Date is decided, Check if time is fixed
            if event.timeTbd == false{
                dateFormatter.dateFormat = "E, MMM d, YYYY h:mm a"
                let eventDate = dateFormatter.string(from: event.datetimeLocal)
                dateTime.text = "\(eventDate)"
            }else{
                dateFormatter.dateFormat = "E, MMM d, YYYY"
                let eventDate = dateFormatter.string(from: event.datetimeLocal)
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
    }
    
    @IBAction func getDirectionsTapped(_ sender: UIButton) {
        guard let event = event else { return }
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "maps.apple.com"
        
        // Add event address as destination for the map to show directions
        components.queryItems = [
            URLQueryItem(name: "daddr", value: "\(event.venue.nameV2)")
        ]
        
        if let url = components.url {
            UIApplication.shared.open(url)
        } else {
            print("URL cannot be constructed.")
        }
    }
    
    @IBAction func favouriteEventTapped(_ sender: UIButton) {
        guard let isFav = isFavorite else { return }
        guard let event = event else { return }
        
        if isFav{
            let eventToDelete = realm.objects(RealmEvent.self).filter { $0.id == event.id }
            try! realm.write{
                realm.delete(eventToDelete)
                isFavorite?.toggle()
            }
        }else{
            let newFavoriteEvent = RealmEvent()
            newFavoriteEvent.id = event.id
            
            try! realm.write{
                realm.add(newFavoriteEvent)
                isFavorite?.toggle()
            }

        }
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func bookTicketsTapped(_ sender: UIButton) {
        
        guard let event = event else { return }
        
        if let url = URL(string: event.url){
            UIApplication.shared.open(url)
        }
    }
    
    func setStyles(){

        // Button styles
        let cornerRadius: CGFloat = 7
        favoriteEvent.layer.cornerRadius = cornerRadius
        bookTickets.layer.cornerRadius = cornerRadius
    }
}
