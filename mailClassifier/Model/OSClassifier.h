//
//  OSClassifier.h
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSDocument.h"
#import "OSSqlite.h"

static NSArray* postings;
static NSArray* category;
static NSArray* vocabulary;
static int k = 5;

@interface OSClassifier : NSObject
{
    NSMutableString* query;
    OSDocument* queryDoc;
}
@property OSDocument* queryDoc;

+(void) setMemory;

-(id) init:(NSString*) query;
-(NSArray*)topK;

@end