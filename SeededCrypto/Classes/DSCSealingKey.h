#import "DSCPackagedSealedMessage.h"
#import <Foundation/Foundation.h>

struct SealingKey;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SealingKey)
@interface DSCSealingKey : NSObject

- (instancetype)initWithSealingKeyObject:(struct SealingKey *)sealingKey;

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithSealingKeyAsJson:(NSString *)sealingKeyAsJson
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                          sealingInstructions:(NSString *)sealingInstructions
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                        sealingInstructions:(NSString *)sealingInstructions
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                       sealingInstructions:(NSString *)sealingInstructions
                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                     sealingInstructions:(NSString *)sealingInstructions
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

@property(readonly) NSString *recipe;

@end

NS_ASSUME_NONNULL_END
