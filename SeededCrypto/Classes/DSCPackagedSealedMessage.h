#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PackagedSealedMessage;

NS_SWIFT_NAME(PackagedSealedMessage)
@interface DSCPackagedSealedMessage : NSObject

- (instancetype)initWithPackagedSealedMessage:(struct PackagedSealedMessage*)packagedSealedMessage;

- (instancetype)initWithCipherText:(NSData *)cyphertext derivationOptionsJson:(NSString*)derivationOptionsJson unsealingInstrucations:(NSString*)unsealingInstructions;

+ (instancetype)fromJsonWithPackagedSealedMessageAsJson:(NSString*)packagedSealedMessageAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm;

- (NSString*)toJson;

- (NSData*)toSerializedBinaryForm;

@property(readonly) NSData* cyphertext;

@property(readonly) NSString* derivationOptionsJson;

@property(readonly) NSString* unsealingInstructions;

@end

NS_ASSUME_NONNULL_END
