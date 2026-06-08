//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef Bridge_h
#define Bridge_h

#import "WacomTabletDriver.h"

#import <Foundation/Foundation.h>

@class ObjCWacom;

@interface ObjCWacom : NSObject {
}

+ (void)setScreenMapArea:(NSRect)rect tabletId:(int)tabletId;

@end

#endif /* Bridge_h */

// vim:ft=objc
