#import "OAMixin.h"
#import <objc/runtime.h>

@implementation NSObject (OAMixin)
+ (void) addOAMixin:(Class) mixin
{
  [mixin addToClass:self];
}
@end


@implementation OAMixin

+ (void) addToClass:(Class) cls
{
  NSLog(@"Adding %@ to %@", self, cls);
  // TODO: copy ivars, methods, properties and class methods
}

+ (void) initializeMixinsForClass: (Class) cls
{
  // TODO: Find protocols, find mixins with the same name and add these mixins
  unsigned int outCount;
  Protocol** protocols = class_copyProtocolList(cls, &outCount);
  Protocol* protocol;
  unsigned int index = 0;
  while (index < outCount)
  {
    protocol = protocols[index++];
    NSLog(@"Class %@ has a protocol %s", cls, protocol_getName(protocol));
  }
  free(protocols);
}

@end
