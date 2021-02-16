#import "DSCUnsealingKey.h"
#import "DSCHelper.h"
#include "exceptions.hpp"
#include "unsealing-key.hpp"

@implementation DSCUnsealingKey {
  UnsealingKey *_unsealingKey;
}

- (instancetype)initWithUnsealingKeyObject:(UnsealingKey *)unsealingKey {
  self = [self init];
  if (self != NULL) {
    _unsealingKey = unsealingKey;
  }
  return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error {
  try {
    UnsealingKey obj = UnsealingKey::deriveFromSeed(
        [seedString UTF8String], [recipe UTF8String]);
    return [[DSCUnsealingKey alloc]
        initWithUnsealingKeyObject:new UnsealingKey(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromJsonWithUnsealingKeyAsJson:(NSString *)unsealingKeyAsJson
                                         error:(NSError **)error {
  try {
    UnsealingKey unsealingKey =
        UnsealingKey::fromJson([unsealingKeyAsJson UTF8String]);
    return [[DSCUnsealingKey alloc]
        initWithUnsealingKeyObject:new UnsealingKey(unsealingKey)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  UnsealingKey obj = UnsealingKey::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCUnsealingKey alloc]
      initWithUnsealingKeyObject:new UnsealingKey(obj)];
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_unsealingKey->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer = _unsealingKey->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

+ (NSData *)unsealWithPackagedSealedMessage:
                (DSCPackagedSealedMessage *)packagedSealedMessage
                                 seedString:(NSString *)seedString
                                      error:(NSError **)error {
  try {
    return sodiumBufferToData(UnsealingKey::unseal(
        *packagedSealedMessage.wrappedObject, [seedString UTF8String]));
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)jsonPackagedSealedMessage
                                     seedString:(NSString *)seedString
                                          error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:jsonPackagedSealedMessage
                                        error:error];
  return [DSCUnsealingKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString
                                                    error:error];
}

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString
                                            error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:binaryPackagedSealedMessage];
  return [DSCUnsealingKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString
                                                    error:error];
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        UnsealingKey::deriveFromSeed([seedString UTF8String],
                                     [recipeJson UTF8String])
            .getSealingKey()
            .seal([message UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstrucation:(NSString *)unsealingInstrucations
                                   seedString:(NSString *)seedString
                            recipeJson:(NSString *)recipeJson
                                        error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        UnsealingKey::deriveFromSeed([seedString UTF8String],
                                     [recipeJson UTF8String])
            .getSealingKey()
            .seal(stringToUnsignedCharArray(message), message.length,
                  [unsealingInstrucations UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        UnsealingKey::deriveFromSeed([seedString UTF8String],
                                     [recipeJson UTF8String])
            .getSealingKey()
            .seal(dataToUnsignedCharVector(data));
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstrucation:(NSString *)unsealingInstrucations
                                seedString:(NSString *)seedString
                         recipeJson:(NSString *)recipeJson
                                     error:(NSError **)error {
  try {
    PackagedSealedMessage packagedSealedMessage =
        UnsealingKey::deriveFromSeed([seedString UTF8String],
                                     [recipeJson UTF8String])
            .getSealingKey()
            .seal(dataToSodiumBuffer(data),
                  [unsealingInstrucations UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(
                                          packagedSealedMessage)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (DSCSealingKey *)sealingKey {
  SealingKey sealingKey = _unsealingKey->getSealingKey();
  return [[DSCSealingKey alloc]
      initWithSealingKeyObject:new SealingKey(sealingKey)];
}

- (NSData *)unsealWithCiphertext:(NSData *)ciphertext
           unsealingInstructions:(NSString *)unsealingInstructions
                           error:(NSError **)error
    __attribute__((swift_error(nonnull_error))) {
  try {
    return sodiumBufferToData(_unsealingKey->unseal(
        dataToUnsignedCharArray(ciphertext), ciphertext.length,
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
        _unsealingKey->unseal(*packagedSealedMessage.wrappedObject));
  } catch (const CryptographicVerificationFailureException &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)packagedSealedMessageJson
                                          error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:packagedSealedMessageJson
                                        error:error];
  return [self unsealWithPackagedSealedMessage:packagedSealedMessage
                                         error:error];
}

- (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                            error:(NSError **)error {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:binaryPackagedSealedMessage];
  return [self unsealWithPackagedSealedMessage:packagedSealedMessage
                                         error:error];
}

- (NSData *)sealingKeyBytes {
  return sodiumBufferToData(_unsealingKey->sealingKeyBytes);
}

- (NSData *)unsealingKeyBytes {
  return sodiumBufferToData(_unsealingKey->unsealingKeyBytes);
}

- (NSString *)derivationOptionsJson {
  return [NSString
      stringWithUTF8String:_unsealingKey->derivationOptionsJson.c_str()];
}

@end
