//
//  EmailDetailViewController.m
//  mailClassifier
//
//  Created by Youngsun_Park on 2014. 10. 17..
//  Copyright (c) 2014년 Youngsun. All rights reserved.
//
//

#import "EmailDetailViewController.h"

@interface EmailDetailViewController ()

- (void)refreshLabel;

@end

@implementation EmailDetailViewController

@synthesize emailDetail=_emailDetail;
@synthesize textView=_textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Preparing for segue to %@", [[segue destinationViewController] description]);
}

- (void)setEmailDetail:(id)emailDetail
{
    if(self.emailDetail != emailDetail) {
        _emailDetail = emailDetail;
        [self refreshLabel];
    }
}

- (void)refreshLabel
{
    self.textView.text = [self.emailDetail description];
}

@end
