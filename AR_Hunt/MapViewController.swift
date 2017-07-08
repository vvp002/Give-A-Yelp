
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  var targets = [ARItem]()
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  var selectedAnnotation: MKAnnotation?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }

    setupLocations()
    
  }
  
  func setupLocations() {
    let firstTarget = ARItem(itemDescription: "Building AQ", location: CLLocation(latitude: 32.903159, longitude : -117.192997), itemNode: nil)
    targets.append(firstTarget)
    
    let secondTarget = ARItem(itemDescription: "Grape Street Dog Park", location: CLLocation(latitude: 32.726580, longitude : -117.134531), itemNode: nil)
    targets.append(secondTarget)
    
    let thirdTarget = ARItem(itemDescription: "Villas of Renaissance", location: CLLocation(latitude : 32.870489, longitude : -117.202743), itemNode: nil)
    targets.append(thirdTarget)
    
    for locitem in targets {
      let annotation = MapAnnotation(location: locitem.location.coordinate, item: locitem)
      self.mapView.addAnnotation(annotation)
    }
  }
  
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    self.userLocation = userLocation.location
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let coordinate = view.annotation!.coordinate
    
    if let userCoordinate = userLocation {
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 50 {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
          
          viewController.delegate = self
          
          if let mapAnnotation = view.annotation as? MapAnnotation {
            
            viewController.target = mapAnnotation.item
            viewController.userLocation = mapView.userLocation.location!
            selectedAnnotation = view.annotation
            self.present(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
}

extension MapViewController: ViewControllerDelegate {
  func viewController(controller: ViewController, tappedTarget: ARItem) {
    self.dismiss(animated: true, completion: nil)
    let index = self.targets.index(where: {$0.itemDescription == tappedTarget.itemDescription})
    self.targets.remove(at: index!)
    
    if selectedAnnotation != nil {
      mapView.removeAnnotation(selectedAnnotation!)
    }
  }
}
