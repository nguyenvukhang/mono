import Cocoa

let HELIUM = Helium()
var SCALE = 0.47
var ASPECT_RATIO = 16.0 / 10.0
var LINE_WIDTH = 5.0
var LINE_COLOR = NSColor(red: 0.925, green: 0.282, blue: 0.600, alpha: 0.5)
var CORNER_LENGTH = 50.0
var FULLSCREEN_KEEP_ASPECT_RATIO = true

func main() {
    NSWindowController(window: HELIUM.overlay).showWindow(HELIUM.overlay)
    startKeystrokeMonitor()
}

func date() -> String {
    Date().formatted(date: .omitted, time: .complete)
}

func acquirePrivileges() {
    let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
    let privOptions = [trusted: true] as CFDictionary
    let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)

    if accessEnabled == true {
    } else {}
}

acquirePrivileges()
main()
