#import "DSCPackagedSealedMessage.h"
#import "DSCHelper.h"
#include "packaged-sealed-message.hpp"
#include <vector>

@implementation DSCPackagedSealedMessage {
    PackagedSealedMessage* _packagedSealedMessageObject;
}

- (instancetype)initWithPackagedSealedMessage:(PackagedSealedMessage *)packagedSealedMessage {
    self = [self init];
    if (self != NULL) {
        _packagedSealedMessageObject = packagedSealedMessage;
    }
    return self;
}

- (instancetype)initWithCipherText:(NSData *)cyphertext derivationOptionsJson:(NSString*)derivationOptionsJson unsealingInstrucations:(NSString*)unsealingInstructions {
    
    const std::vector<unsigned char> cipher = dataToUnsignedCharVector(cyphertext);
    
    PackagedSealedMessage packagedSealedMessage = PackagedSealedMessage(cipher, [derivationOptionsJson UTF8String], [unsealingInstructions UTF8String]);
    return [[DSCPackagedSealedMessage alloc] initWithPackagedSealedMessage: new PackagedSealedMessage(packagedSealedMessage)];
}

+ (instancetype)fromJsonWithPackagedSealedMessageAsJson:(NSString*)packagedSealedMessageAsJson {
    PackagedSealedMessage obj = PackagedSealedMessage::fromJson([packagedSealedMessageAsJson UTF8String]);
    return [[DSCPackagedSealedMessage alloc] initWithPackagedSealedMessage: new PackagedSealedMessage(obj)];
}

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm {
    SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
    PackagedSealedMessage obj = PackagedSealedMessage::fromSerializedBinaryForm(sodiumBuffer);
    return [[DSCPackagedSealedMessage alloc] initWithPackagedSealedMessage: new PackagedSealedMessage(obj)];
}

- (NSString*)toJson {
    return [NSString stringWithUTF8String: _packagedSealedMessageObject->toJson().c_str()];
}

- (NSData*)toSerializedBinaryForm {
    SodiumBuffer sodiumBuffer = _packagedSealedMessageObject->toSerializedBinaryForm();
    return sodiumBufferToData(sodiumBuffer);
}

- (NSData*) cyphertext {
    return unsignedCharVectorToData(_packagedSealedMessageObject->ciphertext);
}

- (NSString*) derivationOptionsJson {
    return [NSString stringWithUTF8String:_packagedSealedMessageObject->derivationOptionsJson.c_str()];
}

- (NSString*) unsealingInstructions {
    return [NSString stringWithUTF8String:_packagedSealedMessageObject->unsealingInstructions.c_str()];
}

- (void)dealloc {
    delete _packagedSealedMessageObject;
}

@end
