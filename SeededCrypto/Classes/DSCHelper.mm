#import "DSCHelper.h"
#include "exceptions.hpp"
#include "sodium-buffer.hpp"

NSData *sodiumBufferToData(SodiumBuffer sodiumBuffer) {
  return [NSData dataWithBytes:(const void *)sodiumBuffer.data
                        length:(sizeof(unsigned char) * sodiumBuffer.length)];
}

SodiumBuffer dataToSodiumBuffer(NSData *data) {
  NSUInteger size = [data length] / sizeof(unsigned char);
  unsigned char *array = (unsigned char *)[data bytes];
  return SodiumBuffer(size, array);
}

std::vector<unsigned char> dataToUnsignedCharVector(NSData *data) {
  NSUInteger size = [data length] / sizeof(unsigned char);
  unsigned char *array = (unsigned char *)[data bytes];
  return std::vector<unsigned char>(array, array + size);
}

NSData *unsignedCharVectorToData(std::vector<unsigned char> v) {
  NSUInteger size = v.size() * sizeof(unsigned char);
  return [[NSData alloc] initWithBytes:v.data() length:size];
}

const unsigned char *stringToUnsignedCharArray(NSString *str) {
  return (const unsigned char *)[str UTF8String];
}

const unsigned char *dataToUnsignedCharArray(NSData *data) {
  return (const unsigned char *)[data bytes];
}

std::vector<unsigned char> stringToUnsignedCharVector(NSString *str) {
  NSUInteger size = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
  unsigned char *array = (unsigned char *)[str UTF8String];
  return std::vector<unsigned char>(array, array + size);
}

NSError *cppExceptionToError(const std::exception &e) {
  NSDictionary *info =
      @{NSLocalizedDescriptionKey : [NSString stringWithUTF8String:e.what()]};
  return [NSError errorWithDomain:@"SeededCrypto" code:0 userInfo:info];
}
