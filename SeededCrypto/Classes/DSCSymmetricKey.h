#import "DSCPackagedSealedMessage.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SymmetricKey)
@interface DSCSymmetricKey : NSObject

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithSymmetricKeyAsJson:(NSString *)symmetricKeyAsJson
                                         error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:(NSString *)unsealingInstrucations
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstructions:(NSString *)unsealingInstrucations
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                      unsealingInstructions:(NSString *)unsealingInstructions
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                   unsealingInstructions:(NSString *)unsealingInstructions
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealCiphertext:(NSData *)ciphertext
                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealCiphertext:(NSData *)ciphertext
       unsealingInstructions:(NSString *)unsealingInstructions
                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                          error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                            error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

@property(readonly) NSData *keyBytes;

@property(readonly) NSString *recipe;

// static methods
+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:(NSString *)unsealingInstructions
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstructions:(NSString *)unsealingInstructions
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                     seedString:(NSString *)seedString
                                          error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString
                                            error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

@end

NS_ASSUME_NONNULL_END
