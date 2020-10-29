#import "DSCSymmetricKey.h"
#import "DSCHelper.h"
#include "symmetric-key.hpp"
#include <string>

@interface DSCSymmetricKey ()
- (instancetype)initWithSymmetricKey:(SymmetricKey*)symmetricKey;
@end

@implementation DSCSymmetricKey {
    SymmetricKey* _symmetricKeyObject;
}

- (instancetype)initWithSymmetricKey:(SymmetricKey *)symmetricKey {
    self = [[DSCSymmetricKey alloc] init];
    if (self != NULL) {
        _symmetricKeyObject = symmetricKey;
    }
    return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString*)seedString derivationOptionsJson:(NSString*)derivationOptionsJson {
    SymmetricKey obj = SymmetricKey::deriveFromSeed([seedString UTF8String], [derivationOptionsJson UTF8String]);
    return [[DSCSymmetricKey alloc] initWithSymmetricKey: new SymmetricKey(obj)];
}

+ (instancetype)fromJsonWithSymmetricKeyAsJson:(NSString*) symmetricKeyAsJson {
    SymmetricKey symmetricKey = SymmetricKey::fromJson([symmetricKeyAsJson UTF8String]);
    return [[DSCSymmetricKey alloc] initWithSymmetricKey: new SymmetricKey(symmetricKey)];
}

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm {
    SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
    SymmetricKey obj = SymmetricKey::fromSerializedBinaryForm(sodiumBuffer);
    return [[DSCSymmetricKey alloc] initWithSymmetricKey: new SymmetricKey(obj)];
}

- (NSString*)toJson {
    return [NSString stringWithUTF8String: _symmetricKeyObject->toJson().c_str()];
}

- (NSData*)toSerializedBinaryForm {
    SodiumBuffer sodiumBuffer = _symmetricKeyObject->toSerializedBinaryForm();
    return sodiumBufferToData(sodiumBuffer);
}

- (NSData*)keyBytes {
    return sodiumBufferToData(_symmetricKeyObject->keyBytes);
}

- (NSString*)derivationOptionsJson {
    return [NSString stringWithUTF8String:_symmetricKeyObject->derivationOptionsJson.c_str()];
}

- (DSCPackagedSealedMessage*)sealWithMessage:(NSString*)message unsealingInstructions:(NSString*)unsealingInstrucations {
    PackagedSealedMessage packagedSealedMessage = _symmetricKeyObject->seal([message UTF8String], [unsealingInstrucations UTF8String]);
    return [[DSCPackagedSealedMessage alloc] initWithPackagedSealedMessage: new PackagedSealedMessage(packagedSealedMessage)];
}

- (DSCPackagedSealedMessage*)sealWithMessage:(NSString*)message {
    PackagedSealedMessage packagedSealedMessage = _symmetricKeyObject->seal([message UTF8String]);
    return [[DSCPackagedSealedMessage alloc] initWithPackagedSealedMessage: new PackagedSealedMessage(packagedSealedMessage)];
}

- (NSData*)sealToCiphertextOnlyWithMessage:(NSString*)message unsealingInstructions:(NSString*)unsealingInstructions {
    return unsignedCharVectorToData( _symmetricKeyObject->sealToCiphertextOnly(stringToUnsignedCharArray(message), message.length, [unsealingInstructions UTF8String]));
}

- (NSData*)sealToCiphertextOnlyWithMessage:(NSString*)message {
    return unsignedCharVectorToData( _symmetricKeyObject->sealToCiphertextOnly(stringToUnsignedCharArray(message), message.length));
}

- (NSData*)unsealCiphertext:(NSData*)ciphertext {
    return sodiumBufferToData(_symmetricKeyObject->unseal(dataToUnsignedCharVector(ciphertext)));
}

- (NSData*)unsealCiphertext:(NSData*)ciphertext unsealingInstructions:(NSString *)unsealingInstructions {
    return sodiumBufferToData(_symmetricKeyObject->unseal(dataToUnsignedCharVector(ciphertext), [unsealingInstructions UTF8String]));
}

- (NSData*)unsealWithPackagedSealedMessage:(DSCPackagedSealedMessage*)packagedSealedMessage {
    return sodiumBufferToData(_symmetricKeyObject->unseal(*packagedSealedMessage.wrappedObject));
}

- (NSData*)unsealJsonPackagedSealedMessage:(NSString*)packagedSealedMessageJson {
    PackagedSealedMessage packagedSealedMessage = PackagedSealedMessage::fromJson([packagedSealedMessageJson UTF8String]);
    return sodiumBufferToData(_symmetricKeyObject->unseal(packagedSealedMessage));
}

- (NSData*)unsealBinaryPackagedSealedMessage:(NSData*)binaryPackagedSealedMessage {
    PackagedSealedMessage packagedSealedMessage = PackagedSealedMessage::fromSerializedBinaryForm(dataToSodiumBuffer(binaryPackagedSealedMessage));
    return sodiumBufferToData(_symmetricKeyObject->unseal(packagedSealedMessage));
}

+ (DSCPackagedSealedMessage*)sealWithMessage:(NSString*)message seedString:(NSString*)seedString derivationOptions:(NSString*)derivationOptions {
    DSCSymmetricKey* symmetricKey = [DSCSymmetricKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptions];
    return [symmetricKey sealWithMessage:message];

}

+ (DSCPackagedSealedMessage*)sealWithMessage:(NSString*)message unsealingInstructions:(NSString*)unsealingInstructions seedString:(NSString*)seedString derivationOptions:(NSString*)derivationOptions {
    DSCSymmetricKey* symmetricKey = [DSCSymmetricKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptions];
    return [symmetricKey sealWithMessage:message unsealingInstructions:unsealingInstructions];
}

+ (NSData*)unsealWithPackagedSealedMessage:(DSCPackagedSealedMessage*)packagedSealedMessage seedString:(NSString*)seedString {
    return sodiumBufferToData(SymmetricKey::unseal(*packagedSealedMessage.wrappedObject, [seedString UTF8String]));
}

+ (NSData*)unsealWithJsonPackagedSealedMessage:(NSString*)packagedSealedMessageJson seedString:(NSString*)seedString {
    DSCPackagedSealedMessage* packagedSealedMessage = [DSCPackagedSealedMessage fromJsonWithPackagedSealedMessageAsJson:packagedSealedMessageJson];
    return [DSCSymmetricKey unsealWithPackagedSealedMessage:packagedSealedMessage seedString:seedString];
}

+ (NSData*)unsealWithBinaryPackagedSealedMessage:(NSData*)binaryPackagedSealedMessage seedString:(NSString*)seedString {
    DSCPackagedSealedMessage* packagedSealedMessage = [DSCPackagedSealedMessage fromSerializedBinaryFrom:binaryPackagedSealedMessage];
    return [DSCSymmetricKey unsealWithPackagedSealedMessage:packagedSealedMessage seedString:seedString];
}

- (void)dealloc {
    delete _symmetricKeyObject;
}

@end
