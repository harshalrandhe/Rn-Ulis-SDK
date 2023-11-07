//
//  CheckoutViewController.swift
//  RnUlisSdk
//
//  Created by Hydrus on 27/04/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit
import WebKit

class CheckoutViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var window: UIWindow!
    
    var webView: WKWebView!
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    var order_id: String = ""
    var token: String = ""
    var paymentLink: String = ""
    var returnUrl: String = ""
    var successUrl: String = ""
    var cancelUrl: String = ""
    var failureUrl: String = ""
    var merchantKey: String = ""
    var merchantSecret: String = ""
    var checkoutCallback : ((String, String) -> Void)?
    var screenCallback : ((ResponseBean) -> Void)?
    let message = UILabel()
    var indicator: ProgressIndicator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

    }
    
    override func viewDidAppear(_ animated: Bool) {
        showProgressMessage(labelText: "Wait loading checkout page")
        startLoading()
//        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.white, msg: "Please wait order in process")
//        self.view.addSubview(indicator!)
//        indicator!.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        // Do any additional setup after loading the view.
        
        let myURL = URL(string: paymentLink)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.navigationDelegate = self
        // Add observer
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
//        showProgressMessage(labelText: "")
        message.text = ""
        stopLoading()
//        indicator!.stop()
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            
            print("observeValue \(key)") // url value
        
            if keyPath == "estimatedProgress" {
                print(Float(webView.estimatedProgress))
            }
            
            if ("\(key)" == self.returnUrl) {
                performSegueToReturnBack()
            }else if ("\(key)" == "https://ulis.live:8081/error?m=session") {
                performSegueToReturnBack()
            }
            
        }
    }
    
    // Return Back To The Previoues screen
    func performSegueToReturnBack()  {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let orderVC = OrderViewController()
        orderVC.orderAction = "check"
        orderVC.mOrderId = self.order_id
        orderVC.mToken = self.token
        orderVC.mMerchantKey = self.merchantKey
        orderVC.mMerchantSecret = self.merchantSecret
        let discoverVC = orderVC as UIViewController
        let navigationController = UINavigationController(rootViewController: discoverVC)
        navigationController.navigationBar.isTranslucent = false
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showProgressMessage(labelText: String){
        message.center = self.view.center;
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.text = labelText
        view.addSubview(message)
        message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY + 44)
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

    func stopLoading(){
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
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
    
    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
