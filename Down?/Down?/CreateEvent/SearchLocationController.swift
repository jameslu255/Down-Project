//
//  SearchLocationController.swift
//  Down?
//
//  Created by Maxim Chiao on 11/20/19.
//

import UIKit
import MapKit

class SearchLocationController: UITableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  let request = MKLocalSearch.Request()
  var searchResults: [MKPlacemark] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    request.resultTypes = .pointOfInterest
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  func search() {
    var tempList: [MKPlacemark] = []
    let search = MKLocalSearch(request: request)
    guard let query = request.naturalLanguageQuery else { return }
    if (query.isEmpty) {
      if (search.isSearching) {
        search.cancel()
      }
      searchResults = tempList
      tableView.reloadData()
    }
    
    if (search.isSearching) {
      print("cancel search")
      search.cancel()
    }
    search.start { response, error in
      guard let r = response else { print("no r")
        return } // no r if type in gibberish
      if (r.mapItems.isEmpty) {
        print("no results")
      }
      
      for item in r.mapItems {
        print("\(item.name!)")
        tempList.append(item.placemark)
      }
      if (error != nil) {
        print("error")
      }
      
      self.searchResults = tempList
     
    }
    tableView.reloadData()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = searchResults[indexPath.row].name!
    return cell
  }
  

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          // Delete the row from the data source
          tableView.deleteRows(at: [indexPath], with: .fade)
      } else if editingStyle == .insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

}
extension SearchLocationController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let query = searchBar.text else { return }

    request.naturalLanguageQuery = query
    search()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
