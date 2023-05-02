//
//  IndicatorViewController.swift
//  WebViewDemo
//
//  Created by Hydrus on 21/04/23.
//

import UIKit

class IndicatorViewController: UIViewController {

    
    @IBOutlet weak var textLbl: UILabel!

    var containerView = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let _  = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (_) in
            self.textLbl.text = "Stop ActivitiIndicator"
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func palyClicked(sender: AnyObject){

        containerView.frame = self.view.frame
        containerView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        self.view.addSubview(containerView)

        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        containerView.addSubview(loadingView)

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
