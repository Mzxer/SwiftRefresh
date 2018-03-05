//
//  HeaderNormalDisplayView.swift
//  SwiftRefresh
//
//  Created by Zsam on 2018/2/4.
//  Copyright © 2018年 Mzxer. All rights reserved.
//

import UIKit

class NormalDisplayView: UIView, SwiftRefreshDisplayViewType {

    
    lazy var loadingView : UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    fileprivate let arrowImageV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: SR.bundleFile("arrow")) ??
            UIImage(named: SR.framWorkFile("arrow"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(loadingView)
        self.addSubview(arrowImageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let arrowCenter = CGPoint( x: self.sr_width * 0.5, y: self.sr_height * 0.5)
        arrowImageV.frame.size = arrowImageV.image!.size
        arrowImageV.center = arrowCenter
        loadingView.center = arrowCenter
    }
    
    
    func changeState(from fromState: SwiftRefreshState, to toState: SwiftRefreshState) {
        switch toState {
        case .idle:
            
            guard fromState == .refreshing else {
                loadingView.stopAnimating()
                arrowImageV.isHidden = false
                UIView.animate(withDuration: SR.animationDuration, animations: {
                    self.arrowImageV.transform = .identity
                })
                return
            }
            
            arrowImageV.transform = .identity
            UIView.animate(withDuration: SR.animationDuration, animations: {
                self.loadingView.alpha = 0
            }, completion: { (_) in
                self.loadingView.alpha = 1
                self.loadingView.stopAnimating()
                self.arrowImageV.isHidden = false
            })
        case .pulling:
            
            loadingView.stopAnimating()
            arrowImageV.isHidden = false
            UIView.animate(withDuration: SR.animationDuration, animations: {
                self.arrowImageV.transform = CGAffineTransform(rotationAngle: CGFloat(0.000001 - Double.pi))
            })
            
        case .refreshing:
            loadingView.alpha = 1.0
            loadingView.startAnimating()
            arrowImageV.isHidden = true
        default: break
        }
        
    }
   

}
