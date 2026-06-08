import Cocoa

func handleProximityEvent(_ event: CGEvent) {
    HELIUM.penInProximity = event.getIntegerValueField(.tabletProximityEventEnterProximity) != 0
    HELIUM.lastUsedTablet = Int32(event.getIntegerValueField(.tabletProximityEventSystemTabletID))
}

func handleKeyDownEvent(_ event: CGEvent) -> Unmanaged<CGEvent>? {
    let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
    let flags = event.flags

    // Ctrl+C kills the program
    // if keyCode == 0x08, flags.contains(.maskControl) { exit(0) }

    // keyCode 17 is 't' in US ANSI
    if keyCode == 17, flags.contains([.maskControl, .maskAlternate, .maskCommand]) {
        if flags.contains(.maskShift) {
            HELIUM.mode = .precision
            HELIUM.preview()
        } else {
            HELIUM.mode = .fullscreen
            HELIUM.preview()
        }
        return nil
    }

    return Unmanaged.passUnretained(event)
}

func eventCallback(_: CGEventTapProxy,
                   type: CGEventType,
                   event: CGEvent,
                   _: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>?
{
    switch type {
    case .tabletProximity: handleProximityEvent(event)
    case .keyDown: return handleKeyDownEvent(event)
    default: return Unmanaged.passUnretained(event)
    }
    return nil // return nil to consume the event.
}

/// Start running the keystroke monitor. Note that this means the program will
/// stay alive and will run forever.
func startKeystrokeMonitor() {
    let eventMask =
        (1 << CGEventType.keyDown.rawValue) |
        (1 << CGEventType.tabletProximity.rawValue)
    guard let eventTap = CGEvent.tapCreate(tap: .cghidEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: CGEventMask(eventMask), callback: eventCallback, userInfo: nil) else {
        print(date(), "Failed to create event tap")
        exit(1)
    }
    let rlSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    print(date(), "Starting run loop!")
    CFRunLoopRun()
}
