//
//  OSDocument.h
//  MobiDE
//
//  Created by haeyong Shin on 10/1/14.
//  Copyright (c) 2014 MobiDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSVector.h"
#import "CTokenizer.h"
@interface OSDocument : NSObject
{
    OSVector* docVector;
    NSMutableArray* termList;
    
}
@property OSVector* docVector;
@property NSMutableArray* termList;

-(id) init:(NSString*) text;
-(OSVector*) getVector;
@end