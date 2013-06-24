//
//  DataBaseViewController.h
//  DataBase2
//
//  Created by Karthik on 24/06/13.
//  Copyright (c) 2013 Srinivas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface DataBaseViewController : UIViewController

@property(strong,nonatomic)NSString *databasePath;
@property(nonatomic)sqlite3 *contactDB;

@property (strong, nonatomic) IBOutlet UITextField *theName;
@property (strong, nonatomic) IBOutlet UITextField *theAddress;
@property (strong, nonatomic) IBOutlet UITextField *thePhoneno;
@property (strong, nonatomic) IBOutlet UILabel *theStatslabel;

- (IBAction)saveData:(id)sender;
- (IBAction)findData:(id)sender;

-(IBAction)GoawayKeyboard:(id)sender;
@end
