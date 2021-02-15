#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Password)
@interface DSCPassword : NSObject

+ (instancetype)
    deriveFromSeedAndWordListWithSeedString:(NSString *)seedString
                      recipe:(NSString *)recipe
                     wordListAsSingleString:(NSString *)wordListAsSingleString
                                      error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

+ (instancetype)fromJsonWithSeedAsJson:(NSString *)seedAsJson
                                 error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

//- (instancetype)init NS_UNAVAILABLE;

- (NSString *)toJson;
- (NSString *)toJsonWithIndent:(int)indent;
- (NSString *)toJsonWithIndent:(int)indent indentChar:(char)indentChar;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSString *password;
@property(readonly) NSString *recipe;

@end

NS_ASSUME_NONNULL_END
