#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(DerivationOptions)
@interface DSCDerivationOptions : NSObject
+ (NSData *)derivePrimarySecretWithSeedString:(NSString *)seedString
                        derivationOptionsJson:(NSString *)derivationOptionsJson
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));
@end

NS_ASSUME_NONNULL_END
