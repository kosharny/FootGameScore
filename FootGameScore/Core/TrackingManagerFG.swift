import Foundation
import AppTrackingTransparency
import AdSupport

class TrackingManagerFG {
    static let shared = TrackingManagerFG()
    
    private init() {}
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Tracking authorized")
                // IDFA is available
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                print("Tracking denied")
            case .notDetermined:
                print("Tracking not determined")
            case .restricted:
                print("Tracking restricted")
            @unknown default:
                print("Unknown tracking status")
            }
        }
    }
}
