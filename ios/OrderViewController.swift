//
//  OrderViewController.swift
//  RnUlisSDK
//
//  Created by Hydrus on 20/04/23.
//

import UIKit

class OrderViewController: UIViewController {

    var window: UIWindow!
    
    var screenCallback : ((ResponseBean) -> Void)?
    var checkoutCallback : ((String, String) -> Void)?
    var receiptScreenCallback : ((ResponseBean) -> Void)?
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    var timer = Timer()
    var orderAction: String = ""
    var mOrderId: String = ""
    var mToken: String = ""
    var loderWarningGif: UIImage!
    var message = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        showProgressMessage(labelText: "Please wait order in process")
        startLoading()
        
        /**
         * Screen Callback
         * From Checkout Controller
         */
        checkoutCallback = { order_id, token in
            //Do what you want in here!
            print("callback -->")
            
            // API Call
            self.checkOrderStatusAPICall()
        }
        
        /**
         * Screen Callback
         * From Checkout Controller
         */
        receiptScreenCallback = { responseBean in
            //Do what you want in here!
            print("callback from receipt -->")
            self.performSegueToReturnBack(response: responseBean)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(message)
        
        if(self.orderAction == "create"){
            print("Create order........")
            // API Call
            self.createOrderAPICall()
        }else{
            print("Check order........")
            showProgressMessage(labelText: "Please wait transaction in process")
            // API Call
            self.checkOrderStatusAPICall()
        }
        
//        let postResponse = ResponseBean()
//        postResponse.message = "Testing"
//        postResponse.status = 200
//        postResponse.data = [
//            "merchant_details": [
//                "theme": "light-layout",
//                "icon": "",
//                "logo": "https://ulis.live:4010/static/files/tila-logo.svg",
//                "use_logo": "",
//                "we_accept_image": "",
//                "brand_color": "#4c64e6",
//                "accent_color": "#4c64e6",
//                "branding_language": "VkNqVEs0VklmNHk3VWhtUWt1UzdsQT09",
//                "merchant_name": "Tila",
//                "company_details": [
//                    "fav_icon": "https://ulis.live:4010/static/images/fav_icon-1672899475914-616922036.png",
//                    "logo": "",
//                    "letter_head": "https://ulis.live:4010/static/images/letter_head-1664887583604-274870745.png",
//                    "footer_banner": "https://ulis.live:4010/static/images/footer_banner-1672897702594-924587242.png",
//                    "title": ""
//                ]
//            ],
//            "order_details": [
//                "order_id": "ORD5927096371",
//                "name": "My Store",
//                "email": "golu.r@ulistechnology.com",
//                "mobile_no": "8909890986",
//                "amount": "366.45",
//                "currency": "AED",
//                "status": "PENDING",
//                "return_url": "https://dev.tlr.fe.ulis.live/merchant/payment/status",
//                "success_url": "https://ulis.live/status.php",
//                "failed_url": "https://ulis.live/failed.php",
//                "cancel_url": "https://ulis.live/cancel.php",
//                "psp_name": "mashreq",
//                "merchant_url": "https://test-gateway.mastercard.com",
//                "env": "live"
//            ],
//            "prefer_lang": "VkNqVEs0VklmNHk3VWhtUWt1UzdsQT09"
//        ]
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let receiptVC = ReceiptViewController()
//        receiptVC.responseBean = postResponse
//        let navigationController = UINavigationController(rootViewController: receiptVC)
//        navigationController.navigationBar.isTranslucent = false
//        self.window.rootViewController = navigationController
//        self.window.makeKeyAndVisible()
        
    }
    
    /**
     * API Call
     * Create Order
     */
    func createOrderAPICall(){
        
        let url = "https://ulis.live:4014/api/v1/orders/create"
        let parameters: [String: Any] = [
            "data": ["customer_details": [
                "name": "My Store",
                "email": "golu.r@ulistechnology.com",
                "mobile": "8909890986"
            ],
            "billing_details": [
                "address_line1": "Wardhman nagar ,nagpur",
                "address_line2": "",
                "country": "India",
                "city": "Nagpur",
                "pin": "440001",
                "province": "Maharastra"
            ],
            "shipping_details": [
                "address_line1": "Wardhman nagar ,nagpur",
                "address_line2": "",
                "country": "India",
                "city": "Nagpur",
                "pin": "440001",
                "province": "Maharastra"
            ],
            "order_details": [
                "order_id": randomStringWithLength(len: 7),
                "amount": "366.45",
                "currency": "AED",
                "description": "TShirt",
                "return_url": "https://dev.tlr.fe.ulis.live/merchant/payment/status"
            ],
            "mobile_sdk": "1",
            "merchant_urls": [
                "success": "https://ulis.live/status.php",
                "cancel": "https://ulis.live/cancel.php",
                "failure": "https://ulis.live/failed.php"
            ],
            "transaction": ["class": "ECOM"]
            
            ]
        ]
        
        ApiManager.creatOrderApiRequest(url: url, parameters: parameters, completion: apiCallback)
    }
    
