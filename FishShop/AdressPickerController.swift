
//
//  File.swift
//  Test3
//
//  Created by Мурат Кудухов on 23.04.2024.
//

import UIKit
import MapKit

protocol AddressPickerDelegate: AnyObject {
    func addressDidPick(_ address: String)
}

final class AddressPickerViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    var mapView: MKMapView!
    weak var delegate: AddressPickerDelegate?
    var zoomInButton = UIButton()
    var zoomOutButton = UIButton()
    var searchBar = UISearchBar()
    var printAddressButton = UIButton()
    
    var adress = ""
    
    
    let cityRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.02523, longitude: 44.66598), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    let someRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.02550, longitude: 44.66600),
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupGestureRecognizer()
        focusOnVld()
        setupConstraints()
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let currentRegion = mapView.region  // Получение текущего региона карты
        let result = cityRegion.includes(region: currentRegion)  // Проверяем, включает ли cityRegion текущий регион
        if !result {
            mapView.setRegion(cityRegion, animated: true)
        } else {
        }
    }

    
    func setupMapView() {
        mapView = MKMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.backgroundColor = .gray.withAlphaComponent(0.5)
        zoomInButton.layer.masksToBounds = true
        zoomInButton.layer.cornerRadius = 10
        zoomInButton.tintColor = .white
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        view.addSubview(zoomInButton)
        
        // Создание кнопки уменьшения масштаба
        zoomOutButton = UIButton(type: .system)
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.tintColor = .white
        zoomOutButton.layer.masksToBounds = true
        zoomOutButton.layer.cornerRadius = 10
        zoomOutButton.backgroundColor = .gray.withAlphaComponent(0.5)
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        // Вызов функции для настройки constraints
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Введите адрес"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        printAddressButton = UIButton(type: .system)
        printAddressButton.translatesAutoresizingMaskIntoConstraints = false
        printAddressButton.setTitle("Вывести адрес", for: .normal)
        printAddressButton.addTarget(self, action: #selector(printAddress), for: .touchUpInside)
        view.addSubview(printAddressButton)
        
        
    }
    
    @objc func printAddress() {
        let center = mapView.centerCoordinate
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                return
            }
            if let placemark = placemarks?.first {
                let address = [placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.postalCode, placemark.country].compactMap {$0}.joined(separator: ", ")
            }
        }
    }

    func setupConstraints() {
            NSLayoutConstraint.activate([
                printAddressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                printAddressButton.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -10),
                printAddressButton.heightAnchor.constraint(equalToConstant: 100),
                printAddressButton.widthAnchor.constraint(equalToConstant: 100),
                
                // Constraints для mapView
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
                
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
                
                // Constraints для zoomInButton
                zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                zoomInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                zoomInButton.heightAnchor.constraint(equalToConstant: 40),
                zoomInButton.widthAnchor.constraint(equalToConstant: 40),

                // Constraints для zoomOutButton
                zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                zoomOutButton.bottomAnchor.constraint(equalTo: zoomInButton.topAnchor, constant: -10),
                zoomOutButton.heightAnchor.constraint(equalToConstant: 40),
                zoomOutButton.widthAnchor.constraint(equalToConstant: 40),
            ])
        }
    
    @objc func zoomIn() {
        adjustZoom(byFactor: 0.5)
    }

    @objc func zoomOut() {
        adjustZoom(byFactor: 2)
    }
    
    func adjustZoom(byFactor factor: Double) {
            let span = mapView.region.span
            let newSpan = MKCoordinateSpan(latitudeDelta: span.latitudeDelta * factor, longitudeDelta: span.longitudeDelta * factor)
            let newRegion = MKCoordinateRegion(center: mapView.region.center, span: newSpan)
            mapView.setRegion(newRegion, animated: true)
    }
    
    // UISearchBar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let address = searchBar.text {
            searchForAddress(address)
            adress = address
        }
    }
    
    func searchForAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                
                strongSelf.mapView.setRegion(region, animated: true)
                
                UserSettings.adress = []
                UserSettings.adress.append([])
                UserSettings.adress[0].append(.init(adress: self!.adress, latitude: region.center.latitude, longitude: region.center.longitude))
                
            }
        }
    }
    
    func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)

        addPinToMap(at: coordinates)
        fetchAddress(from: coordinates)
    }
    
    func addPinToMap(at coordinates: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    func focusOnVld() {
        let vldCoordinates = CLLocationCoordinate2D(latitude: 43.02523, longitude: 44.66598) // Координаты Москвы
        let regionRadius: CLLocationDistance = 10000 // Радиус в метрах, коий определяет зону видимости

        // Создаем регион вокруг Москвы 43.02523 44.66598
        let region = MKCoordinateRegion(center: vldCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
       
        //UserSettings.adress[0].append(.init(adress: addressString, latitude: coordinates.latitude, longitude: coordinates.longitude))
        // Устанавливаем регион в mapView (предполагается, что под этим именем у вас есть переменная для MKMapView)
        mapView.setRegion(region, animated: true)
    }
    
    func fetchAddress(from coordinates: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self, let placemark = placemarks?.first, error == nil else {
                return
            }
            // Получение полного адреса
            var addressString = ""
            if let city = placemark.locality {
                addressString += "г. \(city), "
            }
            if let street = placemark.thoroughfare, let building = placemark.subThoroughfare {
                addressString += "\(street) \(building)"
            }
//            if let region = placemark.administrativeArea {
//                //addressString += "\(region), "
//            }
//            if let postalCode = placemark.postalCode {
//                //addressString += "\(postalCode), "
//            }
//            if let country = placemark.country {
//                //addressString += country
//            }
            
            DispatchQueue.main.async {
                //self.displayAddressAlert(address: addressString)
                self.delegate?.addressDidPick(addressString)
                self.dismiss(animated: true)
            }
        }
    }
    
    func displayAddressAlert(address: String) {
        let alertController = UIAlertController(title: "Selected Location", message: address, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension MKCoordinateRegion {
    /// Проверяет, что центр кандидата находится внутри данного региона, и что корнеры кандидата не выходят за пределы
    func includes(region candidate: MKCoordinateRegion) -> Bool {
        let center = candidate.center
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + candidate.span.latitudeDelta / 2,
                                               longitude: center.longitude + candidate.span.longitudeDelta / 2)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - candidate.span.latitudeDelta / 2,
                                               longitude: center.longitude - candidate.span.longitudeDelta / 2)
        
        let selfNorthEast = CLLocationCoordinate2D(latitude: self.center.latitude + self.span.latitudeDelta / 2,
                                                    longitude: self.center.longitude + self.span.longitudeDelta / 2)
        let selfSouthWest = CLLocationCoordinate2D(latitude: self.center.latitude - self.span.latitudeDelta / 2,
                                                    longitude: self.center.longitude - self.span.longitudeDelta / 2)
        
        return northEast.latitude <= selfNorthEast.latitude &&
               southWest.latitude >= selfSouthWest.latitude &&
               northEast.longitude <= selfNorthEast.longitude &&
               southWest.longitude >= selfSouthWest.longitude
    }
    
}

