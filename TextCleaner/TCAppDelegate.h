//
//  TCAppDelegate.h
//  TextCleaner
//
//  Created by Kevin Ross on 2/2/13.
//  Copyright (c) 2013 Kevin Ross. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSButton *pasteboardCheckbox;


- (IBAction)cleanText:(id)sender;
- (IBAction)clearText:(id)sender;

@end
