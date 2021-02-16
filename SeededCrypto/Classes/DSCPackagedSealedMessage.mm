#import "DSCPackagedSealedMessage.h"
#import "DSCHelper.h"
#include "packaged-sealed-message.hpp"
#include <vector>

@implementation DSCPackagedSealedMessage {
  PackagedSealedMessage *_packagedSealedMessageObject;
}

- (instancetype)initWithPackagedSealedMessage:
    (PackagedSealedMessage *)packagedSealedMessage {
  self = [self init];
  if (self != NULL) {
    _packagedSealedMessageObject = packagedSealedMessage;
  }
  return self;
}

- (instancetype)initWithCipherText:(NSData *)cyphertext
             recipe:(NSString *)recipe
             unsealingInstructions:(NSString *)unsealingInstructions {

  const std::vector<unsigned char> cipher =
      dataToUnsignedCharVector(cyphertext);

  PackagedSealedMessage packagedSealedMessage =
      PackagedSealedMessage(cipher, [recipe UTF8String],
                            [unsealingInstructions UTF8String]);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(
                                        packagedSealedMessage)];
}

+ (instancetype)fromJsonWithPackagedSealedMessageAsJson:
                    (NSString *)packagedSealedMessageAsJson
                                                  error:(NSError **)error {
  try {
    PackagedSealedMessage obj = PackagedSealedMessage::fromJson(
        [packagedSealedMessageAsJson UTF8String]);
    return [[DSCPackagedSealedMessage alloc]
        initWithPackagedSealedMessage:new PackagedSealedMessage(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  PackagedSealedMessage obj =
      PackagedSealedMessage::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCPackagedSealedMessage alloc]
      initWithPackagedSealedMessage:new PackagedSealedMessage(obj)];
}

- (NSString *)toJson {
  return [NSString
      stringWithUTF8String:_packagedSealedMessageObject->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer =
      _packagedSealedMessageObject->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (NSData *)ciphertext {
  return unsignedCharVectorToData(_packagedSealedMessageObject->ciphertext);
}

- (NSString *)recipe {
  return [NSString stringWithUTF8String:_packagedSealedMessageObject
                                            ->recipe.c_str()];
}

- (NSString *)unsealingInstructions {
  return [NSString stringWithUTF8String:_packagedSealedMessageObject
                                            ->unsealingInstructions.c_str()];
}

- (PackagedSealedMessage *)wrappedObject {
  return _packagedSealedMessageObject;
}

- (void)dealloc {
  delete _packagedSealedMessageObject;
}

@end
