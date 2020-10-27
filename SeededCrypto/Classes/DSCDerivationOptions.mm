#import "DSCDerivationOptions.h"
#import "DSCHelper.h"
#include "sodium-buffer.hpp"
#include "derivation-options.hpp"

@implementation DSCDerivationOptions
+ (NSData*)derivePrimarySecretWithSeedString:(NSString*)seedString derivationOptionsJson:(NSString*)derivationOptionsJson {
    SodiumBuffer sodiumBuffer = DerivationOptions::derivePrimarySecret([seedString UTF8String], [derivationOptionsJson UTF8String]);
    return sodiumBufferToData(sodiumBuffer);
}


@end
