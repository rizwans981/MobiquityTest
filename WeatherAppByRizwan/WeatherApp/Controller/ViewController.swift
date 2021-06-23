//
//  ViewController.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import UIKit
import MapKit


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:Placemark)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var citiesList: UITableView!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    var emptyLabel:UILabel!
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil

    private var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UINavigationBar.appearance().barTintColor = appColor
        locationManagerFunction()
        setUpSearchController()
        setUpSearchbar()
        userInterfaceModifications()
        
        //setup viewmodel
        viewModel.viewModelDelegate = self
    }
    
    func locationManagerFunction(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setUpSearchController(){
        let locationSearchTable = UIStoryboard(name: "SearchResults", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapview
        locationSearchTable.handleMapSearchDelegate = self

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func setUpSearchbar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
    }
    
    func userInterfaceModifications(){
        infoButton.applyButtonCornerRadius(_cornerRadius: 10)
    }
    
    @IBAction func editCityList(_ sender: UIBarButtonItem) {
        self.citiesList.isEditing = !self.citiesList.isEditing
        sender.title = (self.citiesList.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func infoButton(_ sender: Any) {
        let webview = storyboard?.instantiateViewController(identifier: "RulesScreenController") as! RulesScreenController
        present(webview, animated: true, completion: nil)
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapview.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("manager didFailWithError: \(error.localizedDescription)")
    }
}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:Placemark){
        viewModel.prepareMapViewDataGiven(placemark: placemark)
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.tableFeed[indexPath.row]
        let cityView = storyboard?.instantiateViewController(identifier: "CityScreenController") as! CityScreenController
        cityView.cityModelView = CityViewModel.init(latitude: data["latitude"] as? Double ?? 0, longitude: data["longitude"] as? Double ?? 0)
        self.navigationController?.pushViewController(cityView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coordinates = viewModel.tableFeed[indexPath.row]
            
            viewModel.tableFeed.remove(at: indexPath.row)
            viewModel.removeAnnotation(latitude: (coordinates["latitude"]) as! Double, longitude: coordinates["longitude"] as! Double)
            
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.tableFeed.count == 0{
            displayEmptyString()
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
              return 0
          } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return viewModel.tableFeed.count
          }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = viewModel.tableFeed[indexPath.row]
        cell.textLabel?.text = (data["name"] as! String)
        return cell
    }
    
    func displayEmptyString() {
         emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
          emptyLabel.textColor = lightGrey
          emptyLabel.text = "Search for cities in the above search bar"
          emptyLabel.textAlignment = NSTextAlignment.center
    }
}

extension ViewController: HomeViewModelProtocol{
    func reloadHomeScreenAfterAnnotation(annotationToRemoce: MKPointAnnotation) {
        
        for annotations in mapview.annotations{
            if annotations.coordinate == annotationToRemoce.coordinate {
                mapview.removeAnnotation(annotations)
            }
        }
    }
    

    
    func reloadHomeScreenWith(annotation: MKPointAnnotation) {
        resultSearchController?.searchBar.text  = nil
        mapview.addAnnotation(annotation)
        citiesList.reloadData()
        let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }
}

