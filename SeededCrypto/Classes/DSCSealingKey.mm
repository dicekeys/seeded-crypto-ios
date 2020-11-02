#import "DSCSealingKey.h"
#import "DSCHelper.h"
#include "packaged-sealed-message.hpp"
#include "sealing-key.hpp"

@implementation DSCSealingKey {
  SealingKey *_sealingKey;
}

- (instancetype)initWithSealingKeyObject:(SealingKey *)sealingKey {
  self = [self init];
  if (self != NULL) {
    _sealingKey = sealingKey;
  }
  return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson {
  return NULL;
}

+ (instancetype)fromJsonWithSealingKeyAsJson:(NSString *)sealingKeyAsJson {
  SealingKey obj = SealingKey::fromJson([sealingKeyAsJson UTF8String]);
  return [[DSCSealingKey alloc] initWithSealingKeyObject:new SealingKey(obj)];
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  SealingKey obj = SealingKey::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCSealingKey alloc] initWithSealingKeyObject:new SealingKey(obj)];
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_sealingKey->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer = _sealingKey->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message {
  PackagedSealedMessage packagedSealedMessage =
      _sealingKey->seal([message UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                          sealingInstructions:(NSString *)sealingInstructions {
  PackagedSealedMessage packagedSealedMessage =
      _sealingKey->seal(stringToUnsignedCharArray(message), message.length,
                        [sealingInstructions UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message {
  return sodiumBufferToData(_sealingKey->sealToCiphertextOnly(
      stringToUnsignedCharArray(message), message.length));
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                        sealingInstructions:(NSString *)sealingInstructions {
  return sodiumBufferToData(_sealingKey->sealToCiphertextOnly(
      stringToUnsignedCharArray(message), message.length,
      [sealingInstructions UTF8String]));
}

- (NSString *)derivationOptionsJson {
  return [NSString
      stringWithUTF8String:_sealingKey->derivationOptionsJson.c_str()];
}

@end
