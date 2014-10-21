//
//  OSVector.h
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSqlite.h"
#import <math.h>

static double number_of_training_document = 2224897;

@interface OSVector : NSObject
{
    int maxTF;
    NSArray* terms;
    NSMutableArray* termTf;
    NSArray* termVector;
    double scalar;
}
@property NSArray* termVector;
@property NSArray* terms;
@property double scalar;

-(id) init:(NSArray*)termList;
-(void) setVector;
-(void) setScalar;
@end
