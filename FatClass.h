#import "ColoredMixin.h"
@protocol SomeProtocol
@end
@interface FatClass : NSObject <ColoredMixin, SomeProtocol>
{
}

@end
