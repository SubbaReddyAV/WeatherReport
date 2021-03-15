//
//  LocationsTableViewController.swift
//  Weather
//
//  Created by SubbaReddy on 12/3/2564 BE.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
    func setupSearchText(cityName: String, countryName: String)
}
class LocationsTableViewController: UITableViewController {
    weak var handleMapSearchDelegate: HandleMapSearch?
    var mapView: MKMapView? = nil
    var matchingItems:[MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func parseAddress(selectedItem: MKPlacemark) -> (String, String) {
        
        let cityData = selectedItem.addressDictionary?.filter { "\($0.key)" == "City" }.first
        let countryData = selectedItem.addressDictionary?.filter { "\($0.key)" == "Country" }.first
        
        let city: String = "\(cityData?.value ?? "")"
        let country: String = "\(countryData?.value ?? "")"
        return (city, country)
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        let data = parseAddress(selectedItem: selectedItem)
        cell.textLabel?.text = data.0
        cell.detailTextLabel?.text = data.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        let data = parseAddress(selectedItem: selectedItem)
        handleMapSearchDelegate?.setupSearchText(cityName: data.0,
                                                 countryName: data.1)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationsTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
}
