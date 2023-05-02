import Foundation
import UIKit


@objc(RnUlisSdk)
class RnUlisSdk: RCTEventEmitter {

    var window: UIWindow!
    
    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve: RCTPromiseResolveBlock,reject: RCTPromiseRejectBlock) -> Void
    {
        resolve(a*b)
    }
    
     override func supportedEvents() -> [String] {
       ["Telr::PAYMENT_SUCCESS", "Telr::PAYMENT_ERROR", "Telr::PAYMENT_CANCELLED"]      // etc.
     }
    
     override class func requiresMainQueueSetup() -> Bool {
         return true
     }
    
    @objc(open:)
    func open(option: [String: AnyObject]) -> Void{

        DispatchQueue.main.async {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let orderVC = OrderViewController()
            orderVC.orderAction = "create"
            let discoverVC = orderVC as UIViewController
            let navigationController = UINavigationController(rootViewController: discoverVC)
            navigationController.navigationBar.isTranslucent = false
            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
        
//         resolve(option)
//        sendEvent(withName: "Telr::PAYMENT_SUCCESS", body: "Hellllooooo")
    }
    
    
}
