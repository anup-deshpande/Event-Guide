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
            HStack{
                
                KFImage.url(URL(string: event.performers.first?.image ?? "")!)
                    .resizable()
                    .placeholder{
                        Image(systemName: "photo.on.rectangle")
                    }
                    .fade(duration: 1)
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading){
                    Text(event.title)
                        .font(.body)
                    
                    Text(event.dateTime)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                
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
