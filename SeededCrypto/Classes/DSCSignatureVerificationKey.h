#import <Foundation/Foundation.h>

#ifdef __cplusplus
#endif

NS_ASSUME_NONNULL_BEGIN

struct SignatureVerificationKey;

NS_SWIFT_NAME(SignatureVerificationKey)
@interface DSCSignatureVerificationKey : NSObject

+ (instancetype)deriveFromSeedWithSeedString:(NSString*)seedString derivationOptionsJson:(NSString*)derivationOptionsJson;

+ (instancetype)fromJsonWithSignatureVerificationKeyAsJson:(NSString*)signatureVerificationKeyAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm;

- (NSString*)toJson;

- (NSData*)toSerializedBinaryForm;

@property(readonly) NSString* derivationOptionsJson;

@property(readonly) NSData* signatureVerificationKeyBytes;

- (instancetype)initWithSignatureVerificationKeyObject:(struct SignatureVerificationKey*)signatureVerificationKey;

- (BOOL)verifyWithMessage:(NSString*)message signature:(NSData*)signature;

@end

NS_ASSUME_NONNULL_END
