//
//  DataBaseViewController.m
//  DataBase2
//
//  Created by Karthik on 24/06/13.
//  Copyright (c) 2013 Srinivas. All rights reserved.
//

#import "DataBaseViewController.h"

@interface DataBaseViewController(){
    UIActivityIndicatorView *spinner;
}
@end

@implementation DataBaseViewController
@synthesize  theName=_theName;
@synthesize theAddress=_theAddress;
@synthesize thePhoneno=_thePhoneno;
@synthesize theStatslabel=_theStatus;
@synthesize databasePath=_databasePath;
@synthesize contactDB=_contactDB;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    spinner.color = [UIColor blueColor];
    [self.view addSubview:spinner];
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    _databasePath= [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"contacts.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
    const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _theStatus.text = @"Failed to create table";
            }
            sqlite3_close(_contactDB);
        } else {
            _theStatus.text = @"Failed to open/create database";
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveData:(id)sender {
     //[NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
   
    
    if ([_theName.text length]>0 || [_theAddress.text length]|| [_thePhoneno.text length]>0) {
         [spinner startAnimating];
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", self.theName.text, self.theAddress.text, self.thePhoneno.text];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_contactDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                _theStatus.text = @"Contact added successfully";
                _theName.text = @"";
                _theAddress.text = @"";
                _thePhoneno.text = @"";
            } else {
                _theStatus.text = @"Failed to add contact";
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
        }

        [spinner stopAnimating];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to SQLite Demo App!"
                                                        message:@"Please enter your Name, Address,Mobile!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }
            }

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}
- (IBAction)findData:(id)sender {
    
    if ([_theName.text length]>0 || [_theAddress.text length]|| [_thePhoneno.text length]>0) {
        [spinner startAnimating];
        const char *dbpath = [_databasePath UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT address, phone FROM contacts WHERE name=\"%@\"",_theName.text];
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(_contactDB,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *addressField = [[NSString alloc]
                                              initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    _theAddress.text = addressField;
                    NSString *phoneField = [[NSString alloc]
                                            initWithUTF8String:(const char *)
                                            sqlite3_column_text(statement, 1)];
                    _thePhoneno.text = phoneField;
                    _theStatus.text = @"Match found";
                    [spinner stopAnimating];
                } else {
                    _theStatus.text = @"Match not found";
                    _theAddress.text = @"";
                    _thePhoneno.text = @"";
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(_contactDB);
        }

        } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to SQLite Demo App!"
                                                        message:@"Please enter your Name, Address,Mobile!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

-(IBAction)GoawayKeyboard:(id)sender{
    [sender resignFirstResponder];
    [_theName resignFirstResponder];
    [_theAddress resignFirstResponder];
    [_thePhoneno resignFirstResponder];
}

 
@end
