#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Secret)
@interface DSCSecret : NSObject

+ (instancetype)fromJsonWithSeedAsString:(NSString*)seedAsString;

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm;

+ (instancetype)deriveFromSeedWithSeedString:(NSString*)seedString derivationOptionsJson:(NSString*)derivationOptionsJson;

- (NSString*)toJson;

- (NSData*)toSerializedBinaryForm;

- (NSData*)secretBytes;

@property(readonly) NSString* derivationOptionsJson;

@end

NS_ASSUME_NONNULL_END