    /**
     * Callback
     * Create Order Callback
     */
    func apiCallback(response: ResponseBean) -> () {
        
        print ("Response = \(response.data)")
        
        // Stop loading indicator
        DispatchQueue.main.async {self.stopLoading()}
        
        if response.status == 200 {
            
            if let Response = response.data as? [String : Any]{
                
                let status = Response["status"] as? String
                let message = Response["message"] as? String
                let successUrl = response.successUrl
                let cancelUrl = response.cancelUrl
                let failuerUrl = response.failuerUrl
                
                if (status! == "success"){
                    
                    if let Data = Response["data"] as? [String : Any]{
                        let order_id = Data["order_id"] as? String
                        let token = Data["token"] as? String
                        let payment_link = Data["payment_link"] as? String
//                        let amount = Data["amount"] as? String
//                        let status = Data["status"] as? String
                       
                        mOrderId = order_id!
                        mToken = token!
                        
                        DispatchQueue.main.async {
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let discoverVC = CheckoutViewController()
                            discoverVC.order_id = order_id!
                            discoverVC.token = token!
                            discoverVC.paymentLink = payment_link!
                            discoverVC.successUrl = successUrl
                            discoverVC.cancelUrl = cancelUrl
                            discoverVC.failureUrl = failuerUrl
                            let navigationController = UINavigationController(rootViewController: discoverVC)
                            navigationController.navigationBar.isTranslucent = false
                            self.window.rootViewController = navigationController
                            self.window.makeKeyAndVisible()
                        }
                    }
                    
                } else {
                    
                    // Update status label an image
                    DispatchQueue.main.async {
//                        self.loaderImageView.image = self.loderWarningGif
//                        self.statusLabel.text = message!
                        self.showProgressMessage(labelText: message!)
                    }
                    
                    // Post result back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        let postResponse = ResponseBean()
                        postResponse.message = message!
                        postResponse.status = response.status
                        self.performSegueToReturnBack(response: postResponse)
                    })
                    
                }
                
            }
            
        }else{
            // Update status label an image
            DispatchQueue.main.async {
//                self.loaderImageView.image = self.loderWarningGif
//                self.statusLabel.text = response.message
                self.showProgressMessage(labelText: response.message)
            }
            
            // Post result back
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                let postResponse = ResponseBean()
                postResponse.message = response.message
                postResponse.status = response.status
                self.performSegueToReturnBack(response: postResponse)
            })
        }
    }
    
    /**
     * Post Result Return Back To The Previoues screen
     */
    func performSegueToReturnBack(response: ResponseBean)  {
        if let nav = self.navigationController {
            screenCallback?(response)
            nav.popViewController(animated: true)
        } else {
            screenCallback?(response)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /**
     *  API Call
     *  Check Order Status
     */
    @objc func checkOrderStatusAPICall(){
        
        
        let url = "https://ulis.live:4014/api/v1/orders/details"
        let parameters: [String: Any] = [
                "order_id": mOrderId,
                "token": mToken
        ]
        ApiManager.checkOrderStatusApiRequest(url: url, parameters: parameters, completion: { response in
            
            // Stop loading indicator
            DispatchQueue.main.async { self.stopLoading()}
            
            print ("Parameters = \(parameters)")
            print ("Response = \(response)")
            
            if (response.status == 200) {
                
                if let Response = response.data as? [String : Any]{
                    
                    let status = Response["status"] as? String
                    let message = Response["message"] as? String
                    
                    
                    if (status! == "success"){
                        
                        if let Data = Response["data"] as? [String : Any]{
                            
                            if let OrderDetails = Data["order_details"] as? [String : Any]{
                                let status = OrderDetails["status"] as? String
                                print("Order Status: ", status!)
                                
                                if(status! == "AUTHORISED" || status! == "CANCELLED"){
                                    
                                    self.timer.invalidate()
                                    
                                    // Post result back
//                                    DispatchQueue.main.async {
//
//                                        let postResponse = ResponseBean()
//                                        postResponse.message = response.message
//                                        postResponse.status = response.status
//                                        postResponse.data = Data
//
//                                        self.dismiss(animated: true, completion: nil)
//
//                                        let RVController = self.storyboard?.instantiateViewController(withIdentifier: "RVController") as! ReceiptViewController;
//                                        RVController.responseBean = postResponse
//                                        self.navigationController?.pushViewController(RVController, animated: true)
//                                    }
                                    
                                    DispatchQueue.main.async {
                                        let postResponse = ResponseBean()
                                        postResponse.message = response.message
                                        postResponse.status = response.status
                                        postResponse.data = Data
                                        
                                        self.window = UIWindow(frame: UIScreen.main.bounds)
                                        let receiptVC = ReceiptViewController()
                                        receiptVC.responseBean = postResponse
                                        let navigationController = UINavigationController(rootViewController: receiptVC)
                                        navigationController.navigationBar.isTranslucent = false
                                        self.window.rootViewController = navigationController
                                        self.window.makeKeyAndVisible()
                                    }
                                    
                                }else{
                                    // Order Is Pending
                                    
                                    DispatchQueue.main.async {
                                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkOrderStatusAPICall), userInfo: nil, repeats: true)
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Failed!", message: message!, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
                        
                        return
                    }
                    
                }
                
            }else{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error!", message: response.message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        })
    }
    
    /**
     * Generate Order ID
     */
    func randomStringWithLength (len : Int) -> NSString {

        let letters : NSString = "0123456789"
            let len = UInt32(letters.length)

            var randomString = ""

            for _ in 0 ..< len {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }

        return "ORD" + randomString as NSString
    }
    
    /**
     * Progress message
     */
    func showProgressMessage(labelText: String){
        
        message.center = self.view.center;
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.text = labelText
        
        let maxSize = CGSize(width: screenWidth/2, height: 20)
        message.sizeThatFits(maxSize)
        
        message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /**
     * Start Screen Loader
     */
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        };
        view.addSubview(activityIndicator);

        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }

    /**
     * Stop Screen Loader
     */
    func stopLoading(){

        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();

    }
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func dismissMe(animated: Bool, completion: (()->())?) {
            var count = 0
            if let c = self.navigationController?.viewControllers.count {
                count = c
            }
            if count > 1 {
                self.navigationController?.popViewController(animated: animated)
                if let handler = completion {
                    handler()
                }
            } else {
                dismiss(animated: animated, completion: completion)
            }
        }
}
