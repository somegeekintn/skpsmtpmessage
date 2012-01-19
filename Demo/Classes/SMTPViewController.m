//
//  SMTPViewController.m
//  SMTPSender
//
//  Created by Casey Fleser on 1/19/12.
//  Copyright (c) 2012 Griffin Technology, Inc. All rights reserved.
//

#import "SMTPViewController.h"
#import "SKPSMTPMessage.h"

@interface SMTPViewController (Private)

- (void)		sendVCardMessage;
- (void)		sendPNGMessage;

@end

@implementation SMTPViewController

@synthesize activityView = _activityView;
@synthesize textView = _textView;

#pragma mark - View lifecycle

- (void) dealloc
{
	self.textView = nil;
	self.activityView = nil;

	[super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidUnload
{
	self.textView = nil;
	self.activityView = nil;

    [super viewDidUnload];
}

#pragma mark - Send / Status

- (IBAction) updateTextView: (id) inSender
{
    NSMutableString *logText = [[NSMutableString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [logText appendString:@"Use the iOS Settings app to change the values below.\n\n"];
    [logText appendFormat:@"From: %@\n", [defaults objectForKey:@"fromEmail"]];
    [logText appendFormat:@"To: %@\n", [defaults objectForKey:@"toEmail"]];
    [logText appendFormat:@"Host: %@\n", [defaults objectForKey:@"relayHost"]];
    [logText appendFormat:@"Auth: %@\n", ([[defaults objectForKey:@"requiresAuth"] boolValue] ? @"On" : @"Off")];
    
    if ([[defaults objectForKey:@"requiresAuth"] boolValue]) {
        [logText appendFormat:@"Login: %@\n", [defaults objectForKey:@"login"]];
        [logText appendFormat:@"Password: %@\n", [defaults objectForKey:@"pass"]];
    }
    [logText appendFormat:@"Secure: %@\n", [[defaults objectForKey:@"wantsSecure"] boolValue] ? @"Yes" : @"No"];
    self.textView.text = logText;
    [logText release];
}

- (IBAction) sendMessage: (id) inSender
{
	[self.activityView startAnimating];
	[self sendPNGMessage];
}

- (void) sendVCardMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"fromEmail"];
    testMsg.toEmail = [defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"relayHost"];
    testMsg.requiresAuth = [[defaults objectForKey:@"requiresAuth"] boolValue];
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"login"];
        testMsg.pass = [defaults objectForKey:@"pass"];
    }
    testMsg.wantsSecure = [[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!

    testMsg.subject = @"SMTPMessage Test Message";
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    [testMsg addTextPart: @"This is a tést messåge."];
    [testMsg addFilePart: [[NSBundle mainBundle] pathForResource: @"test" ofType: @"vcf"] withMIMEType: @"text/vcard"];
    [testMsg send];

}

//  Pretty much the same as sendVCardMessage, eh?
//  made it this way for demonstration purposes
 
- (void) sendPNGMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"fromEmail"];
    testMsg.toEmail = [defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"relayHost"];
    testMsg.requiresAuth = [[defaults objectForKey:@"requiresAuth"] boolValue];
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"login"];
        testMsg.pass = [defaults objectForKey:@"pass"];
    }
    testMsg.wantsSecure = [[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!

    testMsg.subject = @"SMTPMessage Test Message";
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    [testMsg addTextPart: @"This is a tést messåge."];
    [testMsg addFilePart: [[NSBundle mainBundle] pathForResource: @"closebox" ofType: @"png"] withMIMEType: @"text/vcard"];
    [testMsg send];

}

- (void) messageSent: (SKPSMTPMessage *) inMessage
{
	[self.activityView stopAnimating];
	[inMessage release];
	self.textView.text  = @"Yay! Message was sent!";
}

- (void) messageFailed: (SKPSMTPMessage *) inMessage
	error: (NSError *) inError
{
	[self.activityView stopAnimating];
	self.textView.text = [NSString stringWithFormat:@"Darn! Error!\n%i: %@\n%@", [inError code], [inError localizedDescription], [inError localizedRecoverySuggestion]];
	[inMessage release];
}

@end
