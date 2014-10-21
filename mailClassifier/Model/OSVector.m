//
//  OSVector.m
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import "OSVector.h"

@implementation OSVector
@synthesize termVector, terms, scalar;

-(id) init:(NSArray*)termList
{
    self = [super init];
    if(self)
    {
        NSMutableArray* realTerms = [NSMutableArray array];
        termTf = [NSMutableArray array];
        maxTF = [termList count];
        NSCountedSet* indexTermList = [[NSCountedSet alloc] initWithArray:termList];
        for (id item in indexTermList)
        {
            NSNumber* count = [NSNumber numberWithInt:[indexTermList countForObject:item]];
            NSMutableDictionary* term = [NSMutableDictionary dictionaryWithObjectsAndKeys:item, @"term", count, @"tf", nil];
            [termTf addObject:term];
            [realTerms addObject:item];
        }
        terms = realTerms;
    }
    return self;
}

-(void) setVector
{
    //Get matched terms from Sqlite DB
    OSSqlite* sqliteApi = [[OSSqlite alloc] init];
    termVector = [sqliteApi getTermList:terms];
    NSUInteger count = [termVector count];
    for (NSUInteger i = 0; i < count; i++){
        NSMutableDictionary* term = [termVector objectAtIndex: i];
        NSString* termText = [term objectForKey:@"term"];
        int termDf = [[term objectForKey:@"df"] intValue];
        NSNumber* termId = [term objectForKey:@"termid"];
        //First get tfidf and than go home
        double tfidf = 0.0;
        double idf = log(number_of_training_document/termDf);
        BOOL found = NO;
        for(NSDictionary* dict in termTf)
        {
            found = [[dict objectForKey:@"term"] isEqualToString:termText];
            if(found)
            {
                double normA = 0.4;
                double tf =[[dict objectForKey:@"tf"] doubleValue];
                //double tf = normA + (1-normA)*([[dict objectForKey:@"tf"] doubleValue]/maxTF);
                tfidf = tf*idf;
                break;
            }
        }
        [term setValue:[NSNumber numberWithDouble:tfidf] forKey:@"TFIDF"];
    };
    [self setScalar];
}

-(void) setScalar
{
    scalar = 0.0;
    for (NSDictionary* dict in termVector)
    {
        double weight = [[dict objectForKey:@"TFIDF"] doubleValue];
        scalar += weight*weight;
    }
    scalar = sqrt(scalar);
}
@end

