//
//  MapView.swift
//  Places
//
//  Created by Alexandra Biryukova on 2/20/21.
//

import Foundation
import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var control: MapView
    var gRecognizer = UILongPressGestureRecognizer()
    
    @Binding var newPlaceLocation: CLLocationCoordinate2D?
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var currentLocation: CLLocationCoordinate2D?
    
    init(_ control: MapView,
         newPlaceLocation: Binding<CLLocationCoordinate2D?>?,
         selectedLocation: Binding<CLLocationCoordinate2D?>?,
         currentLocation: Binding<CLLocationCoordinate2D?>?){
        self.control = control
        self._newPlaceLocation = newPlaceLocation ?? Binding.constant(nil)
        self._selectedLocation = selectedLocation ?? Binding.constant(nil)
        self._currentLocation = currentLocation ?? Binding.constant(nil)
        super.init()
        self.gRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        self.gRecognizer.delegate = self
        self.control.mapView.addGestureRecognizer(gRecognizer)
        
    }
    
    @objc
    func tapHandler(_ gesture: UILongPressGestureRecognizer) {
        let location = gRecognizer.location(in: self.control.mapView)
        let coordinate = self.control.mapView.convert(location, toCoordinateFrom: self.control.mapView)
        currentLocation = nil
        newPlaceLocation = coordinate
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedLocation = view.annotation?.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        mapView.setRegion(.init(center: view.annotation?.coordinate ?? mapView.centerCoordinate,
                                span: span),
                          animated: true)
        currentLocation = view.annotation?.coordinate
    }
}

struct MapView: UIViewRepresentable {
    @Binding var mapType: String
    @Binding var newPlaceLocation: CLLocationCoordinate2D?
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var currentLocation: CLLocationCoordinate2D?
    
    let mapView = MKMapView()
    
    var places: FetchedResults<Place>
    var mapTypeDict: [String: MKMapType] = [
        "Normal": .standard,
        "Hybrid": .hybrid,
        "Satellite": .satellite
    ]
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.mapType = mapTypeDict[mapType] ?? .standard
        uiView.removeAnnotations(uiView.annotations)
        
        uiView.addAnnotations(places.map {
            let annotation = MKPointAnnotation()
            annotation.coordinate = $0.coordinate
            annotation.title = $0.name
            annotation.subtitle = $0.message
            return annotation
        })
        
        guard let annotation = uiView.annotations.first(where: {
            $0.coordinate.latitude == currentLocation?.latitude &&
                $0.coordinate.longitude == currentLocation?.longitude
        }) else { return }
        uiView.showAnnotations(uiView.annotations, animated: true)
        uiView.selectAnnotation(annotation, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self,
                           newPlaceLocation: $newPlaceLocation,
                           selectedLocation: $selectedLocation,
                           currentLocation: $currentLocation)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(CLLocation(latitude: self.latitude, longitude: self.longitude))
    }
}
