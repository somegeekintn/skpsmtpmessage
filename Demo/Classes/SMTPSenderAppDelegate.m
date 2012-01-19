//
//  SMTPSenderAppDelegate.m
//  SMTPSender
//
//  Created by Ian Baird on 10/28/2008.
//
//  Copyright (c) 2008 Skorpiostech, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "SMTPSenderAppDelegate.h"
#import "SMTPViewController.h"

@interface SMTPSenderAppDelegate (Private)

- (void)		initDefaults;

@end

@implementation SMTPSenderAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void) dealloc
{
	self.window = nil;
	self.viewController = nil;

    [super dealloc];
}

- (void) initDefaults
{
	NSString		*defaultsPath = [[NSBundle mainBundle] pathForResource: @"Defaults" ofType: @"plist"];
	
	if (defaultsPath != nil) {
		NSDictionary	*defaultDefaults = [NSDictionary dictionaryWithContentsOfFile: defaultsPath];
		
		if (defaultDefaults != nil) {
			[[NSUserDefaults standardUserDefaults] registerDefaults: defaultDefaults];
		}
	}
}

- (void) applicationDidFinishLaunching: (UIApplication *) inApplication
{    
	[self initDefaults];

	self.window = [[[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
	self.viewController = [[[SMTPViewController alloc] initWithNibName: @"SMTPViewController" bundle: nil] autorelease];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
}

- (void) applicationDidBecomeActive: (UIApplication *) inApplication
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.viewController updateTextView: nil];
}

@end
