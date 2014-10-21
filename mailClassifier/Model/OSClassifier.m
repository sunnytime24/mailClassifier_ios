//
//  OSClassifier.m
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import "OSClassifier.h"

@implementation OSClassifier
@synthesize queryDoc;
+(void)setMemory
{
    OSSqlite* sqliteApi = [[OSSqlite alloc] init];
    //postings = [sqliteApi getAllPostings];
    //vocabulary = [sqliteApi getAllVocabulary];
    category = [sqliteApi getAllCategories];
}
-(id)init:(NSString*) query
{
    self = [super init];
    if(self)
    {
        //NSMutableArray* tokenList = [NSMutableArray alloc];
        //tokenList = [query componentsSeparatedByString:@" "];
        //NSLog(@"%@", tokenList);
        queryDoc = [[OSDocument alloc] init:query];
        //여기서 토크나이징하는게 아니라, 도큐먼트에서 토크나이징하는 함수를 가지고 있어야한다.
    }
    return self;
}

-(NSArray*)topK
{
    OSSqlite* sqliteApi = [[OSSqlite alloc] init];
    NSMutableArray* topCategories = [NSMutableArray array];
    NSArray* termVector = [[queryDoc getVector] termVector];
    double queryScalar = [[queryDoc getVector] scalar];
    for(NSUInteger i = 0; i < [termVector count]; i++)
    {
        NSArray* categories = [sqliteApi getPostingsByTerm:[termVector[i] objectForKey:@"termid"]];
        for (NSUInteger a = 0; a < [categories count]; a++)
        {
            double score = [[termVector[i] objectForKey:@"TFIDF"] doubleValue] * [[categories[a] objectForKey:@"TFIDF"] doubleValue];
            NSNumber* categoryID = [categories[a] objectForKey:@"CategoryID"];
            bool alreadyExist = false;
            for(NSDictionary* dict in topCategories)
            {
                if([[dict objectForKey:@"CategoryID"] isEqualToNumber:categoryID])
                {
                    //topCategories안에 카테고리가 이미 있다.
                    score = score + [[dict objectForKey:@"score"] doubleValue];
                    alreadyExist = true;
                    [dict setValue:[NSNumber numberWithDouble:score] forKey:@"score"];
                    //NSLog(@"%@, %g", categoryID, score);
                }
            }
            if (alreadyExist == false)
            {
                //topCategories안에 카테고리가 없다.
                NSMutableDictionary* category = [NSMutableDictionary dictionaryWithObjectsAndKeys:[categories[a] objectForKey:@"CategoryID"], @"CategoryID", [NSNumber numberWithDouble:score], @"score", nil];
                [topCategories addObject:category];
                //NSLog(@"%@, %g", categoryID, score);
            }
        }
    }
    
    for (NSDictionary* dict in topCategories)
    {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"(categoryID == %@)", [dict objectForKey:@"CategoryID"]];
        NSDictionary *categoryDict = [[category filteredArrayUsingPredicate:filter] objectAtIndex:0];
        //NSLog(@"%@", categoryDict);
        double score = [[dict objectForKey:@"score"] doubleValue] / (queryScalar*[[categoryDict objectForKey:@"scalar"] doubleValue]);
        
        [dict setValue:[NSNumber numberWithDouble:score] forKey:@"score" ];
        [dict setValue:[categoryDict objectForKey:@"name"] forKey:@"name"];
        [dict setValue:[categoryDict objectForKey:@"scalar"] forKey:@"scalar"];
    }
    NSLog(@"%@", topCategories);
    if([topCategories count] > 5){
        NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
        topCategories = [topCategories sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        topCategories = [topCategories subarrayWithRange:NSMakeRange(0, k)];
    }else if([topCategories count] > 0){
        
    }else{
        NSLog(@"No Result");
    }
    return topCategories;
}
@end