#import "FatClass.h"
#import "ColoredMixin.h"

@implementation FatClass

@dynamic color;
+ (void) initialize
{
  [OAMixin initializeMixinsForClass:self];
}

- (BOOL) isColored
{
  return NO;
}

@end
