//
//  GNDirectoryViewController.m
//  Genesis
//
//  Created by Peter Hajas on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GNDirectoryViewController.h"

@implementation GNDirectoryViewController

-(id)initWithBackingPath:(NSString *)path andNavigationController:(UINavigationController *)navigationController
{
    self = [super initWithNibName:@"GNDirectoryViewController" bundle:[NSBundle mainBundle]];
    if(self)
    {
        [self setTitle:[path lastPathComponent]];
        backingPath = [NSString stringWithString:path];
        directoryContentsTableViewController = [[GNDirectoryContentsTableViewController alloc] initWithBackingPath:path];
        [directoryContentsTableViewController setDelegate:self];
        pushableNavigationController = navigationController;
    }
    return self;
}

#pragma mark - Navigation bar buttons

-(IBAction)addFilesystemEntryButtonPressed:(id)sender
{
    GNNewFileEntryViewController* newFileEntryViewController = [[GNNewFileEntryViewController alloc] initWithBackingPath:backingPath];
    [newFileEntryViewController setDelegate:self];
    [self presentModalViewController:newFileEntryViewController animated:YES];
}


#pragma mark - GNDirectoryContentsTableViewControllerDelegate methods

-(void)didSelectDirectoryWithRelativePath:(NSString*)relativePath
{
    // Create a new GNDirectoryViewController for this path, and then browse to it
    GNDirectoryViewController* directoryViewController = [[GNDirectoryViewController alloc] initWithBackingPath:[backingPath stringByAppendingPathComponent:relativePath]
                                                                                        andNavigationController:pushableNavigationController];
    
    [pushableNavigationController pushViewController:directoryViewController animated:YES];
}

-(void)didSelectFileWithRelativePath:(NSString*)relativePath
{
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the table view controller tableview to our IBOutlet'd one
    [directoryContentsTableViewController setTableView:tableView];
    [tableView reloadData];
    
    // Create our "add" button for files / folders
    UIBarButtonItem* addButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFilesystemEntryButtonPressed:)];
    
    [[self navigationItem] setRightBarButtonItem:addButtonItem animated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)didCreateFileEntry
{
    [tableView reloadData];
}

@end
