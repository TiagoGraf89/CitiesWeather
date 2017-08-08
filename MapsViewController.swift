//
//  MapsViewController.swift
//  MultipleTargets
//
//  Created by TIAGO AUGUSTO GRAF on 12/11/16.
//  Copyright © 2016 TIAGO AUGUSTO GRAF. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    weak var item: WeatherItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self // inicializada por padrao
        
        

        
        refresh()
    }
    
    private func refresh() {
        let center = CLLocationCoordinate2D(latitude: self.item!.lat, longitude: self.item!.lon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1.1, longitudeDelta: 1.1))
        
        self.map.setRegion(region, animated: true)
        let point = MKPointAnnotation();
        point.coordinate = center
        point.title = self.item!.name
        #if LITE
                point.subtitle = "Versao Lite: Propagandas Aqui!"
        #endif
        map.addAnnotation(point)
        map.showAnnotations([point], animated: false)
        
    }

    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
