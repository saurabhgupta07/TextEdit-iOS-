//
//  TXTMainViewController.m
//  TextEdit
//
//  Created by Robert Irwin on 9/23/14.
//  Copyright (c) 2014 Robert Irwin. All rights reserved.
//

#import "TXTMainViewController.h"

@interface TXTMainViewController ()

@end

@implementation TXTMainViewController

NSString *fileName;
bool fileOpen = false;
UIAlertView * saveAsAlert;
- (void)viewDidLoad
{
    _currentFile.text = fileName;
    [super viewDidLoad];
    saveAsAlert = [[UIAlertView alloc] initWithTitle:@"Save As" message:@"Save to file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save As", nil];
    saveAsAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    saveAsAlert.tag =2;

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(TXTFlipsideViewController *)controller
{
    self.text.textColor = [UIColor colorWithRed: controller.redIntensity.value
                                          green: controller.greenIntensity.value
                                           blue: controller.blueIntensity.value
                                          alpha: 1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        NSLog(@"in prepareForSegue");
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.text resignFirstResponder];
}

- (IBAction)openFile:(id)sender{
    
    UIAlertView * openAlert = [[UIAlertView alloc] initWithTitle:@"Open" message:@"Open a file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open", nil];
    openAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    openAlert.tag = 1 ;
    [openAlert show];
    
}



- (IBAction)saveAsFile:(id)sender{
    
    
    UIAlertView * saveAsAlert = [[UIAlertView alloc] initWithTitle:@"Save As" message:@"Save to file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save As", nil];
    saveAsAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    saveAsAlert.tag =2;
    [saveAsAlert show];
    if(fileOpen == true){
        [saveAsAlert textFieldAtIndex:0].text = fileName;
        
    }
    
    
    
}


- (IBAction)saveFile:(id)sender{
    
    
    UIAlertView * saveAlert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Save to file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    saveAlert.tag =3 ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath;
    
    if(fileOpen == true){
        //fileName = (NSString*)[saveAlert textFieldAtIndex:0].text;
        filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        [[_text text] writeToFile:filePath atomically:true encoding:NSStringEncodingConversionAllowLossy error:nil];
        NSString *fileSavedMessage = [@"Saved to File : "  stringByAppendingString:fileName];
        UIAlertView * fileSavedAlert = [[UIAlertView alloc] initWithTitle:@"File Saved" message:fileSavedMessage delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [fileSavedAlert show];

        
    }
    else
    {
        [saveAsAlert show];
    }
    
    
    
}
- (IBAction)insertFile:(id)sender
{
    UIAlertView * insertFileAlert = [[UIAlertView alloc] initWithTitle:@"Insert" message:@"Type a file name to be inserted" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Insert", nil];
    insertFileAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    insertFileAlert.tag = 4 ;
    [insertFileAlert show];
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath;
    UIAlertView * fileDoesntExistAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"File Doesnt Exist" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];

    
    if(alertView.tag==1 && buttonIndex ==1){
        
        filePath = [documentsDirectory stringByAppendingPathComponent:(NSString*)[alertView textFieldAtIndex:0].text];

        
        
        if(![manager fileExistsAtPath:filePath]){
            
            filePath = [documentsDirectory stringByAppendingPathComponent:(NSString*)[alertView textFieldAtIndex:0].text];
            
            [fileDoesntExistAlert show];
            //fileName = @"";
            
        }
        else{
            fileName = (NSString*)[alertView textFieldAtIndex:0].text;
            //filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            fileOpen = true;
            [_text setText: [NSString stringWithContentsOfFile:filePath encoding: NSStringEncodingConversionAllowLossy error: nil ]] ;
             _currentFile.text = fileName;
        }
        
        
        
        
        
    }
    
    if(alertView.tag==2 && buttonIndex ==1){
        
        fileName = (NSString*)[alertView textFieldAtIndex:0].text;
        filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            if (![manager fileExistsAtPath:filePath]) {
                
                if(fileOpen == false){
                    fileOpen = true;
                    
                }
                
                if([manager createFileAtPath:filePath contents:(NSData*)[_text text]  attributes:nil]){
                     _currentFile.text = fileName;
                    NSLog(@"Created the File Successfully.");
                }
                
                else
                    NSLog(@"Failed to Create the File");
                
                
            }
            
            else{
                NSLog(@"%@",fileName);
                
                
                [[_text text] writeToFile:filePath atomically:true encoding:NSStringEncodingConversionAllowLossy error:nil];
                
            }
    }
    
        
        
        
    
    if(alertView.tag==3 && buttonIndex ==1){
        
        fileName = (NSString*)[alertView textFieldAtIndex:0].text;
        filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        fileOpen = true;
        if([manager createFileAtPath:filePath contents:(NSData*)[_text text]  attributes:nil]){
             _currentFile.text = fileName;
            NSLog(@"Created the File Successfully.");
            
        }
        else {
            NSLog(@"Failed to Create the File");
        }
        
        
        
        //Text copied is : %@", [NSString stringWithContentsOfFile:filePath]
        /*NSArray *files = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
         // Log the Path of document directory.
         NSLog(@"Directory: %@", documentsDirectory);
         // For each file, log the name of it.
         for (NSString *file in files) {
         NSLog(@"File at: %@", file);
         }
         //NSLog(@"data from file : %@",[[NSData dataWithContentsOfFile:filePath] text]);*/
        //Text copied is : %@", [NSString stringWithContentsOfFile:filePath]
        
     
        
        
        
    }
    if(alertView.tag==4 &&buttonIndex==1){
        
         filePath = [documentsDirectory stringByAppendingPathComponent:(NSString*)[alertView textFieldAtIndex:0].text];
        if(![manager fileExistsAtPath:filePath]){
            
            [fileDoesntExistAlert show];
            //fileName = @"";
            
        }
        else{
         NSString * content = [NSString stringWithContentsOfFile:filePath encoding: NSStringEncodingConversionAllowLossy error: nil ];
        _text.text = [_text.text stringByAppendingString:content];
        }
        
    }
    

    
}
@end
