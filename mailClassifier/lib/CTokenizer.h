//
//  CTokenizer.h
//  MobiDE
//
//  Created by haeyong Shin on 10/2/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTokenizer : NSObject
{
    
}
+(NSArray*) tokenizer:(NSString*) input;
+(BOOL) validateAlphaDigitOnly:(NSString*) token;
+(BOOL) validateAlphaOnly:(NSString*) token;
+(BOOL) validateApostrophe:(NSString*) token;
+(NSString*) validateAcronym:(NSString*) token;
+(BOOL) validateCompany:(NSString*) token;
+(BOOL) validateEmail:(NSString*) token;
+(BOOL) validateHost:(NSString*) token;
+(BOOL) validateSerial:(NSString*) token;
@end
