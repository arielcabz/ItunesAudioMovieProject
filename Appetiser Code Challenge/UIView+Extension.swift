//
//  UIView+Extension.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import UIKit

extension UIView {

    /// Enables view to user constraints
    func enableContraints() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Centers UIView in parent view Horizontally
    /// - Parameter view: The `view` is the parent view to center self(UIView) Horizontally.
    func centerHorizontal(to view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Centers UIView in parent view Vertically
    /// - Parameter view: The `view` is the parent view to center self(UIView) Vertically.
    func centerVertical(to view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /// Centers UIView in parent view
    /// - Parameter view: The `view` is the parent view to center self(UIView).
    func center(in view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    /// Sets view contrains (Anchors, Margin and Size)
    /// - Parameter top: The `top` sets view's topAnchor to parents view topAnchor. Default value is nil.
    /// - Parameter bottom: The `bottom` sets view's bottomAnchor to parents view bottomAnchor. Default value is nil.
    /// - Parameter leading: The `leading` sets view's leadingAnchor to parents view leadiingAnchor. Default value is nil.
    /// - Parameter trailing: The `trailing` sets view's trailingAnchor to parents view trailingAnchor. Default value is nil.
    /// - Parameter padding: The `padding` sets the self's margin. Default value is nil.
    /// - Parameter size: The `size` sets the view's size contraint. Default value is nil.
    func anchor(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding:
        UIEdgeInsets = .zero, size: CGSize = .zero) {
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
            
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
       setSize(size: size)
    }
    
    
    /// Fill parent with self
    /// - Parameter view: The `view` to inflate view in
    /// - Parameter padding: The `padding` sets the self's margin. Default value is nil.
    func fill(parent view: UIView, padding: UIEdgeInsets = .zero) {
        self.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: padding)
    }
    
    
    /// Fill parent with self
    /// - Parameter view: The `view` to inflate view in
    /// - Parameter size: The `size` sets the self's margin. Default value is nil.
    func setSize(size: CGSize = .zero) {
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
}
