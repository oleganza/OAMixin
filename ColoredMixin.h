#import <Cocoa/Cocoa.h>
#import "OAMixin.h"

@protocol ColoredMixin
@optional
- (BOOL) isColored;
@property(nonatomic, retain) NSColor* color;
@end

@interface ColoredMixin : OAMixin <ColoredMixin>
{
  NSColor* color;
}

@end
