//
//  ViewController.swift
//  PM2_Practica12_CalcularRutaMapas
//
//  Created by Alexander Tapia on 18/05/22.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,UISearchBarDelegate, MKMapViewDelegate {
    // conexxiones
    @IBOutlet weak var buscadorSB: UISearchBar!
    @IBOutlet weak var mapaMk: MKMapView!
    
    //variables
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    var altitud: Double?
    //Manager para ser uso del GPS
    var manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buscadorSB.delegate = self
        manager.delegate = self
        mapaMk.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        //mejorar la precision de la ubicacion
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //monitoriar en todo momento la ubicacion
        manager.startUpdatingLocation()
    }

    @IBAction func ubicacionButtom(_ sender: UIBarButtonItem) {
        print("error al tener en un a ubicacion ")
        let alerta = UIAlertController(title: "error", message: "Lat:\(latitud ?? 0) Lon:\(longitud ?? 0)", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(accionOk)
        present(alerta, animated: true)
        
        //hacer zoom a la ubicacion del  usuario
        
        let localizacion = CLLocationCoordinate2D(latitude: latitud ?? 0, longitude: longitud ?? 0)
        let spanMapa = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: localizacion, span: spanMapa)
        //asignar al mapa los objetos
        mapaMk.setRegion(region, animated: true)
        mapaMk.showsUserLocation = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("buscar:\(searchBar.text)")
        buscadorSB.resignFirstResponder()
        let geocoder = CLGeocoder()
        
        //crear una variable segura
        if let direccion = buscadorSB.text {
            geocoder.geocodeAddressString(direccion) { (places: [CLPlacemark]?, error: Error?) in
                //crear el destino
                guard let destinoRuta = places?.first?.location else {return}
                
                if error == nil {
                    let lugar = places?.first
                    let anotacion = MKPointAnnotation()
                    anotacion.coordinate = (lugar?.location?.coordinate)!
                    anotacion.title = direccion
                    
                    //el span es el nivel de zoom que se hara el mpa
                    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                    // agregar esa anotacion al mapa
                    self.mapaMk.setRegion(region, animated: true)
                    self.mapaMk.addAnnotation(anotacion)
                  //  self.trazarRuta
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func trazarRuta(coordenadasDestino:CLLocationCoordinate2D){
        
        guard let coordOrigen = manager.location?.coordinate else {return}
        
        //origen destino
        let origenPlacerMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenadasDestino)
        
        //obj tipo mapkit
        
        
        
        
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("numero de ubicaciones\(locations.count)")
        //Crear una ubicacion
        guard let ubicacion = locations.first else {
            return
        }
        
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        altitud = ubicacion.altitude
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error al tener en un a ubicacion ")
        let alerta = UIAlertController(title: "error", message: "Al obtener la ubicacion", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(accionOk)
        present(alerta, animated: true)
    }
}

