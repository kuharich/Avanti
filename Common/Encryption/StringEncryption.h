//
//  StringEncryption.h
//
//  Created by DAVID VEKSLER on 2/4/09.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define kChosenCipherBlockSize  kCCBlockSizeAES128
#define kChosenCipherKeySize    kCCKeySizeAES128
#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH

@interface StringEncryption : NSObject

+ (BOOL)isStringMatch:(NSString *)stringToMatch decryptedString:(NSString *)stringToDecrypt key:(NSString *)aSymmetricKey;

+ (NSString *)encryptString:(NSString *)plainStringToEncrypt key:(NSString *)aSymmetricKey;
+ (NSString *)decryptString:(NSString *)stringToDecrypt key:(NSString *)aSymmetricKey;

@end
