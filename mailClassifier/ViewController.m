//
//  ViewController.m
//  mailClassifier
//
//  Created by Youngsun_Park on 2014. 10. 17..
//  Copyright (c) 2014년 Youngsun. All rights reserved.
//
//

#import "ViewController.h"
#import "EmailDetailViewController.h"

#import <MailCore/MailCore.h>

@interface ViewController ()

@property (nonatomic, readwrite, strong) NSMutableArray *messages;

@end

@implementation ViewController

@synthesize messages=_messages;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.messages = [[NSMutableArray alloc] init];
    NSLog(@"Starting to get emails");
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    [session setHostname:@"imap.gmail.com"];
    [session setPort:993];
    [session setUsername:@"mobideku@gmail.com"];
    [session setPassword:@"mobide135"];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
    NSString *folder = @"INBOX";
    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];

    MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesByUIDOperationWithFolder:folder
                                                                                       requestKind:requestKind
                                                                                              uids:uids];

    [fetchOperation start:^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {

        NSLog(@"Finished downloading messages!");
        
        if(error) {
            NSLog(@"Error downloading message headers: %@", error);
        }
        
        NSLog(@"Message headers are %@", messages);

        [self.messages addObjectsFromArray:messages]; // 메세지 가져오는곳
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.messages objectAtIndex:indexPath.row] description];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue to %@ from sender %@", [[segue destinationViewController] description], [sender description]);
    EmailDetailViewController *emailDetailViewController = [segue destinationViewController];
    UITableViewCell *selectedCell = (UITableViewCell*)sender;
    [emailDetailViewController setEmailDetail:selectedCell.textLabel.text];
}

@end
