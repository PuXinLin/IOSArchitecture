//
//  JYMD5.m
//  JYProject
//
//  Created by dayou on 2017/8/4.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation JYMD5

#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Private Methods ----------
+ (NSString *)md5WithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [md5String appendFormat:@"%02x", digest[i]];
    return  md5String;
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
