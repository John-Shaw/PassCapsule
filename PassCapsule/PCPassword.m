//
//  PCPassword.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCPassword.h"
#import "PCKeyChainCapsule.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@implementation PCPassword

//为了方便，先存用户输入的明文，因为反正程序结束也会删除KeyChain，当然为了更安全还是hash一下好，我只是偷个懒
+ (void)setPassword:(NSString *)password{
    [PCKeyChainCapsule setString:password forKey:KEYCHAIN_KEY andServiceName:KEYCHAIN_KEY_SERVICE];
}

+ (NSString *)password{
    return [PCKeyChainCapsule stringForKey:KEYCHAIN_KEY andServiceName:KEYCHAIN_KEY_SERVICE];
}

+ (NSData *)encryptedData:(NSString *)plain{
    NSString *key = [self password];
    return [self encryptedData:plain WithKey:key];
}

+ (NSData *)encryptedData:(NSString *)plain WithKey:(NSString *)key{
    NSData *data = [plain dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:key
                                               error:&error];
    return encryptedData;
}

+ (NSString *)encryptedString:(NSString *)plain{
    NSString *key = [self password];
    return [self encryptedString:plain WithKey:key];
}

+ (NSString *)encryptedString:(NSString *)plain WithKey:(NSString *)key{
    NSData *encryptedData = [self encryptedData:plain WithKey:key];
    NSString *encryptedPassword = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptedPassword;
}

+ (NSString *)decryptedString:(NSString *)encryptedString{
    NSString *key = [self password];
    return [self decryptedString:encryptedString WithKey:key];
}

+ (NSString *)decryptedString:(NSString *)encryptedString  WithKey:(NSString *)key{
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [RNDecryptor decryptData:encryptedData
                                      withPassword:key
                                             error:nil];
    NSString *decryptString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
}

//!!!:暂时废弃保存一个随机生成的master key，因为有key chain被破解（越狱就可以）的风险，改用用户输入密码的固定hash（不能加盐，否则不一样不能解密，囧，我太笨了），
//每次退出都会删除key chain里的master key 数据，除非cracker在运行期破解了keychain获得解密的密匙，然而这好像几乎不可能。
//如果真能，只有考虑内存混淆加密了。
//+ (NSString *)masterKey{
//    NSString *base64key = [PCKeyChainCapsule stringForKey:KEYCHAIN_KEY andServiceName:KEYCHAIN_KEY_SERVICE];
//    NSData *datakey = [[NSData alloc] initWithBase64EncodedString:base64key options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSString *key = [[NSString alloc] initWithData:datakey encoding:NSUTF8StringEncoding];
//    NSLog(@"get key from keychain =  %@",base64key);
//    NSLog(@"origin key =  %@",key);
//    return base64key;
//}

#pragma mark - from miniKeePass

static NSUInteger const kDefaultSaltSize = 64;
static NSUInteger const kDefaultKeySize = 64;
static NSUInteger const kDefaultRounds = 10000;

+ (NSData *)generateSaltOfSize:(NSInteger)size {
    NSMutableData *data = [NSMutableData dataWithLength:size];
    SecRandomCopyBytes(kSecRandomDefault, size, data.mutableBytes);
    return data;
}

+ (NSString *)hashPassword:(NSString *)password withSalt:(NSData *)salt andRounds:(NSUInteger)rounds andKeySize:(NSInteger)keySize {
    NSMutableData *derivedKey = [NSMutableData dataWithLength:keySize];
    
    // Get the data by converting the string to ISO 8859-1 characters
    NSData *passwordData = [password dataUsingEncoding:NSISOLatin1StringEncoding];
    
    CCKeyDerivationPBKDF(kCCPBKDF2, passwordData.bytes, passwordData.length, salt.bytes, salt.length, kCCPRFHmacAlgSHA512, (unsigned int)rounds, derivedKey.mutableBytes, derivedKey.length);
    
    return [NSString stringWithFormat:@"sha512.%u.%@.%@", (unsigned int)rounds, [PCPassword hexStringFromData:salt], [PCPassword hexStringFromData:derivedKey]];
}

+ (NSString *)hashPassword:(NSString *)password {
    NSData *salt = [PCPassword generateSaltOfSize:kDefaultSaltSize];
    return [PCPassword hashPassword:password withSalt:salt andRounds:kDefaultRounds andKeySize:kDefaultKeySize];
}

+ (BOOL)validatePassword:(NSString *)password againstHash:(NSString *)hash {
    NSArray *tokens = [hash componentsSeparatedByString:@"."];
    
    NSString *algorithm = [tokens objectAtIndex:0];
    if (![algorithm isEqualToString:@"sha512"]) {
        NSLog(@"Invalid hash algorithm: %@", algorithm);
        return false;
    }
    
    NSString *roundsStr = [tokens objectAtIndex:1];
    NSInteger rounds = [roundsStr integerValue];
    
    NSString *saltHex = [tokens objectAtIndex:2];
    NSData *salt = [PCPassword dataFromHexString:saltHex];
    
    NSString *str = [PCPassword hashPassword:password withSalt:salt andRounds:rounds andKeySize:kDefaultKeySize];
    
    return [str isEqualToString:hash];
}

+ (NSData *)dataFromHexString:(NSString *)string {
    NSData *strData = [string dataUsingEncoding:NSISOLatin1StringEncoding];
    const uint8_t *strBytes = strData.bytes;
    NSUInteger n = strData.length;
    
    NSMutableData *data = [NSMutableData dataWithLength:n / 2];
    uint8_t *dataBytes = data.mutableBytes;
    
    for (int i = 0, j = 0; i < n; i += 2, j++) {
        char hex[3] = {strBytes[i], strBytes[i + 1], '\0'};
        dataBytes[j] = strtol(hex, NULL, 16);
    }
    
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)data {
    const uint8_t *bytes = data.bytes;
    NSUInteger n = data.length;
    
    NSMutableString *string = [NSMutableString stringWithCapacity:n * 2];
    
    for (int i = 0; i < n; i++) {
        [string appendFormat:@"%02X", bytes[i]];
    }
    
    return string;
}

@end
