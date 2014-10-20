//
//  main.m
//  mailClassifier
//
//  Created by Youngsun_Park on 2014. 10. 17..
//  Copyright (c) 2014년 Youngsun. All rights reserved.
//
#include <MailCore/MailCore.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"


int main(int argc, char * argv[])
{
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"shysin8@gmail.com"];
    [session setPassword:@"tlsdyd123"];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
    
    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder requestKind:requestKind uids:uids];
    
    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }
        
        //And, let's print out the messages...
        NSLog(@"The post man delivereth:%@", fetchedMessages);
    }];

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
