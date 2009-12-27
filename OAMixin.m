#import "OAMixin.h"
#import <objc/runtime.h>

#define OAMixin_each_begin(type, name, method, receiver) { \
unsigned int oamixineach_itemsCount; \
type* oamixineach_items = method(receiver, &oamixineach_itemsCount); \
type name; \
unsigned int oamixineach_index = 0; \
while (oamixineach_index < oamixineach_itemsCount) { \
name = oamixineach_items[oamixineach_index++];


#define OAMixin_each_end } free(oamixineach_items); }



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
  OAMixin_each_begin(Method, method, class_copyMethodList, self)
    NSLog(@"Adding method %s from mixin %@", method_getName(method), self);
    class_addMethod(mixedInClass, 
                    method_getName(method), 
                    method_getImplementation(method), 
                    method_getTypeEncoding(method));
  OAMixin_each_end

//  OAMixin_each_begin(Method, method, class_copyMethodList, self)
//  NSLog(@"Adding method %s from mixin %@", method_getName(method), self);
//  class_addMethod(mixedInClass, 
//                  method_getName(method), 
//                  method_getImplementation(method), 
//                  method_getTypeEncoding(method));
//  OAMixin_each_end
  
  
  objc_registerClassPair(mixedInClass);
  // Damn, class_setSuperclass is deprecated in ObjC 2.0
  // TODO: come up with some smart idea
#if __OBJC2__
#warning Running Objective-C 2.0
#endif
  class_setSuperclass(klass, mixedInClass);
  
  
}

+ (void) initializeMixinsForClass: (Class) cls
{
  // Find protocols, find mixins with the same name and add these mixins
  OAMixin_each_begin(Protocol*, protocol, class_copyProtocolList, cls)
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
  OAMixin_each_end
}

@end
