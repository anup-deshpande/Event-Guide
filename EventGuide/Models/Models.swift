//
//  Models.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import Foundation

struct APIPreferences: Decodable{
    let clientID: String
}

struct EventList: Codable{
    let events: [Event]
    let meta: Meta
}

struct Event: Codable{
    let id: Int
    let datetimeUtc: Date
    let venue: Venue
    let performers: [Performer]
    let datetimeLocal: Date
    let timeTbd: Bool
    let shortTitle: String
    let url: String
    let dateTbd: Bool
    let title: String
    
    // Compute date and time based on dateTbd and timeTbd
    var dateTime: String{
        // Check if event date is fixed
        if !dateTbd{
            // Date is decided, Check if time is fixed
            if !timeTbd{
                let eventDate = DateFormatter.dayMonthYearTimeFormat.string(from: datetimeLocal)
                return "\(eventDate)"
            }else{
                let eventDate = DateFormatter.dayMonthYearFormat.string(from: datetimeLocal)
                return "\(eventDate) Time TBD"
            }
        }else{
            return "Date and Time TBD"
        }
    }
}

struct Meta: Codable{
    let page: Int
    let perPage: Int
}

struct Venue: Codable{
    let state: String
    let nameV2: String
    let postalCode: String
    let name: String
    let location: Location
    let address: String
    let city: String
    let displayLocation: String
    
    // Compute full address
    var fullAddress: String{
        return "\(address), \(city), \(state), \(postalCode)"
    }
}

struct Performer: Codable{
    let image: String?
}


struct Location: Codable{
    let lat: Double
    let lon: Double
}
