//
//  STAItemsTableViewController.m
//  Simple Tasks
//
//  Created by Merritt Tidwell on 7/30/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "STAItemsTableViewController.h"
#import "STAEditItemViewController.h"
#import "STANewItemsViewController.h"
@interface STAItemsTableViewController ()

@end

@implementation STAItemsTableViewController

{
    NSMutableArray * items;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    
        
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIBarButtonItem * addNewItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItemClicked)];

    self.navigationItem.rightBarButtonItem = addNewItem;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addNewItemClicked
{
    STANewItemsViewController * addNewItemsVC =[[STANewItemsViewController alloc]init];
    addNewItemsVC.items = self.groupInfo[@"items"];
   
    
    [self.navigationController presentViewController:addNewItemsVC animated: YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    items = self.groupInfo[@"items"];
     return items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = items[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    /* How to turn strings into floats
    NSString* myNumber = @"55.03";
    float myNumberFloat = [myNumber floatValue];
    */
    float priority = [self.groupInfo[@"items"][indexPath.row][@"priority"] floatValue];
    
    float priorityHue = priority/360 ;
    
   cell.backgroundColor = [UIColor colorWithHue:priorityHue saturation:1.0 brightness:1.0 alpha:1.0];
    self.tableView.rowHeight= 90;
    
    // Configure the cell...
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    STAEditItemViewController * editItemVC = [[STAEditItemViewController alloc] init];
    
    editItemVC.itemInfo = items[indexPath.row];
    
    [self.navigationController pushViewController:editItemVC animated:YES];

    
    
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self saveItemData];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        [items removeObjectAtIndex:indexPath.row];

        // Delete the row from the data source
        [self saveItemData];
        
        [self loadItemData];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
;
}


-(void)saveItemData
{
    NSData * itemData = [NSKeyedArchiver archivedDataWithRootObject:items];
    
    [itemData writeToFile:[self itemFilePath] atomically:YES];
}
-(NSMutableArray *) loadItemData
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemFilePath]];
    
    
}

-(NSString *)itemFilePath
{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * path = documentDirectories[0];
    
    return [path stringByAppendingPathComponent:@"item.data"];
}



-(BOOL)prefersStatusBarHidden{return YES; }


@end
