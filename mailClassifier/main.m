//
//  main.m
//  mailClassifier
//
//  Created by Youngsun_Park on 2014. 10. 17..
//  Copyright (c) 2014년 Youngsun. All rights reserved.
//
#include <MailCore/MailCore.h>
#include <ctemplate/template.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"


int main(int argc, char * argv[])
{
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"mobideku@gmail.com"];
    [session setPassword:@"mobide135"];
    [session setConnectionType:MCOConnectionTypeTLS];
    [[session fetchAllFoldersOperation] start:^(NSError* error, NSArray* folders){
        NSLog(@"All folders for session %@", folders);
    }];
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
        for (id message in fetchedMessages){
            NSLog(@"start message");
            NSLog(@"%@", message);
            NSLog(@"end of message");
        }
        
        //NSLog(@"The post man delivereth:%@", fetchedMessages);
    }];

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
