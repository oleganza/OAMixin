#import "OAMixin.h"
#import <objc/runtime.h>

@implementation NSObject (OAMixin)
+ (void) addOAMixin:(Class) mixin
{
  [mixin addToClass:self];
}
@end


@implementation OAMixin

+ (void) addToClass:(Class) klass
{
  NSLog(@"Adding mixin %@ to class %@", self, klass);
  // TODO: create a new subclass for a klass's superclass
  // TODO: copy ivars, methods, properties and class methods to this subclass
  // TODO: switch klass's superclass to the mixin
  
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
    const char* name = protocol_getName(protocol);
    NSLog(@"Class %@ has a protocol %s", cls, name);
    Class mixin = objc_getClass(name);
    Class mixinmeta = objc_getMetaClass(name);
    if (mixin && mixinmeta && 
        class_respondsToSelector(mixinmeta, @selector(isSubclassOfClass:)) && 
        [mixin isSubclassOfClass:[OAMixin class]])
    {
      [mixin addToClass:cls];
    }
  }
  free(protocols);
}

@end
