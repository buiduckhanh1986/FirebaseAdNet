//
//  MainScreen.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/5/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "MainScreen.h"
#import "BootLogic.h"
@interface MainScreen () <UIAlertViewDelegate>

@end

@implementation MainScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)setAbout:(NSString *)about {
    _about = [NSString stringWithFormat:@"%@\n\n%@", about, @"Written by Retech"];
}

-(void) onAbout {
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:@"About"
                                  message:self.about
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Thank"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* menuSection = self.menu[section];
    
    return [menuSection[MENU] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* menuSection = self.menu[section];
    return menuSection[SECTION];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* menuSection = self.menu[indexPath.section];
    NSDictionary* menuItem = menuSection[MENU][indexPath.row];
    cell.textLabel.text = menuItem[TITLE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* menuSection = self.menu[indexPath.section];
    NSDictionary* menuItem = menuSection[MENU][indexPath.row];
    NSString* xibClass = menuItem[CLASS];
    
    UIViewController* detailScreen;
    
    
    if([[NSBundle mainBundle] pathForResource:xibClass ofType:@"nib"] != nil)
    {
        //If the xib file exists
        detailScreen = [(UIViewController*)[NSClassFromString(xibClass) alloc] initWithNibName:xibClass bundle:nil];
    } else {
        //If the xib file does not exist
        detailScreen = [NSClassFromString(xibClass) new];
    }
    detailScreen.title = menuItem[TITLE];
    
    if (detailScreen) {
        [self.navigationController pushViewController:detailScreen animated:YES];
    } else {
        //Warn if cannot initialize detailScreen
        NSString* message = [NSString stringWithFormat:@"Please implement screen %@", xibClass];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        
        [alert addAction:okButton];
    }
    
}


@end
