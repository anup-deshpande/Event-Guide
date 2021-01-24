//
//  Router.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import Foundation

enum Router{
    case getEvents
    case searchEvents(keyword: String)
    
    private var clientId: String{
        get{
            // Check if the clientId plist file exist in the bundle
            guard let filePath = Bundle.main.path(forResource: "SeatGeek-Info", ofType: "plist") else{
                fatalError("Couldn't find file 'SeatGeek-Info.plist'.")
            }
            
            // Retrive clientId from the file
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let clientId = plist?.object(forKey: "CLIENT_ID") as? String else{
                fatalError("Couldn't find key 'CLIENT_ID' in 'SeatGeek-Info.plist'")
            }
            
            return clientId
        }
    }
}

extension Router{
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
