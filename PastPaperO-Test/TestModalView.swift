//
//  TestModalView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/16.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI

struct TestModalView: View {
@Environment(\.presentationMode) var presentationMode

    var body: some View {
        

    NavigationView {
        
        
        Text("hello")
      
        .navigationBarTitle("Detailed View")
        .navigationBarItems(trailing: Button("Dismiss") {
            self.presentationMode.wrappedValue.dismiss()
        })
            }
    }
}

struct DisableModalDismiss: ViewModifier {
    let disabled = false
    func body(content: Content) -> some View {
        disableModalDismiss()
        return AnyView(content)
    }

    func disableModalDismiss() {
        guard let visibleController = UIApplication.shared.visibleViewController() else { return }
        visibleController.isModalInPresentation = disabled
    }
}

struct TestModalView_Previews: PreviewProvider {
    static var previews: some View {
        TestModalView()
    }
}

extension UIApplication {

    func visibleViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        return UIApplication.getVisibleViewControllerFrom(vc: rootViewController)
    }

private static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIApplication.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIApplication.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIApplication.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
