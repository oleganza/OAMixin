#import <Foundation/Foundation.h>
#import "FatClass.h"
int main (int argc, const char * argv[]) 
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  
  FatClass* object = [[[FatClass alloc] init] autorelease];
  
  NSLog(@"isColored = %d",   (NSUInteger)[object isColored]);
  NSLog(@"isColorable = %d", (NSUInteger)[object isColorable]);
  
  [pool drain];
  return 0;
}
