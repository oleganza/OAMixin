#import "OAMixin.h"

@implementation OAMixin

+ (void) addToClass:(Class) cls
{
  NSLog(@"Adding %@ to %@", self, cls);
  // TODO: copy ivars, methods, properties and class methods
}

+ (void) initializeMixinsForClass: (Class) cls
{
  // TODO: Find protocols, find mixins with the same name and add these mixins
  
}

@end
