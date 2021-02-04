//
//  MainView.swift
//  EventGuide
//
//  Created by Anup Deshpande on 2/3/21.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    
    @State private var events = [Event]()
    
    var body: some View {
        List(events, id: \.id){ event in
            VStack(alignment: .leading){
                
                KFImage.url(URL(string: event.performers.first?.image ?? "")!)
                    .resizable()
                    .placeholder{
                            Image(systemName: "photo.on.rectangle")}
                
                Text(event.title)
                    .font(.body)
                
                
                /*
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
                 */
            }
        }
        .onAppear(perform: fetchEvents)
    }
    
    func fetchEvents(){
        // Refresh events from the API
        NetworkService.request(endpoint: .getEvents) { (result: Result< EventList, Error>) in
            switch result{
            case .success(let eventList):
                DispatchQueue.main.async {
                    events = eventList.events
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
