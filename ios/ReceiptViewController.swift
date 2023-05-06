//
//  ReceiptViewController.swift
//  WebViewDemo
//
//  Created by Hydrus on 24/04/23.
//

import UIKit

class ReceiptViewController: UIViewController {

    var statusLabel = UILabel()
    var btnDone: UIButton!
    var ivStatus: UIImageView!
    
    var merchantLogo = UIImageView()
    var labelTransactionId = UILabel()
    var labelOrderId = UILabel()
    var labelMobileNumber = UILabel()
    var labelPrice = UILabel()
    var labelMerchantName = UILabel()
    
    var successGif: UIImage!
    var failedImg: UIImage!
    var paymentStatus: String!
    
    var responseBean: ResponseBean!
    
    func showStatusLabel(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 20, y: 100, width: screenWidth-100, height: 21))
//        statusLabel.center = CGPoint(x: 160, y: 185)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
        
        self.view.addSubview(statusLabel)
    }
    
    
    func showOrderId(labelText: String){
        labelOrderId = UILabel(frame: CGRect(x: 30, y: 250, width: screenWidth-100, height: 21))
//        labelOrderId.center = CGPoint(x: 160, y: 315)
        labelOrderId.translatesAutoresizingMaskIntoConstraints = false
        labelOrderId.lineBreakMode = .byWordWrapping
        labelOrderId.numberOfLines = 1
        labelOrderId.textAlignment = .left
        labelOrderId.text = labelText
        
        self.view.addSubview(labelOrderId)
    }
    
    
    func showMobileNo(labelText: String){
        labelMobileNumber = UILabel(frame: CGRect(x: 30, y: 280, width: screenWidth-100, height: 21))
//        labelMobileNumber.center = CGPoint(x: 160, y: 305)
        labelMobileNumber.translatesAutoresizingMaskIntoConstraints = false
        labelMobileNumber.lineBreakMode = .byWordWrapping
        labelMobileNumber.numberOfLines = 0
        labelMobileNumber.textAlignment = .left
        labelMobileNumber.text = labelText
        
        self.view.addSubview(labelMobileNumber)
    }
    
    func showPrice(labelText: String){
        labelPrice = UILabel(frame: CGRect(x: 30, y: 310, width: screenWidth-100, height: 21))
//        labelPrice.center = CGPoint(x: 160, y: 295)
        labelPrice.translatesAutoresizingMaskIntoConstraints = false
        labelPrice.lineBreakMode = .byWordWrapping
        labelPrice.numberOfLines = 0
        labelPrice.textAlignment = .left
        labelPrice.text = labelText
        
        self.view.addSubview(labelPrice)
    }
    
    func showMerchantName(labelText: String){
        labelMerchantName = UILabel(frame: CGRect(x: 30, y: 340, width: screenWidth-100, height: 21))
//        labelMerchantName.center = CGPoint(x: 160, y: 285)
        labelMerchantName.translatesAutoresizingMaskIntoConstraints = false
        labelMerchantName.lineBreakMode = .byWordWrapping
        labelMerchantName.numberOfLines = 0
        labelMerchantName.textAlignment = .left
        labelMerchantName.text = labelText
        
        self.view.addSubview(labelMerchantName)
    }
    
    func showTransactionId(labelText: String){
        labelTransactionId = UILabel(frame: CGRect(x: 30, y: 370, width: screenWidth-100, height: 21))
//        labelTransactionId.center = CGPoint(x: 160, y: 325)
        labelTransactionId.translatesAutoresizingMaskIntoConstraints = false
        labelTransactionId.lineBreakMode = .byWordWrapping
        labelTransactionId.numberOfLines = 1
        labelTransactionId.textAlignment = .left
        labelTransactionId.text = labelText
        
        self.view.addSubview(labelTransactionId)
    }
    
    func showMerchantLogo(imageUrl: String){
//        merchantLogo  = UIImageView(frame:CGRectMake(10, 50, 100, 300));
//        merchantLogo.image = UIImage(named:"image.jpg")
    }
    
    func showDoneButton(){
        btnDone = UIButton(frame: CGRect(x: 20, y: screenHeight-100, width: screenWidth-60, height: 50))
        btnDone.center = CGPoint(x: 190, y: screenHeight-100)
        btnDone.backgroundColor = .black
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        btnDone.layer.cornerRadius = 5
        btnDone.tag = 1
        btnDone.setTitle("Button", for: .normal)
        btnDone.addTarget(self, action:#selector(self.onPressDone(_:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
    }
    
    func showDoneButton2(){
        var btnDone = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        btnDone.backgroundColor = .black
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        btnDone.layer.cornerRadius = 5
        btnDone.tag = 1
        btnDone.setTitle("Button2", for: .normal)
        btnDone.addTarget(self, action:#selector(self.onPressDone(_:)), for: .touchUpInside)
        self.view.addSubview(btnDone)
    }

    @objc func onPressDone(_ sender: UIButton) {
        
//        let encodedData = try JSONEncoder().encode(responseBean)
//        let jsonString = String(data: encodedData, encoding: .utf8)
        print("button preesed!")
        
        RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_SUCCESS", body: responseBean!)
        
        let mainWindow = UIApplication.shared.delegate?.window
        mainWindow?!.removeFromSuperview()
        mainWindow??.makeKeyAndVisible()
        
        self.view.removeFromSuperview()
        
        self.navigationController?.viewControllers.removeAll(where: {$0.isModalInPopover})

        self.navigationController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        self.view.backgroundColor = .white
        
        self.showDoneButton()
        
        
        if let Data = responseBean.data as? [String : Any]{
            print ("Data = \(Data)")
            if let OrderDetails = Data["order_details"] as? [String : Any]{
                print ("OrderDetails = \(OrderDetails)")
                paymentStatus = OrderDetails["status"] as? String
                print("Order Status: ", paymentStatus!)
                let currency = OrderDetails["currency"] as? String
                let amount = OrderDetails["amount"] as? String
                let mobileNo = OrderDetails["mobile_no"] as? String
//                let merchantName = OrderDetails["name"] as? String
                let orderId = OrderDetails["order_id"] as? String

//                self.labelPrice.text = currency! + " " + amount!
//                self.labelMobileNumber.text = mobileNo!
//                self.labelOrderId.text = orderId!
                
                self.showPrice(labelText: "Amount: " + currency! + " " + amount!)
                self.showMobileNo(labelText: "Mobile No.: " + mobileNo!)
                self.showOrderId(labelText: "Order ID: " + orderId!)
                self.showTransactionId(labelText: "Txn. ID: " + "-")

            }

            if let MerchantDetails = Data["merchant_details"] as? [String : Any]{
                let logo = MerchantDetails["logo"] as? String
                let merchantName = MerchantDetails["merchant_name"] as? String

//                self.loadImageFromUrl(url: logo!, imageView: self.merchantLogo)
                self.showMerchantName(labelText: "Merchant: " + merchantName!)
            }
        }

//        let failedImageData = try? Data(contentsOf: Bundle.main.url(forResource: "error", withExtension: "png")!)
//        failedImg = UIImage(data: failedImageData!)
//
//        let successImageData = try? Data(contentsOf: Bundle.main.url(forResource: "success", withExtension: "gif")!)
//        successGif = UIImage.gifImageWithData(successImageData!)



        if(paymentStatus! == "AUTHORISED"){
//            ivStatus.image = successGif
            self.showStatusLabel(labelText: "Paid successfully!")
            self.statusLabel.textColor = .green
        }else if(paymentStatus! == "CANCELLED"){
//            ivStatus.image = failedImg
            self.showStatusLabel(labelText: "Payment is cancelled!")
            self.statusLabel.textColor = .red
        }else {
            self.showStatusLabel(labelText: paymentStatus!)
            self.statusLabel.textColor = .orange
        }
        
        self.loadImageFromUrl(url: "https://ulis.live:4010/static/images/fav_icon-1672899475914-616922036.png", imageView: self.merchantLogo)
        
//        DispatchQueue.main.async { self.setImagePlacehoder(imageView: self.merchantLogo) }
        
        
    }

    /**
     * Post Result Return Back To The Previoues screen
     */
    func performSegueToReturnBack(response: ResponseBean)  {
        self.navigationController?.popViewController(animated: true)
        let ovc = self.navigationController?.viewControllers.last as! OrderViewController
        ovc.receiptScreenCallback?(response)
    }
    
    func loadImageFromUrl(url: String, imageView: UIImageView){
        let catPictureURL = URL(string: url)!

        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
                DispatchQueue.main.async { self.setImagePlacehoder(imageView: imageView) }
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async { imageView.image = image }
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                        //Set default placeholder image
                        DispatchQueue.main.async { self.setImagePlacehoder(imageView: imageView) }
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    DispatchQueue.main.async { self.setImagePlacehoder(imageView: imageView) }
                }
            }
        }

        downloadPicTask.resume()
    }
    
    func setImagePlacehoder(imageView: UIImageView){
        let merchantImageData = try? Data(contentsOf: Bundle.main.url(forResource: "store", withExtension: "png")!)
        DispatchQueue.main.async { imageView.image = UIImage(data: merchantImageData!) }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
