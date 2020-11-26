#import "DSCDerivationOptions.h"
#import "DSCHelper.h"
#include "derivation-options.hpp"
#include "sodium-buffer.hpp"

@implementation DSCDerivationOptions
+ (NSData *)derivePrimarySecretWithSeedString:(NSString *)seedString
                        derivationOptionsJson:(NSString *)derivationOptionsJson
                                        error:(NSError **)error {
  SodiumBuffer sodiumBuffer = DerivationOptions::derivePrimarySecret(
      [seedString UTF8String], [derivationOptionsJson UTF8String]);
  try {
    return sodiumBufferToData(sodiumBuffer);
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

@end
