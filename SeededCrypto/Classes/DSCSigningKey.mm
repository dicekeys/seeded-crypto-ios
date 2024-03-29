#import "DSCSigningKey.h"
#import "DSCHelper.h"
#include "signing-key.hpp"

@interface DSCSigningKey ()
- (instancetype)initWithSigningKeyObject:(SigningKey *)signingKey;
@end

@implementation DSCSigningKey {
  SigningKey *_signingKeyObject;
}

+ (NSData *)generateSignatureWithMessage:(NSString *)message
                              seedString:(NSString *)seedString
                   recipe:(NSString *)recipe
                                   error:(NSError **)error {
  return [[DSCSigningKey deriveFromSeedWithSeedString:seedString
                                recipe:recipe
                                                error:error]
      generateSignatureWithMessage:message
                             error:error];
}

+ (NSData *)generateSignatureWithData:(NSData *)data
                           seedString:(NSString *)seedString
                recipe:(NSString *)recipe
                                error:(NSError **)error {
  return [[DSCSigningKey deriveFromSeedWithSeedString:seedString
                                recipe:recipe
                                                error:error]
      generateSignatureWithData:data
                          error:error];
}

- (instancetype)initWithSigningKeyObject:(SigningKey *)signingKey {
  self = [[DSCSigningKey alloc] init];
  if (self != NULL) {
    _signingKeyObject = signingKey;
  }
  return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error {
  try {
    SigningKey signingKey = SigningKey::deriveFromSeed(
        [seedString UTF8String], [recipe UTF8String]);
    return [[DSCSigningKey alloc]
        initWithSigningKeyObject:new SigningKey(signingKey)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromJsonWithSeedAsString:(NSString *)seedAsString
                                   error:(NSError **)error {
  try {
    SigningKey obj = SigningKey::fromJson([seedAsString UTF8String]);
    return [[DSCSigningKey alloc] initWithSigningKeyObject:new SigningKey(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  SigningKey obj = SigningKey::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCSigningKey alloc] initWithSigningKeyObject:new SigningKey(obj)];
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_signingKeyObject->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer = _signingKeyObject->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (NSData *)generateSignatureWithMessage:(NSString *)message
                                   error:(NSError **)error {
  try {
    return unsignedCharVectorToData(_signingKeyObject->generateSignature(
        stringToUnsignedCharArray(message), message.length));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)generateSignatureWithData:(NSData *)data error:(NSError **)error {
  try {
    return unsignedCharVectorToData(
        _signingKeyObject->generateSignature(dataToUnsignedCharVector(data)));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSString *)recipe {
  return [NSString
      stringWithUTF8String:_signingKeyObject->recipe.c_str()];
}

- (NSString *)openSshPublicKey {
  return [NSString
      stringWithUTF8String:_signingKeyObject->toOpenSshPublicKey().c_str()];
}

- (NSString *)openSshPemPrivateKey {
  return [NSString
      stringWithUTF8String:_signingKeyObject->toOpenSshPemPrivateKey("").c_str()];
}

- (NSString *)openPgpPemFormatSecretKey {
  return [NSString
      stringWithUTF8String:_signingKeyObject->toOpenPgpPemFormatSecretKey("", 0).c_str()];
}

- (DSCSignatureVerificationKey *)signatureVerificationKey {
  SignatureVerificationKey key =
      _signingKeyObject->getSignatureVerificationKey();
  return [[DSCSignatureVerificationKey alloc]
      initWithSignatureVerificationKeyObject:new SignatureVerificationKey(key)];
}

- (NSData *)signingKeyBytes {
  return sodiumBufferToData(_signingKeyObject->signingKeyBytes);
}

- (NSData *)signatureVerificationKeyBytes {
  return sodiumBufferToData(_signingKeyObject->getSignatureVerificationKey()
                                .signatureVerificationKeyBytes);
}

- (void)dealloc {
  delete _signingKeyObject;
}

@end
