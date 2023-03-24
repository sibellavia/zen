//
//  zenApp.swift
//  zen
//
//  Created by Simone Bellavia on 24/03/23.
//

import SwiftUI

@main
struct zenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.black)
                .foregroundColor(.white)
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.setContentSize(NSSize(width: 350, height: 240))
                        window.styleMask.remove(.resizable)
                        window.titleVisibility = .hidden
                        window.titlebarAppearsTransparent = true
                    }
                }
                .fixedSize()
                .frame(width: 350, height: 240, alignment: .center)
        }
    }
}

