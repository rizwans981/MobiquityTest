//
//  LocationSearchTable.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import UIKit
import MapKit


class LocationSearchTable: UITableViewController {
    
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    private var matchingPlacemarks = [Placemark]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


}


extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,let keywords = searchController.searchBar.text else { return }
        
          MapMananger.fetchLocalSearch(with: keywords, region: mapView.region) { (status) in
              switch status {
              case .success(let response):
                  self.matchingPlacemarks = response.mapItems.map{ Placemark(mkPlacemark: $0.placemark) }
              case .failure(let error):
                  return
              }
              self.tableView.reloadData()
          }
    }
}

extension LocationSearchTable {
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingPlacemarks.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let placemark = matchingPlacemarks[indexPath.row]
        cell.textLabel?.text = placemark.name
        cell.detailTextLabel?.text = placemark.title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placemark = matchingPlacemarks[indexPath.row]
        handleMapSearchDelegate?.dropPinZoomIn(placemark: placemark)
        dismiss(animated: true, completion: nil)
    }
    
    }


