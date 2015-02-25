//
//  ViewController.m
//  PRCompatibleAlertController
//
//  Created by Pabitr on 26/02/15.
//  Copyright (c) 2015 BlackCode. All rights reserved.
//

#import "ViewController.h"
#import "CompatibleAlertController.h"

@interface ViewController ()
{
    CompatibleAlertController *compatibleAlertController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showAlert:(UIButton*)sender
{
    compatibleAlertController =[[CompatibleAlertController alloc]initWithTitle:@"Title" message:@"Message" preferredStyle:CompatibleAlertControllerStyleAlert];
    
    CompatibleAlertAction *destructiveAction = [[CompatibleAlertAction alloc] initWithTitle:@"Destroy" style:CompatibleAlertActionStyleDestructive handler:^(CompatibleAlertAction *action) {
        NSLog(@"Destroy ....");
    }];
    
    [compatibleAlertController addAction:destructiveAction];
    
    [compatibleAlertController presentCompatibleAlertController:self animated:YES completion:NULL];

}

@end
