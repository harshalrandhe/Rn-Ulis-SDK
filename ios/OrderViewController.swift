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
    var mMerchantKey: String = ""
    var mMerchantSecret: String = ""
    var mReturnUrl: String = ""
    var loderWarningGif: UIImage!
    var labelPoweredBy = UILabel()
    var message = UILabel()
    var btnDone = UIButton()
    var mResponseBean: ResponseBean!
    var option: AnyObject!
    var pendingCounter: Int = 0
    var mRegion: String = ""
    var env: String = ""
    
    
    func showTransactionId(){
        labelPoweredBy = UILabel()
        labelPoweredBy.frame = CGRect(x: 50, y: self.view.bounds.maxY - 40, width: screenWidth-100, height: 21)
        labelPoweredBy.lineBreakMode = .byWordWrapping
        labelPoweredBy.numberOfLines = 1
        labelPoweredBy.textAlignment = NSTextAlignment.center
        labelPoweredBy.text = "Powered By ULIS Technology."
        labelPoweredBy.font = UIFont.boldSystemFont(ofSize: 14)
        self.view.addSubview(labelPoweredBy)
    }

    /**
     * Progress message
     */
    func showProgressMessage(){
        message = UILabel()
        message.frame = CGRect(x: 50, y: self.view.bounds.midY, width: screenWidth-100, height: 21)
        message.textColor = UIColor.black
        message.textAlignment = NSTextAlignment.center
        self.view.addSubview(message)
    }
    
    func showDoneButton(response : ResponseBean){
        self.mResponseBean = response
        self.btnDone = UIButton()
        self.btnDone.frame = CGRect(x: 50, y: self.view.bounds.maxY - 250, width: screenWidth-100, height: 40)
        self.btnDone.backgroundColor = .white
        self.btnDone.layer.cornerRadius = 5
        self.btnDone.tag = 1
        self.btnDone.layer.borderWidth = 1
        self.btnDone.setTitle("Done", for: .normal)
        self.btnDone.setTitleColor(UIColor.black, for: .normal)
        self.btnDone.addTarget(self, action:#selector(self.onPressDone(_:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        showProgressMessage()
        message.text = "Please wait order in process"
        startLoading()
        
        /**
         * Screen Callback
         * From Checkout Controller
         */
        checkoutCallback = { order_id, token in
            //Do what you want in here!
            print("callback -->")
            self.message.text = "Checking payment status"
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
        
        self.view.backgroundColor = .white // Screen bg color
        self.view.addSubview(message)
        
        self.showTransactionId()

        if(self.orderAction == "create"){
            print("Create order........")
            // API Call
            self.getRegionAPICall()
        }else{
            print("Check order........")
            self.message.text = "Please wait transaction in process"
            // API Call
            self.checkOrderStatusAPICall()
        }
        
    }
    
    
    /**
     *  API Call
     *  Check Order Details
     */
    @objc func getRegionAPICall(){
        
        let url = "https://ulis.live:4010/api/v1/merchant_key_secret/find/region"
        let optionsData: [String: Any] = option as! [String : Any]
        var parameters: [String : Any] = [:]
        var data: [String : Any] = [:]
        
        data["merchantKey"] = optionsData["merchantKey"]!
        data["merchantSecret"] = optionsData["merchantSecret"]!
        
        parameters["data"] = data
        
        ApiManager.getMerchantRegionRequest(url: url, parameters: parameters, completion: { [self] response in
            
            if (response.status == 200) {
                
                if let Response = response.data as? [String : Any]{
                    
                    print ("getMerchantRegionResponse = \(Response)")
                    
                    let status = Response["status"] as? String
                    let message = Response["message"] as? String
                    
                    
                    if (status! == "success"){
                        
                        if let Data = Response["data"] as? [String : Any]{
                            
                            let regionOptional = Data["region"]
                            let envOptional = Data["type"]
                            mRegion = regionOptional as! String
                            env = envOptional as! String
                            
                            print("Region...:  \(mRegion)")
                            print("Env...:  \(env)")
                            
                            // API Call
                            self.createOrderAPICall(region: mRegion, envType: env)
                            
                        }
                        
                    } else {
                        // Else status! == "success"
                        
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Failed!", message: message!, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                DispatchQueue.main.async {
                                    
                                    let responseData: [String: Any] = [
                                        "status": response.status,
                                        "message": response.message,
                                    ]
                                    
                                    self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                                }
                            }))
                            self.present(ac, animated: true)
                        }
                        
                        return
                    }
                }
                
            }else{
                // Else response.status == 200
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error!", message: response.message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { (_) in
                        DispatchQueue.main.async {
                            let responseData: [String: Any] = [
                                "status": response.status,
                                "message": response.message,
                            ]
                            
                            self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                        }
                    }))
                    self.present(ac, animated: true)
                }
            }
        }
                                               )
    }
    
    
    /**
     * API Call
     * Create Order
     */
    func createOrderAPICall(region: String, envType: String){
        
        var url = ""
        if(region == "UAE"){
            url = "https://ulis.live:4014/api/v1/orders/create"
        }else{
            // For KSA
            url = "https://ulis.live:4016/api/v1/orders/create"
        }
        
        
        let optionsData: [String: Any] = option as! [String : Any]
        var parameters: [String : Any] = [:]
        var data: [String : Any] = [:]
        
        data["merchantKey"] = optionsData["merchantKey"]!
        data["merchantSecret"] = optionsData["merchantSecret"]!
        data["mobile_sdk"] = 1
        data["customer_details"] = optionsData["customer_details"]! as! [String: Any]
       // data["productDetails"] = optionsData["productDetails"]! as! [String: Any]
        data["billing_details"] = optionsData["billing_details"]! as! [String: Any]
        data["shipping_details"] = optionsData["shipping_details"]! as! [String: Any]
        data["order_details"] = optionsData["order_details"]! as! [String: Any]
        data["merchant_urls"] = optionsData["merchant_urls"]! as! [String: Any]
        data["transaction"] = optionsData["transaction"]! as! [String: Any]
        data["integration"] = "MOBILESDK"
        
        parameters["data"] = data
        
        mMerchantKey = optionsData["merchantKey"]! as! String
        mMerchantSecret = optionsData["merchantSecret"]! as! String
        let orderDetails = optionsData["order_details"]! as! [String: Any]
        
        mReturnUrl = orderDetails["return_url"]! as! String
        
//        print("Return url: -> ", mReturnUrl)
//        print("optionsData: -> " , optionsData)
        print("Parameters: -> " , parameters)
        
        ApiManager.createOrderApiRequest(url: url, parameters: parameters, completion: CreateOrderApiCallback)
    }
    
    /**
     * Callback
     * Create Order API Callback
     */
    func CreateOrderApiCallback(response: ResponseBean) -> () {
        
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
                       
                        mOrderId = order_id!
                        mToken = token!
                        
                        // API Call
                        var APIParameters: [String: Any] = [:]
                        APIParameters["orderId"] = order_id!
                        APIParameters["token"] = token!
                        APIParameters["paymentLink"] = payment_link!
                        APIParameters["merchantKey"] = self.mMerchantKey
                        APIParameters["merchantSecret"] = self.mMerchantSecret
                        APIParameters["returnUrl"] = self.mReturnUrl
                        APIParameters["successUrl"] = successUrl
                        APIParameters["cancelUrl"] = cancelUrl
                        APIParameters["failuerUrl"] = failuerUrl
//                        
//                        self.checkOrderDetailsAPICall(param: APIParameters)
                        
                        DispatchQueue.main.async {
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let discoverVC = CheckoutViewController()
                            discoverVC.order_id = APIParameters["orderId"] as! String
                            discoverVC.token = APIParameters["token"] as! String
                            discoverVC.paymentLink = APIParameters["paymentLink"] as! String
                            discoverVC.merchantKey = APIParameters["merchantKey"] as! String
                            discoverVC.merchantSecret = APIParameters["merchantSecret"] as! String
                            discoverVC.returnUrl = APIParameters["returnUrl"] as! String
                            discoverVC.successUrl = APIParameters["successUrl"] as! String
                            discoverVC.cancelUrl = APIParameters["cancelUrl"] as! String
                            discoverVC.failureUrl = APIParameters["failuerUrl"] as! String
                            discoverVC.env = self.env
                            discoverVC.region = self.mRegion
                            let navigationController = UINavigationController(rootViewController: discoverVC)
                            navigationController.navigationBar.isTranslucent = false
                            self.window.rootViewController = navigationController
                            self.window.makeKeyAndVisible()
                        }
                    }
                    
                } else {
                    
                    // Update status label an image
                    DispatchQueue.main.async {
                        self.message.text = message!
                    }
                    
                    // Post result back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        
                        let postResponse = ResponseBean()
                        postResponse.message = message!
                        postResponse.status = response.status
                        postResponse.data = Response
                        
                        RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_ERROR", body: postResponse)
                        
                        let mainWindow = UIApplication.shared.delegate?.window
                        mainWindow?!.removeFromSuperview()
                        mainWindow??.makeKeyAndVisible()
                        self.view.removeFromSuperview()
                    })

                }
            }
            
        }else{
            // Update status label an image
            DispatchQueue.main.async {
                self.message.text = response.message
                self.showDoneButton(response: response)
            }
            
            // Post result back
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//
//                let responseData: [String: Any] = [
//                    "status": response.status,
//                    "message": response.message,
//                ]
//
//                self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
//            })
        }
    }
    
    
    /**
     * Button
     * On Press Done Button
     */
    @objc func onPressDone(_ sender: UIButton) {
        
        let responseData: [String: Any] = [
            "status": self.mResponseBean!.status,
            "message": self.mResponseBean!.message,
        ]
        
        self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
    }
    
    /**
     * Post Result To Merchant
     */
    func postResult(event: String, response: [String: Any]){
        let postResponse = ResponseBean()
        postResponse.message = ""
        postResponse.status = 0
        postResponse.data = response
        
        RnUlisSdk.shared!.sendBackEvent(withName: event, body: postResponse)
        
        let mainWindow = UIApplication.shared.delegate?.window
        mainWindow?!.removeFromSuperview()
        mainWindow??.makeKeyAndVisible()
        self.view.removeFromSuperview()
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
     *  Check Order Details
     */
    @objc func checkOrderDetailsAPICall(param : [String: Any]){
        
        
        var url = "https://ulis.live:4014/api/v1/orders/details"
        if(mRegion == "KSA"){
            url = "https://ulis.live:4016/api/v1/orders/details"
        }
        
        
        let parameters: [String: Any] = [
                "order_id": mOrderId,
                "token": mToken
        ]
        
        ApiManager.checkOrderDetailsApiRequest(url: url, parameters: parameters, completion: { [self] response in
            
            if (response.status == 200) {
                
                if let Response = response.data as? [String : Any]{
                    
                    print ("OrderDetailsResponse = \(Response)")
                    
                    let status = Response["status"] as? String
                    let message = Response["message"] as? String
                    
                    
                    if (status! == "success"){
                        
                        if let Data = Response["data"] as? [String : Any]{
                            if let OrderDetails = Data["order_details"] as? [String:Any]{
                                print ("OrderDetails = \(OrderDetails)")
                                env = (OrderDetails["env"] as? String)!
                                print("API Mode...: ", self.env)
                                print("Params...:  \(param)")
                                
                            }
                        }
                        
                    } else {
                        // Else status! == "success"
                        
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Failed!", message: message!, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                DispatchQueue.main.async {
                                    
                                    let responseData: [String: Any] = [
                                        "status": response.status,
                                        "message": response.message,
                                    ]
                                    
                                    self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                                }
                            }))
                            self.present(ac, animated: true)
                        }
                        
                        return
                    }
                }
                
            }else{
                // Else response.status == 200
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error!", message: response.message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { (_) in
                        DispatchQueue.main.async {
                            let responseData: [String: Any] = [
                                "status": response.status,
                                "message": response.message,
                            ]
                            
                            self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                        }
                    }))
                    self.present(ac, animated: true)
                }
            }
        }
                                               )
    }
    
    /**
     *  API Call
     *  Check Order Status
     */
    @objc func checkOrderStatusAPICall(){
        
        var BASE_URL = "https://ulis.live:4014"
        if(mRegion == "KSA"){
            BASE_URL = "https://ulis.live:4016"
        }
        
        var url = BASE_URL + "/api/v1/orders/transaction-details-print"
        if(env == "test"){
            url = BASE_URL + "/api/v1/orders/test/transaction-details-print"
        }
        
        
        print("<<ENV>>", env)
        print("<<URL>>", url)
        
        let parameters: [String: Any] = [
                "order_id": mOrderId,
                "merchantKey": mMerchantKey,
                "merchantSecret": mMerchantSecret
        ]
        
        pendingCounter = pendingCounter + 1;
        
        ApiManager.checkOrderStatusApiRequest(url: url, parameters: parameters, completion: { response in
            
            // Stop loading indicator
            DispatchQueue.main.async { self.stopLoading()}
            
            print ("Parameters = \(parameters)")
            print ("Response = \(response)")
            
            if (response.status == 200) {
                
                if let Response = response.data as? [String : Any]{
                    
                    print ("OrderStatusResponse = \(Response)")
                    
                    let status = Response["status"] as? String
                    let message = Response["message"] as? String
                    
                    
                    if (status! == "success"){
                        
                        if let Data = Response["data"] as? [String : Any]{
                            
                            if let TxnDetails = Data["transactions"] as? [[String:Any]]{
                                let status = TxnDetails[0]["gateway_code"] as? String
                                print("Order Status: ", status!)
                                
                                if(status! == "AUTHORIZED" || status! == "CANCELLED" || status! == "FAILED" || status! == "DECLINED"){
                                    
                                    if(self.timer.isValid){
                                        self.timer.invalidate()
                                    }
                                    
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
                                    print("pendingCounter....", self.pendingCounter)
                                    if(self.pendingCounter >= 8){
                                        
                                        if(self.timer.isValid){
                                            self.timer.invalidate()
                                        }
                                        
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
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkOrderStatusAPICall), userInfo: nil, repeats: true)
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    } else {
                        
                        
                        if(self.timer.isValid){
                            self.timer.invalidate()
                        }
                        
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Failed!", message: message!, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                DispatchQueue.main.async {
                                    
                                    let responseData: [String: Any] = [
                                        "status": response.status,
                                        "message": response.message,
                                    ]
                                    
                                    self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                                }
                            }))
                            self.present(ac, animated: true)
                        }
                        
                        return
                    }
                    
                }
                
            }else{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Error!", message: response.message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { (_) in
                        DispatchQueue.main.async {
                            let responseData: [String: Any] = [
                                "status": response.status,
                                "message": response.message,
                            ]
                            
                            self.postResult(event: "Telr::PAYMENT_ERROR", response: responseData)
                        }
                    }))
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
