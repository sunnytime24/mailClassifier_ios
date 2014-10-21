//
//  OSSqlite.h
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

static sqlite3* testDB;
static NSMutableString* dbPath;
@interface OSSqlite : NSObject
{
    
}

+(void) initialize;
-(NSMutableArray*) getTermList:(NSArray*)termList;
-(NSArray*) getAllVocabulary;
-(NSArray*) getAllPostings;
-(NSArray*) getAllCategories;
-(NSArray*) getPostingsByTerm:(NSNumber*)termText;
-(NSDictionary*) getCategoryById:(NSNumber*)categoryId;
+(void) errorHandler;
@end
