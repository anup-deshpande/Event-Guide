//
//  EventDetailsView.swift
//  EventGuide
//
//  Created by Anup Deshpande on 2/4/21.
//

import SwiftUI
import Kingfisher

struct EventDetailsView: View {

    @Environment(\.presentationMode) var presentationMode
    let event: Event

    var body: some View {
        
        ZStack(alignment: .topLeading){
            ScrollView{
                
                GeometryReader{ geometry in
                    // Event Image
                    KFImage(URL(string: event.performers.first?.image ?? "")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: getHeightForHeaderImage(geometry))
                        .clipped()
                        .offset(x: 0, y: getOffsetForHeaderImage(geometry))
                }.frame(height: 300)
                
                VStack(spacing: 20){
                    
                    // Event title and date
                    HStack{
                        VStack(alignment: .leading, spacing: 0){
                            Text(event.title)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            
                            Text(event.dateTime)
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Buttons
                    HStack{
                        Button(action: {
                            favoriteTapped()
                        }, label: {
                            Image(systemName: "heart")
                            Text("Favorite")
                        })
                        .foregroundColor(.white)
                        .frame(width: 130, height: 35)
                        .background(Color(UIColor.systemGreen))
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        
                        Link(destination: URL(string: event.url)!, label: {
                            Image(systemName: "ticket")
                            Text("Find Tickets")
                        })
                        .foregroundColor(.white)
                        .frame(width: 150, height: 35)
                        .background(Color(UIColor.systemIndigo))
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Event venue and Map Link
                    HStack{
                        VStack(alignment: .leading, spacing: 0){
                            Text(event.venue.nameV2)
                                .font(.callout)
                            
                            Text(event.venue.fullAddress)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer().frame(height: 10)
                            
                            Button(action: {
                                openMapsWithLocation(with: event.venue.nameV2)
                            }, label: {
                                Text("Get Directions")
                            })
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }

            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
            }
            .padding(10)
            .background(Color(UIColor.systemGray))
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .offset(x: 10)

        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat{
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat{
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0{
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat{
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0{
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    func favoriteTapped(){
        print("Favorite tapped")
    }
    
    func openMapsWithLocation(with addr: String){
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
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event(id: 5357405, datetimeUtc: Date(), venue: Venue(state: "KS", nameV2: "Bramlage Coliseum", postalCode: "66502", name: "Bramlage Coliseum", location: Location(lat: 39.2004, lon: -96.5938), address: "1800 College Ave", city: "Manhattan", displayLocation: "Manhattan, KS"), performers: [
            Performer(image: "https://seatgeek.com/images/performers-landscape/kansas-state-wildcats-womens-basketball-16807d/9648/huge.jpg"),
            Performer(image: "https://seatgeek.com/images/performers-landscape/oklahoma-state-cowgirls-womens-basketball-708481/9624/huge.jpg")
        ], datetimeLocal: Date(), timeTbd: false, shortTitle: "Oklahoma State (Women) at Kansas State (Women)", url: "https://seatgeek.com/oklahoma-state-cowgirls-at-kansas-state-wildcats-womens-basketball-tickets/ncaa-womens-basketball/2021-01-25-4-pm/5357405", dateTbd: false, title: "Oklahoma State Cowgirls at Kansas State Wildcats Womens Basketball")
        EventDetailsView(event: event)
    }
}
