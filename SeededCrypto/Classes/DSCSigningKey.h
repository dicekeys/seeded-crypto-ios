#import "DSCSignatureVerificationKey.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SigningKey)
@interface DSCSigningKey : NSObject
+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)generateSignatureWithMessage:(NSString *)message
                              seedString:(NSString *)seedString
                   recipe:(NSString *)recipe
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (NSData *)generateSignatureWithData:(NSData *)data
                           seedString:(NSString *)seedString
                recipe:(NSString *)recipe
                                error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)generateSignatureWithMessage:(NSString *)message
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSData *)generateSignatureWithData:(NSData *)data
                                error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithSeedAsString:(NSString *)seedAsString
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSString *recipe;
@property(readonly) NSString *openSshPublicKey;
@property(readonly) NSString *openSshPemPrivateKey;
@property(readonly) NSString *openPgpPemFormatSecretKey;

@property(readonly) DSCSignatureVerificationKey *signatureVerificationKey;

@property(readonly) NSData *signingKeyBytes;

@property(readonly) NSData *signatureVerificationKeyBytes;

@end

NS_ASSUME_NONNULL_END
