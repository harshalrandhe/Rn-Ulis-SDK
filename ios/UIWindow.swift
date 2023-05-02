//
//  UIWindow.swift
//  RnUlisSdk
//
//  Created by Hydrus on 02/05/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {

        if vc.isKind(of: UINavigationController.self) {

            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)

        } else if vc.isKind(of: UITabBarController.self) {

            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)

        } else {

            if let presentedViewController = vc.presentedViewController {

                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)

            } else {

                return vc;
            }
        }
    }
}
