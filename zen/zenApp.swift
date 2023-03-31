import Cocoa
import SwiftUI
import Combine
import AppKit

@main
struct zenApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {}
    }
}
