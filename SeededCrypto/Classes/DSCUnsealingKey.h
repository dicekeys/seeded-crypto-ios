#import "DSCPackagedSealedMessage.h"
#import "DSCSealingKey.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct UnsealingKey;

NS_SWIFT_NAME(UnsealingKey)
@interface DSCUnsealingKey : NSObject

- (instancetype)initWithUnsealingKeyObject:(struct UnsealingKey *)unsealingKey;

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (instancetype)fromJsonWithUnsealingKeyAsJson:(NSString *)unsealingKeyAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString;

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)jsonPackagedSealedMessage
                                     seedString:(NSString *)seedString;

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString;

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions;

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstrucation:(NSString *)unsealingInstrucations
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions;

- (DSCSealingKey *)sealingKey;

- (NSData *)unsealWithCiphertext:(NSData *)ciphertext
           unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)unsealWithPackagedSealedMessage:
    (DSCPackagedSealedMessage *)packagedSealedMessage;

- (NSData *)unsealWithJsonPackagedSealedMessage:
    (NSString *)packagedSealedMessageJson;

- (NSData *)unsealWithBinaryPackagedSealedMessage:
    (NSData *)binaryPackagedSealedMessage;

@property(readonly) NSData *sealingKeyBytes;

@property(readonly) NSData *unsealingKeyBytes;

@end

NS_ASSUME_NONNULL_END
