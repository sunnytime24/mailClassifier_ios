//
//  EmailDetailViewController.h
//  mailClassifier
//
//  Created by Youngsun_Park on 2014. 10. 17..
//  Copyright (c) 2014년 Youngsun. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface EmailDetailViewController : UIViewController

@property (nonatomic, readwrite, weak) id emailDetail;
@property (nonatomic, readwrite, weak) IBOutlet UITextView *textView;

- (void)setEmailDetail:(id)emailDetail;

@end
