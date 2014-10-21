//
//  OSDocument.m
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import "OSDocument.h"

@implementation OSDocument
@synthesize docVector, termList;

-(id) init:(NSString*) text
{
    self = [super init];
    if(self){
        NSMutableArray* tokenList = [NSMutableArray alloc];
        tokenList = [CTokenizer tokenizer:text];
        if(tokenList.count != 0)
        {
            termList = tokenList;
            docVector = [[OSVector alloc] init:termList];
            [docVector setVector];
            NSLog(@"vector set OK");
        }
    }
    return self;
}
-(OSVector*) getVector
{
    return docVector;
}
@end