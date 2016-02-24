//
//  ViewController.m
//  LDAPAuthentication
//
//  Created by Firdous on 24/02/2016.
//  Copyright © 2016 TenPearls. All rights reserved.
//

#import "ViewController.h"
#import "LDAPHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    my_ldap_test();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
