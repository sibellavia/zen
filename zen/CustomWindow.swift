//
//  CustomWindow.swift
//  zen
//
//  Created by Simone Bellavia on 24/03/23.
//

import SwiftUI

class CustomWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        setContentSize(NSSize(width: 350, height: 240))
        minSize = NSSize(width: 350, height: 240)
        maxSize = NSSize(width: 350, height: 240)
    }
}

