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
                       derivationOptionsJson:(NSString *)derivationOptionsJson {
  SignatureVerificationKey key =
      SigningKey::deriveFromSeed([seedString UTF8String],
                                 [derivationOptionsJson UTF8String])
          .getSignatureVerificationKey();
  return [[DSCSignatureVerificationKey alloc] init];
}

+ (instancetype)fromJsonWithSignatureVerificationKeyAsJson:
    (NSString *)signatureVerificationKeyAsJson {
  SignatureVerificationKey key = SignatureVerificationKey::fromJson(
      [signatureVerificationKeyAsJson UTF8String]);
  return [[DSCSignatureVerificationKey alloc]
      initWithSignatureVerificationKeyObject:new SignatureVerificationKey(key)];
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

- (BOOL)verifyWithMessage:(NSString *)message signature:(NSData *)signature {
  return _signatureVerificationKeyObject->verify(
      stringToUnsignedCharArray(message), message.length,
      dataToUnsignedCharVector(signature));
}

- (BOOL)verifyWithData:(NSData *)data signature:(NSData *)signature {
  return _signatureVerificationKeyObject->verify(
      dataToSodiumBuffer(data), dataToUnsignedCharVector(signature));
}

- (void)dealloc {
  delete _signatureVerificationKeyObject;
}
@end
