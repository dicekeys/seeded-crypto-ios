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
                       recipe:(NSString *)recipe
                                       error:(NSError **)error {
  // TODO: implement
  return NULL;
}

+ (instancetype)fromJsonWithSealingKeyAsJson:(NSString *)sealingKeyAsJson
                                       error:(NSError **)error {
  try {
    SealingKey obj = SealingKey::fromJson([sealingKeyAsJson UTF8String]);
    return [[DSCSealingKey alloc] initWithSealingKeyObject:new SealingKey(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
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

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        _sealingKey->seal([message UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                          sealingInstructions:(NSString *)sealingInstructions
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        _sealingKey->seal(stringToUnsignedCharArray(message), message.length,
                          [sealingInstructions UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                                      error:(NSError **)error {
  try {
    return sodiumBufferToData(_sealingKey->sealToCiphertextOnly(
        stringToUnsignedCharArray(message), message.length));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                        sealingInstructions:(NSString *)sealingInstructions
                                      error:(NSError **)error {
  try {
    return sodiumBufferToData(_sealingKey->sealToCiphertextOnly(
        stringToUnsignedCharArray(message), message.length,
        [sealingInstructions UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        _sealingKey->seal(dataToUnsignedCharVector(data));
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                       sealingInstructions:(NSString *)sealingInstructions
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage = _sealingKey->seal(
        dataToSodiumBuffer(data), [sealingInstructions UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                                   error:(NSError **)error {
  try {
    return sodiumBufferToData(
        _sealingKey->sealToCiphertextOnly(dataToSodiumBuffer(data)));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                     sealingInstructions:(NSString *)sealingInstructions
                                   error:(NSError **)error {
  try {
    return sodiumBufferToData(_sealingKey->sealToCiphertextOnly(
        dataToSodiumBuffer(data),
        stringToUnsignedCharVector(sealingInstructions)));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSString *)recipe {
  return [NSString
      stringWithUTF8String:_sealingKey->recipe.c_str()];
}

- (NSData *)sealingKeyBytes {
  return sodiumBufferToData(_sealingKey->sealingKeyBytes);
}

@end
