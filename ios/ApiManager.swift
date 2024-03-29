//
//  ApiManager.swift
//  WebViewDemo
//
//  Created by Hydrus on 21/04/23.
//

import UIKit

class ApiManager: NSObject {
    
    static func BuildRequest(url: String, parameters: [String: Any]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("074E1F9E8KF87HJDF8DF09DDD3A377760", forHTTPHeaderField: "xusername")
        request.addValue("54607074E1F9DE8KF87HJDF8DF09DDD", forHTTPHeaderField: "xpassword")
        if(parameters["merchantKey"] != nil && parameters["merchantSecret"] != nil){
            request.addValue(parameters["merchantKey"] as! String, forHTTPHeaderField: "merchant_key")
            request.addValue(parameters["merchantSecret"] as! String, forHTTPHeaderField: "merchant_secret")
        }
        request.addValue("49.36.34.70", forHTTPHeaderField: "ip")
        request.addValue("iOS", forHTTPHeaderField: "os")
        request.addValue("49.36.34.70", forHTTPHeaderField: "ip_country")
      return request
    }
    
    
    static func getMerchantRegionRequest(url: String, parameters:[String: Any], completion: @escaping(ResponseBean)-> Void) {
            let session = URLSession.shared
            // Build API Request
        let request = BuildRequest(url: url, parameters: parameters["data"] as! [String : Any])
        
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
                let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                    var statusCode = 100
                    if let response = response {
                        let nsHTTPResponse = response as! HTTPURLResponse
                         statusCode = nsHTTPResponse.statusCode
                    }
                    
                    if error != nil {
//                        print ("Error: -> \(error)")
                        let responseBean = ResponseBean()
                        responseBean.status = 400
                        responseBean.message = "Network connection error! Please check your internet connection and try again"
                        responseBean.data = ""
                        completion(responseBean)
                        return
                    }
                    
                    if let data = data {
                            
                        guard let parsedResult = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any]
                        else {
                            print("Could not parse the data as JSON: '\(data)'")
                            
                            let responseBean = ResponseBean()
                            responseBean.status = 400
                            responseBean.message = "Something went wrong! Try again later."
                            responseBean.data = ""
                            completion(responseBean)
                            
                            return
                        }
                        
                        var SuccessUrl = ""
                        var CancelUrl = ""
                        var FailurUrl = ""
                        if let params = parameters["data"] as? [String : Any]{
                            if let urls = params["merchant_urls"] as? [String : Any]{                   SuccessUrl = urls["success"] as! String
                                CancelUrl = urls["cancel"] as! String
                                FailurUrl = urls["failure"] as! String
                            }
                        }
                        
                        let responseBean = ResponseBean()
                        responseBean.status = statusCode
                        responseBean.message = "Fetch successfully!"
                        responseBean.data = parsedResult
                        responseBean.successUrl = SuccessUrl
                        responseBean.cancelUrl = CancelUrl
                        responseBean.failuerUrl = FailurUrl
                        completion(responseBean)
                            
                    }
                    
                })
                task.resume()
            }catch _ {
                print ("Oops something happened buddy")
            }
        }
    
    static func createOrderApiRequest(url: String, parameters:[String: Any], completion: @escaping(ResponseBean)-> Void) {
            let session = URLSession.shared
            // Build API Request
        let request = BuildRequest(url: url, parameters: parameters["data"] as! [String : Any])
        
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
                let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                    var statusCode = 100
                    if let response = response {
                        let nsHTTPResponse = response as! HTTPURLResponse
                         statusCode = nsHTTPResponse.statusCode
                    }
                    
                    if error != nil {
//                        print ("Error: -> \(error)")
                        let responseBean = ResponseBean()
                        responseBean.status = 400
                        responseBean.message = "Network connection error! Please check your internet connection and try again"
                        responseBean.data = ""
                        completion(responseBean)
                        return
                    }
                    
                    if let data = data {
                            
                        guard let parsedResult = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any]
                        else {
                            print("Could not parse the data as JSON: '\(data)'")
                            
                            let responseBean = ResponseBean()
                            responseBean.status = 400
                            responseBean.message = "Something went wrong! Try again later."
                            responseBean.data = ""
                            completion(responseBean)
                            
                            return
                        }
                        
                        var SuccessUrl = ""
                        var CancelUrl = ""
                        var FailurUrl = ""
                        if let params = parameters["data"] as? [String : Any]{
                            if let urls = params["merchant_urls"] as? [String : Any]{                   SuccessUrl = urls["success"] as! String
                                CancelUrl = urls["cancel"] as! String
                                FailurUrl = urls["failure"] as! String
                            }
                        }
                        
                        let responseBean = ResponseBean()
                        responseBean.status = statusCode
                        responseBean.message = "Fetch successfully!"
                        responseBean.data = parsedResult
                        responseBean.successUrl = SuccessUrl
                        responseBean.cancelUrl = CancelUrl
                        responseBean.failuerUrl = FailurUrl
                        completion(responseBean)
                            
                    }
                    
                })
                task.resume()
            }catch _ {
                print ("Oops something happened buddy")
            }
        }
    
    
    static func checkOrderStatusApiRequest(url: String, parameters:[String: Any], completion: @escaping(ResponseBean)-> Void) {
            let session = URLSession.shared
            // Build API Request
        let request = BuildRequest(url: url, parameters: parameters)
        
        let parameters2: [String: Any] = [
            "order_id": parameters["order_id"] as! String,
//            "token": parameters["token"] as! String
        ]
        
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters2, options: JSONSerialization.WritingOptions())
                let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                    var statusCode = 100
                    if let response = response {
                        let nsHTTPResponse = response as! HTTPURLResponse
                         statusCode = nsHTTPResponse.statusCode
                    }
                    
                    if error != nil {
                        print ("Error: -> \(String(describing: error))")
                        let responseBean = ResponseBean()
                        responseBean.status = 400
                        responseBean.message = "Network connection error! Please check your internet connection and try again"
                        responseBean.data = ""
                        completion(responseBean)
                        return
                    }
                    
                    if let data = data {
                            
                        guard let parsedResult = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any]
                        else {
                            print("Could not parse the data as JSON: '\(data)'")
                            
                            let responseBean = ResponseBean()
                            responseBean.status = 400
                            responseBean.message = "Something went wrong! Try again later."
                            responseBean.data = ""
                            completion(responseBean)
                            
                            return
                        }
                        
                        let responseBean = ResponseBean()
                        responseBean.status = statusCode
                        responseBean.message = "Fetch successfully!"
                        responseBean.data = parsedResult
                        completion(responseBean)
                            
                    }
                    
                })
                task.resume()
                
            }catch _ {
                print ("Oops something happened buddy")
            }
            
        }
    
    
    static func checkOrderDetailsApiRequest(url: String, parameters:[String: Any], completion: @escaping(ResponseBean)-> Void) {
            let session = URLSession.shared
            // Build API Request
        let request = BuildRequest(url: url, parameters: parameters)
        
        let parameters2: [String: Any] = [
            "order_id": parameters["order_id"] as! String,
            "token": parameters["token"] as! String
        ]
        
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters2, options: JSONSerialization.WritingOptions())
                
                let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                    var statusCode = 100
                    if let response = response {
                        let nsHTTPResponse = response as! HTTPURLResponse
                         statusCode = nsHTTPResponse.statusCode
                    }
                    
                    if error != nil {
                        print ("Error: -> \(String(describing: error))")
                        let responseBean = ResponseBean()
                        responseBean.status = 400
                        responseBean.message = "Network connection error! Please check your internet connection and try again"
                        responseBean.data = ""
                        completion(responseBean)
                        return
                    }
                    
                    if let data = data {
                            
                        guard let parsedResult = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any]
                        else {
                            print("Could not parse the data as JSON: '\(data)'")
                            
                            let responseBean = ResponseBean()
                            responseBean.status = 400
                            responseBean.message = "Something went wrong! Try again later."
                            responseBean.data = ""
                            completion(responseBean)
                            
                            return
                        }
                        
                        let responseBean = ResponseBean()
                        responseBean.status = statusCode
                        responseBean.message = "Fetch successfully!"
                        responseBean.data = parsedResult
                        completion(responseBean)
                            
                    }
                    
                })
                task.resume()
                
            }catch _ {
                print ("Oops something happened buddy")
            }
            
        }
}
