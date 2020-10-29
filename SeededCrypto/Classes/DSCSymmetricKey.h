#import "DSCPackagedSealedMessage.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SymmetricKey)
@interface DSCSymmetricKey : NSObject

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (instancetype)fromJsonWithSymmetricKeyAsJson:(NSString *)symmetricKeyAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:
                            (NSString *)unsealingInstrucations;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                      unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message;

- (NSData *)unsealWithPackagedSealedMessage:
    (DSCPackagedSealedMessage *)packagedSealedMessage;

- (NSData *)unsealCiphertext:(NSData *)ciphertext;

- (NSData *)unsealCiphertext:(NSData *)ciphertext
       unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)unsealJsonPackagedSealedMessage:
    (NSString *)packagedSealedMessageJson;

- (NSData *)unsealBinaryPackagedSealedMessage:
    (NSData *)binaryPackagedSealedMessage;

@property(readonly) NSData *keyBytes;

@property(readonly) NSString *derivationOptionsJson;

// static methods
+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions;

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:(NSString *)unsealingInstructions
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions;

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString;

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                     seedString:(NSString *)seedString;

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString;

@end

NS_ASSUME_NONNULL_END
