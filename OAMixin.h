#import <Cocoa/Cocoa.h>

@interface NSObject (OAMixin)
+ (void) addOAMixin:(Class) mixin;
@end

@interface OAMixin : NSObject 
{
}

+ (void) addToClass:(Class) cls;
+ (void) initializeMixinsForClass: (Class) cls;

@end
