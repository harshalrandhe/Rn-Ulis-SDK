//
//  UlisEventEmitter.swift
//  RnUlisSdk
//
//  Created by Hydrus on 28/04/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

@objc(UlisEventEmitter)
class UlisEventEmitter: RCTEventEmitter {

  public static var emitter: RCTEventEmitter!

  override init() {
    super.init()
      UlisEventEmitter.emitter = self
  }

  open override func supportedEvents() -> [String] {
    ["Telr::PAYMENT_SUCCESS", "Telr::PAYMENT_ERROR", "Telr::PAYMENT_CANCELLED"] 
  }
}
