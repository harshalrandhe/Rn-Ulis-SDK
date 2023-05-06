//
//  UIApplication.swift
//  RnUlisSdk
//
//  Created by Hydrus on 03/05/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

extension UIApplication {

  class func topMostViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

    if let navigationController = controller as? UINavigationController {
      return topMostViewController(controller: navigationController.visibleViewController)
    }

    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topMostViewController(controller: selected)
      }
    }

    if let presented = controller?.presentedViewController {
      return topMostViewController(controller: presented)
    }

    return controller
  }
}
