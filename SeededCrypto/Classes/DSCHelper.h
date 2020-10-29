#include <Foundation/Foundation.h>

struct SodiumBuffer;

NSData *sodiumBufferToData(struct SodiumBuffer sodiumBuffer);
struct SodiumBuffer dataToSodiumBuffer(NSData *data);

#ifdef __cplusplus
#include <vector>
std::vector<unsigned char> dataToUnsignedCharVector(NSData *data);
NSData *unsignedCharVectorToData(std::vector<unsigned char> v);
const unsigned char *stringToUnsignedCharArray(NSString *str);
#endif
