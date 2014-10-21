//
//  OSSqlite.m
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import "OSSqlite.h"

@implementation OSSqlite
//Constructor
- (id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
+(void) initialize
{
    dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
}
-(NSMutableArray*) getTermList:(NSArray*)termList
{
    NSMutableArray* termDfList = [[NSMutableArray alloc] init];
    @try{
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        //dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        NSMutableString* whereTerm = [termList componentsJoinedByString:@"\", \""];
        [whereTerm appendString:@"\""];
        [whereTerm insertString:@"\"" atIndex:0];
        NSLog(@"%@", whereTerm);
        //NSLog(@"\"");
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM vocabulary WHERE term IN (%@)", whereTerm] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getTermList");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSString* termText = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            NSNumber* termDf = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 1)];
            NSNumber* termId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 2)];
            NSMutableDictionary* row = [NSMutableDictionary dictionaryWithObjectsAndKeys:termText, @"term", termDf, @"df", termId, @"termid", nil];
            [termDfList addObject:row];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return termDfList;
    }
}
-(NSArray*) getAllVocabulary
{
    NSMutableArray* Columns = [[NSMutableArray alloc] init];
    @try{
        dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM vocabulary"] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getAllVocabulary");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSString* termText = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            NSNumber* termDf = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 1)];
            NSNumber* termId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 2)];
            NSDictionary* row = [NSDictionary dictionaryWithObjectsAndKeys:termText, @"term", termDf, @"df", termId, @"termid", nil];
            [Columns addObject:row];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return Columns;
    }
}
-(NSArray*) getAllPostings
{
    NSMutableArray* Columns = [[NSMutableArray alloc] init];
    @try{
        dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM postings"] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getAllPostings");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSNumber* termId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 0)];
            NSNumber* categoryId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 1)];
            NSNumber* tfidf = [NSNumber numberWithInt:(float *) sqlite3_column_int(sqlStatement, 2)];
            
            NSDictionary* row = [NSDictionary dictionaryWithObjectsAndKeys:termId, @"TermID", categoryId, @"CategoryID", tfidf, @"TFIDF", nil];
            [Columns addObject:row];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return Columns;
    }
}
-(NSArray*) getAllCategories
{
    NSMutableArray* Columns = [[NSMutableArray alloc] init];
    @try{
        dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM category"] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getAllCategories");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSNumber* categoryId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 0)];
            NSString* name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            NSNumber* scalar = [NSNumber numberWithDouble:sqlite3_column_double(sqlStatement, 2)];
            
            NSDictionary* row = [NSDictionary dictionaryWithObjectsAndKeys:categoryId, @"categoryID", name, @"name", scalar, @"scalar", nil];
            [Columns addObject:row];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return Columns;
    }
}
-(NSArray*) getPostingsByTerm:(NSNumber *)termID
{
    NSMutableArray* Columns = [[NSMutableArray alloc] init];
    @try{
        dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM postings WHERE TermID = %@", termID] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getPostingByTerms");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSNumber* termId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 0)];
            NSNumber* categoryId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 1)];
            
            NSNumber* tfidf = [NSNumber numberWithDouble:sqlite3_column_double(sqlStatement, 2)];
            
            NSDictionary* row = [NSDictionary dictionaryWithObjectsAndKeys:termId, @"TermID", categoryId, @"CategoryID", tfidf, @"TFIDF", nil];
            [Columns addObject:row];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return Columns;
    }
    
}
-(NSDictionary*) getCategoryById:(NSNumber *)categoryId
{
    NSMutableArray* Columns = [[NSMutableArray alloc] init];
    NSDictionary* row = [[NSDictionary alloc] init];
    
    @try{
        dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"sigmaBase030.db"];
        [OSSqlite errorHandler];
        NSLog(@"%@", categoryId);
        const char* sqlQuery = [[NSString stringWithFormat:@"SELECT * FROM category WHERE categoryID = %@", categoryId] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt* sqlStatement;
        if(sqlite3_prepare(testDB, sqlQuery, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement in getCategoryByID");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            
            NSNumber* categoryId = [NSNumber numberWithInt:(int *) sqlite3_column_int(sqlStatement, 0)];
            NSString* name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            NSNumber* scalar = [NSNumber numberWithDouble:sqlite3_column_double(sqlStatement, 2)];
            
            row = [NSDictionary dictionaryWithObjectsAndKeys:categoryId, @"categoryID", name, @"name", scalar, @"scalar", nil];
        }
    }
    @catch (NSException* exception){
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally{
        return row;
    }
    
}

+(void) errorHandler
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    if(!(sqlite3_open([dbPath UTF8String], &testDB) == SQLITE_OK))
    {
        NSLog(@"An SigmaSqlite error has occured.");
    }
}
@end