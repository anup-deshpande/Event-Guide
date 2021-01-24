//
//  ViewController.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import UIKit
import RealmSwift

class EventListViewController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!

    let realm = try! Realm()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var events = [Event]()
    
    // Variable property to reference favorite events stored in Realm
    var favoriteEventIDs = [RealmEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        fetchEvents()
    }
    
    func fetchEvents(){
        
        // Refresh favorite event IDs
        favoriteEventIDs = Array(realm.objects(RealmEvent.self))
        
        // Refresh events from the API
        ServiceLayer.request(router: .getEvents) { [weak self] (result: Result< EventList, Error>) in
            switch result{
            case .success(let eventList):
                self?.events = eventList.events
                self?.eventsTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

// MARK: - Search bar controller delegate methods
extension EventListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ServiceLayer.request(router: .searchEvents(keyword: searchText)) { [weak self] (result: Result<EventList,Error>) in
            switch result{
            case .success(let eventList):
                self?.events = eventList.events
                self?.eventsTableView.reloadData()
            case .failure(let error):
                print("Error fetching search result for search term : \(searchText) with error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Table view methods
extension EventListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEvent = events[indexPath.row]
        
        let storyboard = AppStoryboard.Main.instance
        let eventDetailVC = storyboard.instantiateViewController(identifier: StoryboardIDKeys.eventDetailViewController) as! EventDetailViewController
        
        eventDetailVC.event = selectedEvent
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
        
    }
}

extension EventListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.eventTableViewCell, for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        
        if favoriteEventIDs.contains(where: { $0.id == event.id }){
            eventCell.isFavorite = true
        }else{
            eventCell.isFavorite = false
        }
        
        eventCell.event = event
        return eventCell
    }
    
}


