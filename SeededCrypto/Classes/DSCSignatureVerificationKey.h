#import <Foundation/Foundation.h>

#ifdef __cplusplus
#endif

NS_ASSUME_NONNULL_BEGIN

struct SignatureVerificationKey;

NS_SWIFT_NAME(SignatureVerificationKey)
@interface DSCSignatureVerificationKey : NSObject

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithSignatureVerificationKeyAsJson:
                    (NSString *)signatureVerificationKeyAsJson
                                                     error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSString *derivationOptionsJson;

@property(readonly) NSData *signatureVerificationKeyBytes;

- (instancetype)initWithSignatureVerificationKeyObject:
    (struct SignatureVerificationKey *)signatureVerificationKey;

- (BOOL)verifyWithMessage:(NSString *)message
                signature:(NSData *)signature
                    error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (BOOL)verifyWithData:(NSData *)data
             signature:(NSData *)signature
                 error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

@end

NS_ASSUME_NONNULL_END
