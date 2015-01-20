//
//  TXTMainViewController.h
//  TextEdit
//
//  Created by Robert Irwin on 9/23/14.
//  Copyright (c) 2014 Robert Irwin. All rights reserved.
//

#import "TXTFlipsideViewController.h"

@interface TXTMainViewController : UIViewController <TXTFlipsideViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *text;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)openFile:(id)sender;
- (IBAction)saveAsFile:(id)sender;
- (IBAction)saveFile:(id)sender;
- (IBAction)insertFile:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *currentFile;
@property (weak, nonatomic) IBOutlet UITextView *textData;
@end
