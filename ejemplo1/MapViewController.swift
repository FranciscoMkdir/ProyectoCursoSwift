//
//  MapViewController.swift
//  ejemplo1
//
//  Created by macbook on 23/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var tableView: UITableView!{didSet{
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        }}
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var directions = [Direction]()
    var locationUser: CLLocationCoordinate2D?
    var route: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rutas de distribución"
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        fetchEmployees()
    }
    
    private func fetchEmployees(){
        activityIndicator.startAnimating()
        Webservice().loadAllEmployees { [weak self] (result) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let result = result else {return}
                self?.addEmployes(employees: result)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func addEmployes(employees: [Employee]){
        for employee in employees{
            guard let address = employee.address else {return}
            _ = getCoordinateFrom(address: address) { (placemarks) in
                let direction = Direction(employee: employee, placemarks: placemarks)
                self.directions.append(direction)
                let indexPath = IndexPath(item: self.directions.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    private func addAnnotationToMap(direction: Direction){
        guard let location = direction.placemarks.first?.location else {return}
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let annotation =  MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = direction.placemarks.first?.thoroughfare ?? ""
        mapView.addAnnotation(annotation)
    }
    
    
    private func getCoordinateFrom(address: String?, completion: @escaping ([CLPlacemark]) ->()){
        guard let address = address else {return completion([])}
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks else {
                return completion([])
            }
            return completion(placemarks)
            
        }
        return completion([])
    }
    
    
    @IBAction func showListDirections() {
        showTableView(true)
    }
    
    private func showTableView(_ show: Bool){
        let animation = UIViewPropertyAnimator(duration: 0.35, dampingRatio: 0.9) {
            self.viewList.transform =  show ? .identity : CGAffineTransform(translationX: 0, y: self.view.frame.height * 0.9)
        }
        animation.startAnimation()
    }
    
    private func showRoute(direction:  Direction){
        guard let locationUser = locationUser else {return}
        if direction.placemarks.isEmpty { return }
        showTableView(false)
        addAnnotationToMap(direction: direction)
        drawDirection(locationUser: locationUser, direction: direction)
    }
    
    private func drawDirection(locationUser: CLLocationCoordinate2D, direction: Direction){
        guard let destination = direction.placemarks.first else {return}
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: locationUser))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(placemark: destination))
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (result, error) in
            guard let result = result,
                  let route = result.routes.first else {
                    self?.showErrorAlert(message: "No se encontro ninguna ruta")
                    return
            }
            self?.mapView.addOverlay(route.polyline)
            self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    
    
    private func showErrorAlert(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RouteTableViewCell else {
            fatalError("Error reusable cell RouteTableViewcell")
        }
        cell.selectionStyle = .none
        cell.direction = directions[safe: indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let direction = directions[safe: indexPath.row] else {return}
        showRoute(direction: direction)
    }
}


extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.lineWidth = 2.0
        return polyLineRenderer
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {return}
        locationUser = lastLocation.coordinate
    }
}
