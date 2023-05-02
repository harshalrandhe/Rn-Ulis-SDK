//
//  ResponseBean.swift
//  WebViewDemo
//
//  Created by Hydrus on 21/04/23.
//

import UIKit

class ResponseBean: NSObject {
    var status: Int = 0
    var message: String = ""
    var data: Any = ""
    var successUrl: String = ""
    var cancelUrl: String = ""
    var failuerUrl: String = ""
}
