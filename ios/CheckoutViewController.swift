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
    var redirectView: UIView!
    
    weak var countdownTimer:Timer?
    var totalTime = 10
    
    var webView: WKWebView!
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    var env: String = ""
    var region: String = ""
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
    var indicator: ProgressIndicator?
    
    var message = UILabel()
    var redirectText = UILabel()

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
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.bounds = view.safeAreaLayoutGuide.layoutFrame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showProgressMessage(labelText: "Wait loading checkout page")
        startLoading()
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
    
    func showRedirectPageView(){
        
        // View
        redirectView = UIView(frame: CGRect(x: 25.0, y: screenHeight-190, width: screenWidth-50, height: 90))
        redirectView.layer.cornerRadius = 5
        redirectView.layer.shadowRadius = 5
        redirectView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        view.addSubview(redirectView)
        
        // View Text
        redirectText = UILabel(frame: CGRect(x: 25.0, y: screenHeight-190, width: screenWidth-50, height: 30))
        redirectText.textColor = UIColor.black
        redirectText.textAlignment = NSTextAlignment.center
        redirectText.text = ""
        redirectText.center = redirectText.center
        view.addSubview(redirectText)
        
        let button = UIButton(frame: CGRect(x: screenWidth/4, y: screenHeight-155, width: screenWidth/2, height: 50))
         button.setTitle("Done", for: .normal)
         button.backgroundColor = .white
         button.layer.cornerRadius = 5
         button.layer.borderWidth = 1
         button.setTitleColor(UIColor.black, for: .normal)
         button.addTarget(self, action: #selector(self.onClickDoneBtn), for: .touchUpInside)
         view.addSubview(button)
        
        //Timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    let defaults = UserDefaults.standard
    @objc func updateTime() {

        defaults.set(totalTime, forKey: "time")
        let updateTime = defaults.integer(forKey: "time")
        redirectText.text = "Screen redirecting in " +  "\(timeFormatted(updateTime))" + " secound"

        totalTime -= 1

        defaults.set(totalTime, forKey: "time")
    
        if totalTime < 0 {
            countdownTimer?.invalidate()
            performSegueToReturnBack()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d", seconds)
    }
    
    @objc func onClickDoneBtn() {
        countdownTimer?.invalidate()
        performSegueToReturnBack()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        showProgressMessage(labelText: "")
//        message.text = ""
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
                showRedirectPageView()
            }else if ("\(key)" == "https://ulis.live:8081/error?m=session") {
                showRedirectPageView()
            }
        }
    }
    
    // Return Back To The Previoues screen
    func performSegueToReturnBack()  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let orderVC = OrderViewController()
            orderVC.orderAction = "check"
            orderVC.mOrderId = self.order_id
            orderVC.mToken = self.token
            orderVC.mMerchantKey = self.merchantKey
            orderVC.mMerchantSecret = self.merchantSecret
            orderVC.env = self.env
            orderVC.mRegion = self.region
            let discoverVC = orderVC as UIViewController
            let navigationController = UINavigationController(rootViewController: discoverVC)
            navigationController.navigationBar.isTranslucent = false
            self.window.rootViewController = navigationController
            self.window.makeKeyAndVisible()
        }
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
        message.frame = CGRect(x: 25.0, y: (screenHeight/2) - 95, width: screenWidth-50, height: 30)
        message.textColor = UIColor.black
        message.textAlignment = NSTextAlignment.center
        message.text = labelText
        message.center = message.center
        view.addSubview(message)
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
