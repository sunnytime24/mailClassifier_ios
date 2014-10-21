//
//  CTokenizer.m
//  MobiDE
//
//  Created by haeyong Shin on 10/2/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import "CTokenizer.h"

@implementation CTokenizer
+(NSArray*) tokenizer:(NSString*) input
{
    //NSArray =[_queryText text].lowercaseString;
    NSMutableArray* tokenList = [[NSMutableArray alloc] init];
    
    NSString* tokenSep = @"*+||!(){}[]^\"~?:,. ";
    NSCharacterSet* tokenSepSet = [NSCharacterSet characterSetWithCharactersInString:tokenSep];
    tokenList = [input componentsSeparatedByCharactersInSet:tokenSepSet];
    //NSArray* tokenResult = [[NSArray alloc] init];
    //For each token,
    //analysis its type
    //pre-set
    
    //NSCharacterSet *alphaSet = [NSCharacterSet alph]
    //iteration
    NSMutableArray* discardedItems = [[NSMutableArray alloc] initWithObjects:@"a", @"an", @"and", @"are", @"as", @"at", @"be", @"but", @"by",
                                      @"for", @"if", @"in", @"into", @"is", @"it",
                                      @"no", @"not", @"of", @"on", @"or", @"s", @"such",
                                      @"t", @"that", @"the", @"their", @"then", @"there", @"these",
                                      @"they", @"this", @"to", @"was", @"will", @"with", nil];
    for(id item in tokenList)
    {
        // 1. 숫자, 알파벳, 한글로만 이루어져있는가?
        if([CTokenizer validateAlphaDigitOnly:item])
        {
            NSLog(@"-1 basic word : %@", item);
            continue;
        }
        
        // 2. Apostrophe 같은 구조로 이루어져 있는가?
        // O'Reilly, you're, O'Reilly's
        if([CTokenizer validateApostrophe:item])
        {
            NSLog(@"-2 Apostrophe : %@", item);
            continue;
        }
        
        // 3. ACRONYM같은 구조로 이루어 져 있는가?
        // U.S.A, I.B.M
        NSString* acronym = [CTokenizer validateAcronym:item];
        if(acronym)
        {
            //NSUInteger* acrIndex =  [tokenList indexOfObject:item];
            //NSLog(@"index : %d", acrIndex);
            //token = [token stringByReplacingOccurrencesOfString:@"." withString:@""];
            //[tokenList replaceObjectAtIndex:0 withObject:@"cars"];
            NSLog(@"-3 Acronym : %@", acronym);
            continue;
        }
        
        // 4. COMPANY 이름인가?
        // AT&T, Excite@Home
        if([CTokenizer validateCompany:item]){
            NSLog(@"-4 Company : %@", item);
            continue;
        }
        
        // 5. Email 인가?
        if([CTokenizer validateEmail:item]){
            NSLog(@"-5 email : %@", item);
            continue;
        }
        
        
        // 6. Host name 인가?
        /*if([CTokenizer validateHost:item]){
            NSLog(@"-6 host : %@", item);
            continue;
        }*/
        NSURL* url = [NSURL URLWithString:item];
        if([url host]){
            NSLog(@"%@", [url host]);
        }
        
        // 7. serial, model number, ip address와 같은 값인가?
        if([CTokenizer validateSerial:item]){
            NSLog(@"-7 serial or model number or ip address : %@", item);
            continue;
        }
        //성능을 위해 이 부분 차 후 수정해야 함.
        //if([item rangeOfString:@"."].location != NSNotFound)
        //{
            //NSLog(@"마침표 - %@", item);
            //[tokenList find]
            //[item stringByReplacingOccurrencesOfString:@"." withString:@""];
        //}
        
        
        //위의 어느 조건에도 해당되지 않는가?
        NSLog(@"This is not a token %@", item);
        [discardedItems addObject:item];
    }
    if(tokenList.count != 1){
        [tokenList removeObjectsInArray:discardedItems];
    }
    
    return tokenList;
}

+(BOOL) validateAlphaDigitOnly:(NSString*) token
{
    NSCharacterSet *alphaDigitSet = [NSCharacterSet alphanumericCharacterSet];
    if([[token stringByTrimmingCharactersInSet:alphaDigitSet] isEqualToString:@""])
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(BOOL) validateAlphaOnly:(NSString*) token
{
    NSCharacterSet* alphaSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    alphaSet = [alphaSet invertedSet];
    
    NSRange r = [token rangeOfCharacterFromSet:alphaSet];
    if(r.location != NSNotFound)
        return false;
    else
        return true;
}

+(BOOL) validateApostrophe:(NSString*) token // 2. Apostrophe
{
    if([token rangeOfString:@"'"].location != NSNotFound)
    {
        BOOL apostrophe = true;
        NSArray* seperateTermByApostrophe = [NSArray alloc];
        seperateTermByApostrophe = [token componentsSeparatedByString:@"'"];
        for(id seperateTerm in seperateTermByApostrophe)
        {
            if (![CTokenizer validateAlphaOnly:seperateTerm])
            {
                apostrophe = false;
                break;
            }
        }
        if(apostrophe)
            return true;
        
    }
    return false;
}

+(NSString*) validateAcronym:(NSString*) token // 3. Acronym
{
    if([token rangeOfString:@"."].location != NSNotFound)
    {
        BOOL acronym = true;
        NSArray* seperateTermByAcronym = [NSArray alloc];
        seperateTermByAcronym = [token componentsSeparatedByString:@"."];
        /*if(seperateTermByAcronym.count == 2){
            return false;
        }
        else{*/
            for(id seperateTerm in seperateTermByAcronym)
            {
                if (![CTokenizer validateAlphaDigitOnly:seperateTerm])
                {
                    acronym = false;
                    break;
                }
            }

        //}
        if(acronym)
            token = [token stringByReplacingOccurrencesOfString:@"." withString:@""];
            return token;
    }
    return NULL;
}
+(BOOL) validateCompany:(NSString*) token // 4. Company
{
    BOOL company = true;
    NSString* sep = @"&-/@";
    NSCharacterSet* cSet = [NSCharacterSet characterSetWithCharactersInString:sep];
    NSArray* seperateTermByCompany = [NSArray alloc];
    seperateTermByCompany = [token componentsSeparatedByCharactersInSet:cSet];
    
    if(seperateTermByCompany.count == 2)
    {
        for(id seperateTerm in seperateTermByCompany)
        {
            if (![CTokenizer validateAlphaOnly:seperateTerm])
            {
                company = false;
                break;
            }
        }
        if(company)
            return true;
    }
    return false;
}
+(BOOL) validateEmail:(NSString*) token // 5. email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:token];
}

+(BOOL) validateHost:(NSString*) token // 6. Host
{
    NSLog(@"Host Check");
    NSURL* url = [NSURL URLWithString:token];
    if([url host]){
        return true;
    }
    return false;
}
+(BOOL) validateSerial:(NSString*) token // 7. Serial
{
    NSLog(@"Serial Check");
    return false;
}

@end


