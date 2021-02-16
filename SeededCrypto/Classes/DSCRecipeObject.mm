#import "DSCRecipeObject.h"
#import "DSCHelper.h"
#include "recipe.hpp"
#include "sodium-buffer.hpp"

@implementation DSCRecipeObject
+ (NSData *)derivePrimarySecretWithSeedString:(NSString *)seedString
                        recipe:(NSString *)recipe
                                        error:(NSError **)error {
  SodiumBuffer sodiumBuffer = Recipe::derivePrimarySecret(
      [seedString UTF8String], [recipe UTF8String]);
  try {
    return sodiumBufferToData(sodiumBuffer);
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

@end
