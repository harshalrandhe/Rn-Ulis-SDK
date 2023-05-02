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
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 160, y: 185)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }
    
    func showTransactionId(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 60, y: 325)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }
    
    func showOrderId(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 60, y: 315)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }
    
    
    func showMobileNo(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 60, y: 305)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }
    
    func showPrice(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 60, y: 295)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }
    
    func showMerchantName(labelText: String){
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/1.5, height: 21))
        statusLabel.center = CGPoint(x: 60, y: 285)
        statusLabel.center = self.view.center;
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.text = labelText
    }

    
    func showMerchantLogo(imageUrl: String){
//        merchantLogo  = UIImageView(frame:CGRectMake(10, 50, 100, 300));
//        merchantLogo.image = UIImage(named:"image.jpg")
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
    
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(statusLabel)
        view.addSubview(labelMerchantName)
        view.addSubview(labelPrice)
        view.addSubview(labelOrderId)
        view.addSubview(labelMobileNumber)
        view.addSubview(labelTransactionId)
        view.addSubview(merchantLogo)
        
        
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
                
                self.showPrice(labelText: currency! + " " + amount!)
                self.showMobileNo(labelText: mobileNo!)
                self.showOrderId(labelText: orderId!)

            }

            if let MerchantDetails = Data["merchant_details"] as? [String : Any]{
                let logo = MerchantDetails["logo"] as? String
                let merchantName = MerchantDetails["merchant_name"] as? String

//                self.loadImageFromUrl(url: logo!, imageView: self.merchantLogo)
//                self.labelMerchantName.text = merchantName!
                self.showMerchantName(labelText: merchantName!)
            }
        }

//        let failedImageData = try? Data(contentsOf: Bundle.main.url(forResource: "error", withExtension: "png")!)
//        failedImg = UIImage(data: failedImageData!)
//
//        let successImageData = try? Data(contentsOf: Bundle.main.url(forResource: "success", withExtension: "gif")!)
//        successGif = UIImage.gifImageWithData(successImageData!)



        if(paymentStatus! == "AUTHORISED"){

//            ivStatus.image = successGif
//            statusLabel.text = "Paid successfully!"
            self.showStatusLabel(labelText: "Paid successfully!")

        }else if(paymentStatus! == "CANCELLED"){

//            ivStatus.image = failedImg
//            statusLabel.text = "Payment is cancelled!"
            self.showStatusLabel(labelText: "Payment is cancelled!")
        }
        
        self.loadImageFromUrl(url: "https://ulis.live:4010/static/images/fav_icon-1672899475914-616922036.png", imageView: self.merchantLogo)
        
//        DispatchQueue.main.async { self.setImagePlacehoder(imageView: self.merchantLogo) }
        
        // Add action to button
//        btnDone.addTarget(self, action: #selector(onPressDone(sender:)), for: UIControl.Event.touchUpInside)
        
        
        self.showStatusLabel(labelText: "Paid successfully!")
        self.showPrice(labelText: "$ 120")
        self.showMerchantName(labelText: "merchantName")
        self.showMobileNo(labelText: "mobileNo")
        self.showOrderId(labelText: "orderId")
        
    }

    @objc func onPressDone(sender: UIButton) {
        self.performSegueToReturnBack(response: responseBean)
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
