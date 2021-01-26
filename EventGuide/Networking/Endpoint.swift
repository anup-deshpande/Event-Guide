//
//  Router.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import Foundation

enum Endpoint{
    case getEvents
    case searchEvents(keyword: String)
    
    private var clientId: String{
        get{
            // Check if the SeatGeek-Info plist file exist in the bundle
            guard let filePath = Bundle.main.path(forResource: "SeatGeek-Info", ofType: "plist") else{
                fatalError("Couldn't find file 'SeatGeek-Info.plist'.")
            }
            
            // Retrive APIPreferences from the file
            guard let data = FileManager.default.contents(atPath: filePath) else { fatalError("Couldn't read data from plist file") }
            
            let decoder = PropertyListDecoder()
            guard let preferences = try? decoder.decode(APIPreferences.self, from: data) else {
                fatalError("Couldn't decode APIPreference from plist file")
            }
            
            return preferences.clientID
        }
    }
}

extension Endpoint{
    var scheme: String{
        return "https"
    }
    
    var host: String{
        return "api.seatgeek.com"
    }
    
    var path: String{
        switch self{
        case .getEvents,
             .searchEvents:
            return "/2/events"
        }
    }
    
    var method: String{
        switch self{
        case .getEvents,
             .searchEvents:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem]{
        switch self {
        case .getEvents:
            return [URLQueryItem(name: "client_id", value: clientId)]
        case .searchEvents(let keyword):
            return [URLQueryItem(name: "client_id", value: clientId),
                    URLQueryItem(name: "q", value: keyword)]
        }
    }
}
