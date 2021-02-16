#import "DSCSymmetricKey.h"
#import "DSCHelper.h"
#include "symmetric-key.hpp"
#include <string>

@interface DSCSymmetricKey ()
- (instancetype)initWithSymmetricKey:(SymmetricKey *)symmetricKey;
@end

@implementation DSCSymmetricKey {
  SymmetricKey *_symmetricKeyObject;
}

- (instancetype)initWithSymmetricKey:(SymmetricKey *)symmetricKey {
  self = [self init];
  if (self != NULL) {
    _symmetricKeyObject = symmetricKey;
  }
  return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error {
  try {
    SymmetricKey obj = SymmetricKey::deriveFromSeed(
        [seedString UTF8String], [recipe UTF8String]);
    return [[DSCSymmetricKey alloc] initWithSymmetricKey:new SymmetricKey(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromJsonWithSymmetricKeyAsJson:(NSString *)symmetricKeyAsJson
                                         error:(NSError **)error {
  try {
    SymmetricKey symmetricKey =
        SymmetricKey::fromJson([symmetricKeyAsJson UTF8String]);
    return [[DSCSymmetricKey alloc]
        initWithSymmetricKey:new SymmetricKey(symmetricKey)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  SymmetricKey obj = SymmetricKey::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCSymmetricKey alloc] initWithSymmetricKey:new SymmetricKey(obj)];
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_symmetricKeyObject->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer = _symmetricKeyObject->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (NSData *)keyBytes {
  return sodiumBufferToData(_symmetricKeyObject->keyBytes);
}

- (NSString *)recipe {
  return [NSString
      stringWithUTF8String:_symmetricKeyObject->recipe.c_str()];
}

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:(NSString *)unsealingInstrucations
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage = _symmetricKeyObject->seal(
        [message UTF8String], [unsealingInstrucations UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        _symmetricKeyObject->seal([message UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstructions:(NSString *)unsealingInstrucations
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage = _symmetricKeyObject->seal(
        dataToSodiumBuffer(data), [unsealingInstrucations UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        _symmetricKeyObject->seal(dataToSodiumBuffer(data));
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                      unsealingInstructions:(NSString *)unsealingInstructions
                                      error:(NSError **)error {
  try {
    return unsignedCharVectorToData(_symmetricKeyObject->sealToCiphertextOnly(
        stringToUnsignedCharArray(message), message.length,
        [unsealingInstructions UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithMessage:(NSString *)message
                                      error:(NSError **)error {
  try {
    return unsignedCharVectorToData(_symmetricKeyObject->sealToCiphertextOnly(
        stringToUnsignedCharArray(message), message.length));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                   unsealingInstructions:(NSString *)unsealingInstructions
                                   error:(NSError **)error {
  try {
    return unsignedCharVectorToData(_symmetricKeyObject->sealToCiphertextOnly(
        dataToSodiumBuffer(data), [unsealingInstructions UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)sealToCiphertextOnlyWithData:(NSData *)data
                                   error:(NSError **)error {
  try {
    return unsignedCharVectorToData(
        _symmetricKeyObject->sealToCiphertextOnly(dataToSodiumBuffer(data)));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealCiphertext:(NSData *)ciphertext error:(NSError **)error {
  try {
    return sodiumBufferToData(
        _symmetricKeyObject->unseal(dataToUnsignedCharVector(ciphertext)));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealCiphertext:(NSData *)ciphertext
       unsealingInstructions:(NSString *)unsealingInstructions
                       error:(NSError **)error {
  try {
    return sodiumBufferToData(
        _symmetricKeyObject->unseal(dataToUnsignedCharVector(ciphertext),
                                    [unsealingInstructions UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                      error:(NSError **)error {
  try {
    return sodiumBufferToData(
        _symmetricKeyObject->unseal(*packagedSealedMessage.wrappedObject));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                          error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        PackagedSealedMessage::fromJson([packagedSealedMessageJson UTF8String]);
    return sodiumBufferToData(
        _symmetricKeyObject->unseal(packagedSealedMessage));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                            error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        PackagedSealedMessage::fromSerializedBinaryForm(
            dataToSodiumBuffer(binaryPackagedSealedMessage));
    return sodiumBufferToData(
        _symmetricKeyObject->unseal(packagedSealedMessage));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              recipe:recipeJson
                                              error:error];
  return [symmetricKey sealWithMessage:message error:error];
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstructions:(NSString *)unsealingInstructions
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              recipe:recipeJson
                                              error:error];
  return [symmetricKey sealWithMessage:message
                 unsealingInstructions:unsealingInstructions
                                 error:error];
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              recipe:recipeJson
                                              error:error];
  return [symmetricKey sealWithData:data error:error];
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstructions:(NSString *)unsealingInstructions
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              recipe:recipeJson
                                              error:error];
  return [symmetricKey sealWithData:data
              unsealingInstructions:unsealingInstructions
                              error:error];
}

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString
                                      error:(NSError **)error {
  try {
    return sodiumBufferToData(SymmetricKey::unseal(
        *packagedSealedMessage.wrappedObject, [seedString UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                     seedString:(NSString *)seedString
                                          error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:packagedSealedMessageJson
                                        error:error];
  return [DSCSymmetricKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString
                                                    error:error];
}

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString
                                            error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:binaryPackagedSealedMessage];
  return [DSCSymmetricKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString
                                                    error:error];
}

- (void)dealloc {
  delete _symmetricKeyObject;
}

@end
