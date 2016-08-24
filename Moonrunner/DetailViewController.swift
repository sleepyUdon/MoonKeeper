//
//  DetailViewController.swift
//  Moonrunner
//
//  Created by Viviane Chan on 2016-08-22.
//  Copyright © 2016 Magic Unicorn. All rights reserved.
//

import UIKit
import MapKit
import HealthKit


class DetailViewController: UIViewController, MKMapViewDelegate {

    var run: Run!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    ///  configure the view
    
    func configureView(){
        
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: run.distance.doubleValue)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateLabel.text = dateFormatter.stringFromDate(run.timestamp)
        
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: run.duration.doubleValue)
        timeLabel.text = "Time: " + secondsQuantity.description
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: run.duration.doubleValue / run.distance.doubleValue)
        paceLabel.text = "Pace: " + paceQuantity.description
        
        loadMap()
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    
    /// define the map region
    
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = run.locations.firstObject as! Location
        var minLat = initialLoc.latitude.doubleValue
        var minLng = initialLoc.longitude.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run.locations.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.latitude.doubleValue)
            minLng = min(minLng, location.longitude.doubleValue)
            maxLat = max(maxLat, location.latitude.doubleValue)
            maxLng = max(maxLng, location.longitude.doubleValue)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLng + maxLng)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat-minLat)*1.1, longitudeDelta: (maxLng-minLng)*1.1))
    }
    


    /// Delegate method: drawing polyline overlay of route on top of map
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKindOfClass(MKPolyline) {
            print ("no polyline")
        }
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blackColor()
        renderer.lineWidth = 3
        return renderer
    }
    
    

    
    /// de
    
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run.locations.array as! [Location]
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude.doubleValue,
                longitude: location.longitude.doubleValue))
        }
        
        return MKPolyline(coordinates: &coords, count: run.locations.count)
    }
    
    
    func loadMap() {
        if run.locations.count > 0{
            mapView.hidden = false
            mapView.region = mapRegion()
            mapView.addOverlay(polyline())
        } else {
            mapView.hidden = true
            
            UIAlertView(title: "Error", message: "Sorry, this run has no locations saved", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
}





