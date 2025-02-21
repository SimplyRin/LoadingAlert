//
//  LoadingViewController.swift
//  LoadingAlert
//  
//  Created by Sasai Hiroki on 2025/02/20
//
// Copyright (c) 2025 Sasai Hiroki
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

class LoadingAlertViewController: UIViewController {
    
    private static var instances: [UIViewController : LoadingAlertViewController] = [:]
    
    public static func getInstance(_ controller: UIViewController) -> LoadingAlertViewController {
        if (self.instances[controller] == nil) {
            let storyboard = UIStoryboard(name: "LoadingAlert", bundle: nil)
            let loadingAlert = storyboard.instantiateViewController(withIdentifier: "LoadingAlertViewController") as! LoadingAlertViewController
            _ = loadingAlert.setBaseViewController(controller)
            
            self.instances[controller] = loadingAlert
        }
        
        return self.instances[controller]!
    }
    
    public static func getInstanceAuto(instance: @escaping (LoadingAlertViewController) -> Void) {
        DispatchQueue.main.async {
            let topView = self.getTopViewController()
            let view = self.getInstance(topView)
            
            instance(view)
        }
    }
    
    public static func getTopViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return UIViewController()
        }
        return getTopViewController(from: rootViewController)
    }

    private static func getTopViewController(from viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        
        else if let navigationController = viewController as? UINavigationController {
            return getTopViewController(from: navigationController.visibleViewController ?? navigationController)
        }
        
        else if let tabBarController = viewController as? UITabBarController {
            return getTopViewController(from: tabBarController.selectedViewController ?? tabBarController)
        }
        return viewController
    }
    
    // 表示するベースビュー
    private var baseViewController: UIViewController!
    
    public func setBaseViewController(_ baseViewController: UIViewController!) -> LoadingAlertViewController {
        self.baseViewController = baseViewController
        return self
    }
    
    // バックグラウンドビューの暗さ (最大1.0、1.0で真っ黒)
    private var backgroundBrightness: CGFloat = 0.25
    
    public func setBackgroundBrightness(_ alpha: CGFloat) -> LoadingAlertViewController {
        self.backgroundBrightness = alpha >= 1.0 ? 1.0 : alpha
        return self
    }
    
    // 表示するテキスト
    private var text: String = "Loading..."
    
    public func setText(_ text: String) -> LoadingAlertViewController {
        self.text = text
        return self
    }
    
    // 角丸
    private var cornerRadius: Double? = 10
    
    public func setCornerRadius(_ cornerRadius: Double?) -> LoadingAlertViewController {
        self.cornerRadius = cornerRadius
        return self
    }
    
    // バックグラウンドカラー
    private var backgroundColor: UIColor?
    
    public func setBackgroundColor(_ backgroundColor: UIColor!) -> LoadingAlertViewController {
        self.backgroundColor = backgroundColor
        return self
    }
    
    // ローディングインジゲーターカラー
    private var loadingIndicatorColor: UIColor?
    
    public func setLoadingIndicatorColor(_ loadingIndicatorColor: UIColor!) -> LoadingAlertViewController {
        self.loadingIndicatorColor = loadingIndicatorColor
        return self
    }
    
    // テキストカラー
    private var textColor: UIColor?
    
    public func setTextColor(_ textColor: UIColor!) -> LoadingAlertViewController {
        self.textColor = textColor
        return self
    }
    
    private var alertyInit = false;
    
    public func setupLoadingAlert() -> LoadingAlertViewController {
        if (self.alertyInit) {
            return self;
        }
        
        self.alertyInit = true;
        
        self.loadView()
        self.viewDidLoad()
        
        self.baseViewController.view.addSubview(self.view)
        self.baseViewController.addChild(self)
        
        self.didMove(toParent: self.baseViewController)
        
        return self
    }
    
    // MARK: - UIViewController
    
    // ルートビュー
    @IBOutlet var ui_RootView: UIView!
    
    // バックグラウンドビュー
    @IBOutlet weak var ui_BackgroundView: UIView!
    
    // ローディングインジゲーター、テキストを置いているビュー
    @IBOutlet weak var ui_BaseView: UIView!

    // ローディングインジゲーター
    @IBOutlet weak var ui_ActivityIndicator: UIActivityIndicatorView!
    
    // テキスト
    @IBOutlet weak var label_Text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デフォルトでは非表示
        self.ui_RootView.isHidden = true
        
        // アラート角丸
        if let cornerRadius = self.cornerRadius {
            self.ui_BaseView.layer.cornerRadius = cornerRadius
        }
        self.ui_BaseView.layer.masksToBounds = true
        self.ui_BaseView.clipsToBounds = true
        
        // バックグラウンドの明るさ
        self.ui_BackgroundView.alpha = self.backgroundBrightness
        
        // ローディングアニメーション
        self.ui_ActivityIndicator.startAnimating()
        
        // テキスト設定
        self.label_Text.text = self.text
        
        // アラートバックグラウンドカラー設定
        if let backgroundColor = self.backgroundColor {
            self.ui_BaseView.backgroundColor = backgroundColor
        }
        
        // ローディングインジゲーターカラー
        if let loadingIndicatorColor = self.loadingIndicatorColor {
            self.ui_ActivityIndicator.color = loadingIndicatorColor
        }
        
        // テキストカラー
        self.label_Text.textColor = self.textColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let parentView = self.baseViewController.view {
            NSLayoutConstraint.activate([
                self.view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                self.view.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
                self.view.widthAnchor.constraint(equalToConstant: 317),
                self.view.heightAnchor.constraint(equalToConstant: 128)
            ])
        }
    }
    
    public func show() {
        DispatchQueue.main.async {
            self.ui_RootView.isHidden = false
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            self.ui_RootView.isHidden = true
        }
    }
    
    
}

