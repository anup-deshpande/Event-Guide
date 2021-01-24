//
//  Constants.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import Foundation
import UIKit

struct StoryboardIDKeys{
    static let eventListViewController = "EventListViewController"
    static let eventDetailViewController = "EventDetailViewController"
}

struct CellIdentifiers{
    static let eventTableViewCell = "EventTableViewCell"
}

/// In the event of multiple storyboards added to this project this enum will serve as a starting point for the storyboard instances
/// Add cases to respective storyboards to avoid mistyping the storyboard name in controllers
enum AppStoryboard : String {
    case Main = "Main"
    
    var instance : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
