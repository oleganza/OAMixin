#import "OAMixin.h"
#import <objc/runtime.h>

@implementation NSObject (OAMixin)
+ (void) addOAMixin:(Class) mixin
{
  [mixin addToClass:self];
}
@end


@implementation OAMixin


BOOL OAMixin_identifyingMethod() { return YES; }

+ (void) addToClass:(Class) klass
{
  NSLog(@"Adding mixin %@ to class %@", self, klass);
  SEL mixinIdentifier = sel_registerName([[NSString stringWithFormat:@"containsOAMixin_%s", 
                                           class_getName(self)] 
                                          cStringUsingEncoding:NSUTF8StringEncoding]);
  if (class_respondsToSelector(klass, mixinIdentifier)) return;
  Class superclass = class_getSuperclass(klass);
  const char *name = [[NSString stringWithFormat:@"%s_mixed_to_%s", 
                       class_getName(self), 
                       class_getName(superclass)] 
                        cStringUsingEncoding:NSUTF8StringEncoding];
  Class mixedInClass = objc_allocateClassPair(superclass, name, 0);
  class_addMethod(mixedInClass, mixinIdentifier, (IMP) OAMixin_identifyingMethod, "v@:");
  // TODO: copy ivars, methods, properties and class methods to this subclass
  unsigned int methodsCount;
  Method* methods = class_copyMethodList(self, &methodsCount);
  Method method;
  unsigned int index = 0;
  while (index < methodsCount)
  {
    method = methods[index++];
    NSLog(@"Adding method %s from mixin %@", method_getName(method), self);
    class_addMethod(mixedInClass, 
                    method_getName(method), 
                    method_getImplementation(method), 
                    method_getTypeEncoding(method));
  }
  free(methods);
  
  objc_registerClassPair(mixedInClass);
  // Damn, class_setSuperclass is removed in ObjC 2.0
  // TODO: come up with some smart idea
//  class_setSuperclass(klass, mixedInClass);
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
    Class mixinmeta;
    if (mixin && (mixinmeta = objc_getMetaClass(name)) && 
        class_respondsToSelector(mixinmeta, @selector(isSubclassOfClass:)) && 
        [mixin isSubclassOfClass:[OAMixin class]])
    {
      [mixin addToClass:cls];
    }
  }
  free(protocols);
}

@end
