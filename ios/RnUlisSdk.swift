import Foundation
import UIKit


@objc(RnUlisSdk)
class RnUlisSdk: RCTEventEmitter {

    var window: UIWindow!
    public static var shared: RnUlisSdk?
    var discoverVC: UIViewController!
    var navigationController: UINavigationController!
    
    override init() {
    super.init()
        RnUlisSdk.shared = self
    }
    
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
            self.discoverVC = orderVC as UIViewController
            self.navigationController = UINavigationController(rootViewController: self.discoverVC)
            self.navigationController.navigationBar.isTranslucent = false
            self.window.rootViewController = self.navigationController
            self.window.makeKeyAndVisible()
        }
        
    }
    
    func sendBackEvent(withName: String, body: ResponseBean) -> Void {
        
        
        sendEvent(withName: withName, body: body.data)
        print("Event sent >>", withName)
        print("Received Data: " ,body)

        return
    }
}
