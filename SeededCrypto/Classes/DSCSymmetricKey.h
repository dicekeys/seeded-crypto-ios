#import "DSCPackagedSealedMessage.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SymmetricKey)
@interface DSCSymmetricKey : NSObject

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (instancetype)fromJsonWithSymmetricKeyAsJson:(NSString *)symmetricKeyAsJson
    NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:
                            (NSString *)unsealingInstrucations;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message;

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstructions:(NSString *)unsealingInstrucations;

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                      unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message;

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                   unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data;

- (NSData *)unsealWithPackagedSealedMessage:
    (DSCPackagedSealedMessage *)packagedSealedMessage;

- (NSData *)unsealCiphertext:(NSData *)ciphertext;

- (NSData *)unsealCiphertext:(NSData *)ciphertext
       unsealingInstructions:(NSString *)unsealingInstructions;

- (NSData *)unsealWithJsonPackagedSealedMessage:
    (NSString *)packagedSealedMessageJson;

- (NSData *)unsealWithBinaryPackagedSealedMessage:
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

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                seedString:(NSString *)seedString
                         derivationOptions:(NSString *)derivationOptions;

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
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
