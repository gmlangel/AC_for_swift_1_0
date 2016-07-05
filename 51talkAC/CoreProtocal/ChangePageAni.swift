//
//  ChangePageAni.swift
//  AC for swift
//
//  Created by guominglong on 15/12/10.
//  Copyright (c) 2015年 guominglong. All rights reserved.
//

import Foundation
class ChangePageAni:NSObject,NSViewControllerPresentationAnimator {
    func animatePresentationOfViewController(toViewController: NSViewController, fromViewController: NSViewController) {
        
        toViewController.view.wantsLayer = true
        toViewController.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        toViewController.view.alphaValue = 0
        fromViewController.view.addSubview(toViewController.view)
        toViewController.view.frame = fromViewController.view.frame
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 2
            toViewController.view.animator().alphaValue = 1
            }, completionHandler: nil)
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        
        viewController.view.wantsLayer = true
        viewController.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 2
            viewController.view.animator().alphaValue = 0
            }, completionHandler: {
                viewController.view.removeFromSuperview()
        })
    }
}