//
//  MainView.swift
//  EventGuide
//
//  Created by Anup Deshpande on 2/3/21.
//

import SwiftUI
import Kingfisher

struct EventListView: View {
    
    @State private var events = [Event]()
    
    var body: some View {
        NavigationView{
            List(events, id: \.id){ event in
                NavigationLink(destination: EventDetailsView(event: event)){
                    HStack{
                    
                    KFImage.url(URL(string: event.performers.first?.image ?? "")!)
                        .resizable()
                        .placeholder{
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading){
                        Text(event.title)
                            .font(.system(size: 17))
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        Text(event.dateTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    
                }
                }
            }
            .onAppear(perform: fetchEvents)
            .navigationBarTitle(Text("Event Guide"), displayMode: .inline)
        }
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
        EventListView()
    }
}
