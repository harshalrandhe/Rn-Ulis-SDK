//
//  ReceiptViewController.swift
//  WebViewDemo
//
//  Created by Hydrus on 24/04/23.
//

import UIKit
import SwiftUI

class ReceiptViewController: UIViewController {
    
    var statusLabel = UILabel()
    var btnDone: UIButton!
    var ivStatus: UIImageView!
    
    var merchantLogo = UIImageView()
    var labelTransactionId = UILabel()
    var labelOrderId = UILabel()
    var labelTransactionType = UILabel()
    var labelTransactionStatus = UILabel()
    var labelTransactionTime = UILabel()
    var labelCard = UILabel()
    var labelMobileNumber = UILabel()
    var labelPrice = UILabel()
    var labelMerchantName = UILabel()
    
    var successGif: UIImage!
    var failedImg: UIImage!
    var paymentStatus: String!
    var txnType: String!
    var txnDate: String!
    
    var headerView: UIView!
    
    var responseBean: ResponseBean!
    
    /**
     *  Layout
     *  Header layout
     */
    func showHeaderView(){
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 250))
        self.view.addSubview(headerView)
    }
    
    /**
     *  Layout
     */
    func baseLable(labelText: String) -> UILabel{
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 300, width: screenWidth-80, height: 21)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 14)
        return label;
    }
    
    /**
     *  Label
     *  Transaction Status
     */
    func showStatusLabel(labelText: String){
        statusLabel = baseLable(labelText: labelText)
        statusLabel.frame = CGRect(x: 0, y: 200, width: screenWidth, height: 21)
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(statusLabel)
    }
    
    /**
     *  Label
     *  Transaction id
     */
    func showTransactionId(value: String){
        labelTransactionId = baseLable(labelText: "TXN ID")
        labelTransactionId.frame = CGRect(x: 30, y: 300, width: screenWidth-100, height: 21)
        
        self.view.addSubview(labelTransactionId)
        
        labelTransactionId = baseLable(labelText: value)
        labelTransactionId.frame = CGRect(x: 160, y: 300, width: screenWidth-100, height: 21)
        
        self.view.addSubview(labelTransactionId)
    }
    
    /**
     *  Label
     *  Order id
     */
    func showOrderId(value: String){
        labelOrderId = baseLable(labelText: "ORDER ID")
        labelOrderId.frame = CGRect(x: 30, y: 330, width: screenWidth-120, height: 21)
        self.view.addSubview(labelOrderId)
        
        labelOrderId = baseLable(labelText: value)
        labelOrderId.frame = CGRect(x: 160, y: 330, width: screenWidth-120, height: 21)
        self.view.addSubview(labelOrderId)
    }
    
    /**
     *  Label
     *  Transaction Type
     */
    func showTransactionType(value: String){
        labelTransactionType = baseLable(labelText: "TYPE")
        labelTransactionType.frame = CGRect(x: 30, y: 360, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionType)
        
        labelTransactionType = baseLable(labelText: value)
        labelTransactionType.frame = CGRect(x: 160, y: 360, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionType)
    }
    
    /**
     *  Label
     *  Transaction amount
     */
    func showPrice(value: String){
        labelPrice = baseLable(labelText: "AMOUNT")
        labelPrice.frame = CGRect(x: 30, y: 390, width: screenWidth-100, height: 21)
        self.view.addSubview(labelPrice)
        
        labelPrice = baseLable(labelText: value)
        labelPrice.frame = CGRect(x: 160, y: 390, width: screenWidth-100, height: 21)
        self.view.addSubview(labelPrice)
    }
    
    /**
     *  Label
     *  Transaction Status
     */
    func showTransactionStatus(value: String){
        labelTransactionStatus = baseLable(labelText: "STATUS")
        labelTransactionStatus.frame = CGRect(x: 30, y: 420, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionStatus)
        
        labelTransactionStatus = baseLable(labelText: value)
        labelTransactionStatus.frame = CGRect(x: 160, y: 420, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionStatus)
    }
    
    /**
     *  Label
     *  Transaction Time
     */
    func showTransactionTime(value: String){
        labelTransactionTime = baseLable(labelText: "TIME(UTC)")
        labelTransactionTime.frame = CGRect(x: 30, y: 450, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionTime)
        
        labelTransactionTime = baseLable(labelText: value)
        labelTransactionTime.frame = CGRect(x: 160, y: 450, width: screenWidth-100, height: 21)
        self.view.addSubview(labelTransactionTime)
    }
    
    /**
     *  Label
     *  Card
     */
    func showCard(value: String,value2: String){
        labelCard = baseLable(labelText: "CARD")
        labelCard.frame = CGRect(x: 30, y: 480, width: screenWidth-100, height: 21)
        self.view.addSubview(labelCard)
        
        labelCard = baseLable(labelText: value)
        labelCard.frame = CGRect(x: 160, y: 480, width: screenWidth-200, height: 21)
        self.view.addSubview(labelCard)
        
        labelCard = baseLable(labelText: value2)
        labelCard.frame = CGRect(x: 160, y: 500, width: screenWidth-200, height: 21)
        self.view.addSubview(labelCard)
    }
    
    
    /**
     *  Label
     *  Email Address
     */
    func showEmailAddress(value: String){
        var labelEmailAddress = baseLable(labelText: "EMAIL ADDRESS")
        labelEmailAddress.frame = CGRect(x: 30, y: 530, width: screenWidth-100, height: 21)
        self.view.addSubview(labelEmailAddress)
        
        labelEmailAddress = baseLable(labelText: value)
        labelEmailAddress.frame = CGRect(x: 160, y: 530, width: screenWidth-100, height: 21)
        self.view.addSubview(labelEmailAddress)
    }
    
    /**
     *  Label
     *  Phone Number
     */
    func showPhoneNumber(value: String){
        var labelPhoneNumber = baseLable(labelText: "PHONE NUMBER")
        labelPhoneNumber.frame = CGRect(x: 30, y: 560, width: screenWidth-100, height: 21)
        self.view.addSubview(labelPhoneNumber)
        
        labelPhoneNumber = baseLable(labelText: value)
        labelPhoneNumber.frame = CGRect(x: 160, y: 560, width: screenWidth-100, height: 21)
        self.view.addSubview(labelPhoneNumber)
    }
    
    /**
     *  Label
     *  Phone Number
     */
    func showCountry(value: String){
        var labelCountry = baseLable(labelText: "COUNTRY")
        labelCountry.frame = CGRect(x: 30, y: 590, width: screenWidth-100, height: 21)
        self.view.addSubview(labelCountry)
        
        labelCountry = baseLable(labelText: value)
        labelCountry.frame = CGRect(x: 160, y: 590, width: screenWidth-100, height: 21)
        self.view.addSubview(labelCountry)
    }
    
    
    /**
     *  Label
     *  Merchant Name
     */
    func showMerchantName(labelText: String){
        labelMerchantName = UILabel()
        labelMerchantName.frame = CGRect(x: 30, y: 390, width: screenWidth-100, height: 21)
        labelMerchantName.lineBreakMode = .byWordWrapping
        labelMerchantName.numberOfLines = 0
        labelMerchantName.textAlignment = .left
        labelMerchantName.text = labelText
        
        self.view.addSubview(labelMerchantName)
    }
    
    /**
     *  Image
     *  Status Image
     */
    func showStatusImageView(){
        self.ivStatus = UIImageView()
        self.ivStatus.frame = CGRect(x: self.view.bounds.midX - 40, y: 90, width: 90, height: 90)
        self.ivStatus.image = UIImage(named: "store")
        self.view.addSubview(ivStatus)
    }
    
    func showMerchantLogo(imageUrl: String){
        //        merchantLogo  = UIImageView(frame:CGRectMake(10, 50, 100, 300));
        //        merchantLogo.image = UIImage(named:"image.jpg")
        
    }
    
    /**
     *  Button
     *  Done
     */
    func showDoneButton(){
        self.btnDone = UIButton()
        self.btnDone.frame = CGRect(x: 50, y: self.view.bounds.maxY - 100, width: screenWidth-100, height: 40)
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
     * Button
     * On Press Done Button
     */
    @objc func onPressDone(_ sender: UIButton) {
        
        if(paymentStatus! == "AUTHORIZED"){
            RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_SUCCESS", body: responseBean!)
        }else if(paymentStatus! == "CANCELLED"){
            RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_CANCELLED", body: responseBean!)
        }else if(paymentStatus! == "FAILED"){
            RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_ERROR", body: responseBean!)
        }else {
            RnUlisSdk.shared!.sendBackEvent(withName: "Telr::PAYMENT_SUCCESS", body: responseBean!)
        }
        
        
        
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
        
        self.view.backgroundColor = .white // Screen bg color
        self.showHeaderView() // Header View
        self.showStatusImageView() // Status Image View
        self.showDoneButton() // Done Button
        
        
        if let Data = responseBean.data as? [String : Any]{
            print ("Data = \(Data)")
            if let TxnArray = Data["transactions"] as? [[String : Any]]{
                print ("OrderDetails = \(TxnArray[0])")
                let TxnDetails = TxnArray[0]
                paymentStatus = TxnDetails["gateway_code"] as? String
                print("Order Status: ", paymentStatus!)
                txnType = TxnDetails["type"] as? String
                txnDate = TxnDetails["date_time"] as? String
            }
            
            if let OrderDetails = Data["transactions"] as? [[String : Any]]{
                print ("OrderDetails = \(OrderDetails[0])")
                let TxnDetails = OrderDetails[0]
                paymentStatus = TxnDetails["gateway_code"] as? String
                print("Order Status: ", paymentStatus!)
            }
            
            let amount = Data["total_amount"] as? String
            let orderId = Data["order_id"] as? String
            let transactionId = Data["transaction_id"] as? String
            let accountIdentifier = Data["account_identifier"] as? String
            let cardBrand = Data["card_brand"] as? String
            
            var emailAddress: String!
            var phoneNumber: String!
            var country: String!
            if let CustomerDetails = Data["customer_details"] as? [String : Any]{
                emailAddress = CustomerDetails["email"] as? String;
                phoneNumber = CustomerDetails["mobile_no"] as? String;
                
                if let BillingAddress = CustomerDetails["billing_address"] as? [String : Any]{
                    country = BillingAddress["country"] as? String;
                }
            }
            
            self.showPrice(value:  amount!)
            self.showOrderId(value: orderId!)
            self.showTransactionId(value: transactionId!)
            self.showTransactionType(value:  txnType!)
            self.showTransactionStatus(value:  paymentStatus!)
            self.showTransactionTime(value: txnDate!)
            self.showCard(value: cardBrand! ,value2: accountIdentifier!)
            self.showEmailAddress(value: emailAddress!)
            self.showPhoneNumber(value: phoneNumber!)
            self.showCountry(value: country!)
            
        }
        
        
        if(paymentStatus! == "AUTHORIZED"){
            //            ivStatus.image = successGif
            self.showStatusLabel(labelText: "Paid successfully!")
            self.statusLabel.textColor = .white
            headerView.backgroundColor = .systemGreen
            self.loadImageFromUrl(url: "https://cdn-icons-png.flaticon.com/512/7799/7799536.png", imageView: self.ivStatus)
        }else if(paymentStatus! == "CANCELLED"){
            ivStatus.image = failedImg
            self.showStatusLabel(labelText: "Payment is cancelled!")
            self.statusLabel.textColor = .white
            headerView.backgroundColor = .systemRed
            self.loadImageFromUrl(url: "https://www.freeiconspng.com/uploads/error-icon-4.png", imageView: self.ivStatus)
        }else if(paymentStatus! == "FAILED"){
            ivStatus.image = failedImg
            self.showStatusLabel(labelText: "Payment is failed!")
            self.statusLabel.textColor = .white
            headerView.backgroundColor = .systemRed
            self.loadImageFromUrl(url: "https://www.freeiconspng.com/uploads/error-icon-4.png", imageView: self.ivStatus)
        }else {
            self.showStatusLabel(labelText: paymentStatus!)
            self.statusLabel.textColor = .white
            headerView.backgroundColor = .systemOrange
            self.loadImageFromUrl(url: "https://origin-staticv2.sonyliv.com/UI_icons/Tray_With_BG_Image/Inprogress_icon.png", imageView: self.ivStatus)
        }
        
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
                    print("Downloaded image with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        if #available(iOS 13.0, *) {
                            image?.withTintColor(UIColor.white)
                        } else {
                            // Fallback on earlier versions
                        }
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
