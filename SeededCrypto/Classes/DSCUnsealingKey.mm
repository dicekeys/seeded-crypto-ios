#import "DSCUnsealingKey.h"
#import "DSCHelper.h"
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
                       derivationOptionsJson:(NSString *)derivationOptionsJson {
  UnsealingKey obj = UnsealingKey::deriveFromSeed(
      [seedString UTF8String], [derivationOptionsJson UTF8String]);
  return [[DSCUnsealingKey alloc]
      initWithUnsealingKeyObject:new UnsealingKey(obj)];
}

+ (instancetype)fromJsonWithUnsealingKeyAsJson:(NSString *)unsealingKeyAsJson {
  UnsealingKey unsealingKey =
      UnsealingKey::fromJson([unsealingKeyAsJson UTF8String]);
  return [[DSCUnsealingKey alloc]
      initWithUnsealingKeyObject:new UnsealingKey(unsealingKey)];
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
                                 seedString:(NSString *)seedString {
  return sodiumBufferToData(UnsealingKey::unseal(
      *packagedSealedMessage.wrappedObject, [seedString UTF8String]));
}

+ (NSData *)unsealWithJsonPackagedSealedMessage:
                (NSString *)jsonPackagedSealedMessage
                                     seedString:(NSString *)seedString {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:jsonPackagedSealedMessage];
  return [DSCUnsealingKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString];
}

+ (NSData *)unsealWithBinaryPackagedSealedMessage:
                (NSData *)binaryPackagedSealedMessage
                                       seedString:(NSString *)seedString {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:binaryPackagedSealedMessage];
  return [DSCUnsealingKey unsealWithPackagedSealedMessage:packagedSealedMessage
                                               seedString:seedString];
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions {
  PackagedSealedMessage packagedSealedMessage =
      UnsealingKey::deriveFromSeed([seedString UTF8String],
                                   [derivationOptions UTF8String])
          .getSealingKey()
          .seal([message UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

+ (DSCPackagedSealedMessage *)sealWithMessage:(NSString *)message
                        unsealingInstrucation:(NSString *)unsealingInstrucations
                                   seedString:(NSString *)seedString
                            derivationOptions:(NSString *)derivationOptions {
  PackagedSealedMessage packagedSealedMessage =
      UnsealingKey::deriveFromSeed([seedString UTF8String],
                                   [derivationOptions UTF8String])
          .getSealingKey()
          .seal(stringToUnsignedCharArray(message), message.length,
                [unsealingInstrucations UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                                seedString:(NSString *)seedString
                         derivationOptions:(NSString *)derivationOptions {
  PackagedSealedMessage packagedSealedMessage =
      UnsealingKey::deriveFromSeed([seedString UTF8String],
                                   [derivationOptions UTF8String])
          .getSealingKey()
          .seal(dataToUnsignedCharVector(data));
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

+ (DSCPackagedSealedMessage *)sealWithData:(NSData *)data
                     unsealingInstrucation:(NSString *)unsealingInstrucations
                                seedString:(NSString *)seedString
                         derivationOptions:(NSString *)derivationOptions {
  PackagedSealedMessage packagedSealedMessage =
      UnsealingKey::deriveFromSeed([seedString UTF8String],
                                   [derivationOptions UTF8String])
          .getSealingKey()
          .seal(dataToSodiumBuffer(data), [unsealingInstrucations UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

- (DSCSealingKey *)sealingKey {
  SealingKey sealingKey = _unsealingKey->getSealingKey();
  return [[DSCSealingKey alloc]
      initWithSealingKeyObject:new SealingKey(sealingKey)];
}

- (NSData *)unsealWithCiphertext:(NSData *)ciphertext
           unsealingInstructions:(NSString *)unsealingInstructions {
  return sodiumBufferToData(_unsealingKey->unseal(
      dataToUnsignedCharArray(ciphertext), ciphertext.length,
      [unsealingInstructions UTF8String]));
}

- (NSData *)unsealWithPackagedSealedMessage:
    (DSCPackagedSealedMessage *)packagedSealedMessage {
  return sodiumBufferToData(
      _unsealingKey->unseal(*packagedSealedMessage.wrappedObject));
}

- (NSData *)unsealWithJsonPackagedSealedMessage:
    (NSString *)packagedSealedMessageJson {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:packagedSealedMessageJson];
  return [self unsealWithPackagedSealedMessage:packagedSealedMessage];
}

- (NSData *)unsealWithBinaryPackagedSealedMessage:
    (NSData *)binaryPackagedSealedMessage {
  DSCPackagedSealedMessage *packagedSealedMessage = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:binaryPackagedSealedMessage];
  return [self unsealWithPackagedSealedMessage:packagedSealedMessage];
}

- (NSData *)sealingKeyBytes {
  return sodiumBufferToData(_unsealingKey->sealingKeyBytes);
}

- (NSData *)unsealingKeyBytes {
  return sodiumBufferToData(_unsealingKey->unsealingKeyBytes);
}

@end
