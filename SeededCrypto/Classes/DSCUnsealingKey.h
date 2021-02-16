#import "DSCPackagedSealedMessage.h"
#import "DSCSealingKey.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct UnsealingKey;

NS_SWIFT_NAME(UnsealingKey)
@interface DSCUnsealingKey : NSObject

- (instancetype)initWithUnsealingKeyObject:(struct UnsealingKey *)unsealingKey;

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithUnsealingKeyAsJson:(NSString *)unsealingKeyAsJson
                                         error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)jsonPackagedSealedMessage
                                     seedString:(NSString *)seedString
                                          error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString
                                            error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstrucation:(NSString *)unsealingInstrucations
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
                     unsealingInstrucation:(NSString *)unsealingInstrucations
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCSealingKey *)sealingKey;

- (NSData *)unsealWithCiphertext:(NSData *)ciphertext
           unsealingInstructions:(NSString *)unsealingInstructions
                           error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
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

@property(readonly) NSData *sealingKeyBytes;

@property(readonly) NSData *unsealingKeyBytes;

@property(readonly) NSString *recipe;

@end

NS_ASSUME_NONNULL_END
