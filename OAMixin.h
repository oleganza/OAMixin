#import <Cocoa/Cocoa.h>

@interface OAMixin : NSObject 
{
}

+ (void) addToClass:(Class) cls;
+ (void) initializeMixinsForClass: (Class) cls;

@end
