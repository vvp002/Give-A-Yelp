import Foundation
import CoreLocation
import SceneKit

struct ARItem {
  let itemDescription: String
  let location: CLLocation
  var itemNode: SCNNode?
}
