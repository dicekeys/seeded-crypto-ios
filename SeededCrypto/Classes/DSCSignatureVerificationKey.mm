#import "DSCSignatureVerificationKey.h"
#import "DSCHelper.h"
#include "signature-verification-key.hpp"
#include "signing-key.hpp"

@implementation DSCSignatureVerificationKey {
  SignatureVerificationKey *_signatureVerificationKeyObject;
}

- (instancetype)initWithSignatureVerificationKeyObject:
    (SignatureVerificationKey *)signatureVerificationKey {
  self = [self init];
  if (self != NULL) {
    _signatureVerificationKeyObject = signatureVerificationKey;
  }
  return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson
                                       error:(NSError **)error {
  try {
    SignatureVerificationKey key =
        SigningKey::deriveFromSeed([seedString UTF8String],
                                   [derivationOptionsJson UTF8String])
            .getSignatureVerificationKey();
    return [[DSCSignatureVerificationKey alloc] init];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromJsonWithSignatureVerificationKeyAsJson:
                    (NSString *)signatureVerificationKeyAsJson
                                                     error:(NSError **)error {
  try {
    SignatureVerificationKey key = SignatureVerificationKey::fromJson(
        [signatureVerificationKeyAsJson UTF8String]);
    return [[DSCSignatureVerificationKey alloc]
        initWithSignatureVerificationKeyObject:new SignatureVerificationKey(
                                                   key)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  SignatureVerificationKey key =
      SignatureVerificationKey::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCSignatureVerificationKey alloc]
      initWithSignatureVerificationKeyObject:new SignatureVerificationKey(key)];
}

- (NSString *)toJson {
  return [NSString
      stringWithUTF8String:_signatureVerificationKeyObject->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer =
      _signatureVerificationKeyObject->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (NSString *)derivationOptionsJson {
  return [NSString stringWithUTF8String:_signatureVerificationKeyObject
                                            ->derivationOptionsJson.c_str()];
}

- (NSData *)signatureVerificationKeyBytes {
  return unsignedCharVectorToData(
      _signatureVerificationKeyObject->signatureVerificationKeyBytes);
}

- (BOOL)verifyWithMessage:(NSString *)message
                signature:(NSData *)signature
                    error:(NSError **)error {
  try {
    return _signatureVerificationKeyObject->verify(
        stringToUnsignedCharArray(message), message.length,
        dataToUnsignedCharVector(signature));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return FALSE;
  }
}

- (BOOL)verifyWithData:(NSData *)data
             signature:(NSData *)signature
                 error:(NSError **)error {
  try {
    return _signatureVerificationKeyObject->verify(
        dataToSodiumBuffer(data), dataToUnsignedCharVector(signature));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return FALSE;
  }
}

- (void)dealloc {
  delete _signatureVerificationKeyObject;
}
@end
