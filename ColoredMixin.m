#import "ColoredMixin.h"

@implementation ColoredMixin
@synthesize color;

- (void) dealloc
{
  self.color = nil;
  [super dealloc];
}

- (BOOL) isColored
{
  return !!self.color;
}

@end
