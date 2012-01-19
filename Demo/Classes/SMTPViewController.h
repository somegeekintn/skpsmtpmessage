//
//  SMTPViewController.h
//  SMTPSender
//
//  Created by Casey Fleser on 1/19/12.
//  Copyright (c) 2012 Griffin Technology, Inc. All rights reserved.
//

#import "SKPSMTPMessage.h"
#import <UIKit/UIKit.h>

@interface SMTPViewController : UIViewController <SKPSMTPMessageDelegate>
{
}

- (IBAction)	updateTextView:(id) inSender;
- (IBAction)	sendMessage: (id) inSender;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView	*activityView;
@property (retain, nonatomic) IBOutlet UITextView				*textView;

@end
