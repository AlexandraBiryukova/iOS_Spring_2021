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
    var places: FetchedResults<Place>
    var control: MapView
    var gRecognizer = UILongPressGestureRecognizer()
    
    @Binding var newPlaceLocation: CLLocationCoordinate2D?
    @Binding var selectedIndex: Int?
    @Binding var index: Int?
    
    init(_ control: MapView,
         places: FetchedResults<Place>,
         newPlaceLocation: Binding<CLLocationCoordinate2D?>?,
         selectedIndex: Binding<Int?>,
         index: Binding<Int?>){
        self.control = control
        self.places = places
        self._newPlaceLocation = newPlaceLocation ?? Binding.constant(nil)
        self._selectedIndex = selectedIndex
        self._index = index
        super.init()
        self.gRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        self.gRecognizer.delegate = self
        self.control.mapView.addGestureRecognizer(gRecognizer)
    }
    
    @objc
    func tapHandler(_ gesture: UILongPressGestureRecognizer) {
        let location = gRecognizer.location(in: self.control.mapView)
        let coordinate = self.control.mapView.convert(location, toCoordinateFrom: self.control.mapView)
        index = nil
        newPlaceLocation = coordinate
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedIndex = places.firstIndex(where: { ($0.latitude == view.annotation?.coordinate.latitude) &&
            ($0.longitude == view.annotation?.coordinate.longitude)
        })
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
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mapView.setRegion(.init(center: view.annotation?.coordinate ?? mapView.centerCoordinate, span: span), animated: true)
    }
}

struct MapView: UIViewRepresentable {
    @Binding var mapType: String
    @Binding var newPlaceLocation: CLLocationCoordinate2D?
    @Binding var index: Int?
    @Binding var selectedIndex: Int?
    
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
        context.coordinator.places = places
        uiView.addAnnotations(places.map {
            let annotation = MKPointAnnotation()
            annotation.coordinate = $0.coordinate
            annotation.title = $0.name
            annotation.subtitle = $0.message
            return annotation
        })
        guard let index = index,
              let annotation = uiView.annotations.first(where: {
                $0.coordinate.latitude == places[index].latitude &&
                    $0.coordinate.longitude == places[index].longitude
              }) else { return }
        if !uiView.annotations(in: uiView.visibleMapRect).contains(where: { $0.hashValue == annotation.hash }) {
            uiView.showAnnotations(uiView.annotations, animated: true)
        }
        uiView.selectAnnotation(annotation, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self,
                           places: places,
                           newPlaceLocation: $newPlaceLocation,
                           selectedIndex: $selectedIndex,
                           index: $index)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(CLLocation(latitude: self.latitude, longitude: self.longitude))
    }
}
