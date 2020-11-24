#import "DSCSignatureVerificationKey.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SigningKey)
@interface DSCSigningKey : NSObject
+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (NSData *)generateSignatureWithMessage:(NSString *)message
                              seedString:(NSString *)seedString
                   derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (NSData *)generateSignatureWithData:(NSData *)data
                           seedString:(NSString *)seedString
                derivationOptionsJson:(NSString *)derivationOptionsJson;

- (NSData *)generateSignatureWithMessage:(NSString *)message;

- (NSData *)generateSignatureWithData:(NSData *)data;

+ (instancetype)fromJsonWithSeedAsString:(NSString *)seedAsString;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSString *derivationOptionsJson;

@property(readonly) DSCSignatureVerificationKey *signatureVerificationKey;

@property(readonly) NSData *signingKeyBytes;

@property(readonly) NSData *signatureVerificationKeyBytes;

@end

NS_ASSUME_NONNULL_END
