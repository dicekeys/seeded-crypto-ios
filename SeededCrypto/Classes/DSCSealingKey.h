#import "DSCPackagedSealedMessage.h"
#import <Foundation/Foundation.h>

struct SealingKey;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SealingKey)
@interface DSCSealingKey : NSObject

- (instancetype)initWithSealingKeyObject:(struct SealingKey *)sealingKey;

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (instancetype)fromJsonWithSealingKeyAsJson:(NSString *)sealingKeyAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                          sealingInstructions:(NSString *)sealingInstructions;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                        sealingInstructions:(NSString *)sealingInstructions;

@property(readonly) NSString *derivationOptionsJson;

@end

NS_ASSUME_NONNULL_END
