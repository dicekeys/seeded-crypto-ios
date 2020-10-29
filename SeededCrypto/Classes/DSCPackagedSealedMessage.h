#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PackagedSealedMessage;

NS_SWIFT_NAME(PackagedSealedMessage)
@interface DSCPackagedSealedMessage : NSObject

- (instancetype)initWithPackagedSealedMessage:
    (struct PackagedSealedMessage *)packagedSealedMessage;

- (instancetype)initWithCipherText:(NSData *)cyphertext
             derivationOptionsJson:(NSString *)derivationOptionsJson
             unsealingInstructions:(NSString *)unsealingInstructions;

+ (instancetype)fromJsonWithPackagedSealedMessageAsJson:
    (NSString *)packagedSealedMessageAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSData *ciphertext;

@property(readonly) NSString *derivationOptionsJson;

@property(readonly) NSString *unsealingInstructions;

@property(readonly) struct PackagedSealedMessage *wrappedObject;

@end

NS_ASSUME_NONNULL_END
