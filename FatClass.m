#import "FatClass.h"
#import "ColoredMixin.h"

@implementation FatClass

+ (void) initialize
{
  [OAMixin initializeMixinsForClass:self];
}

- (BOOL) isColored
{
  return NO;
}

@end
