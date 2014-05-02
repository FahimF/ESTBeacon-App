//
//  MonitoringViewController.m
//  ESTBeacon
//
//  Created by Yvan Siggen on 01.05.14.
//  Copyright (c) 2014 EIAFR. All rights reserved.
//

#import "MonitoringViewController.h"
#import <EstimoteSDK/ESTBeaconManager.h>
#import "AppDelegate.h"

@interface MonitoringViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *beaconRegion;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *monitoringLabel;

@end

@implementation MonitoringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.beaconManager stopMonitoringForRegion:self.beaconRegion];
    
    [super viewDidDisappear:animated];
}

- (void)refreshView:(NSNotification *)notification
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.inRegion == YES) {
         NSLog(@"refreshview (YES) inRegion : %d", appDelegate.inRegion);
        self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:(20/255.0) green:(209/255.0) blue:0 alpha:1];
        [self.monitoringLabel setTintColor:[UIColor colorWithRed:(252/255.0) green:(252/255.0) blue:(252/255.0) alpha:1]];
        [self.monitoringLabel initWithTitle:@"Détéction effectuée" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    else if (appDelegate.inRegion == NO)
    {
        NSLog(@"refreshview (NO) inRegion : %d", appDelegate.inRegion);
        self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:(240/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
        [self.monitoringLabel setTintColor:[UIColor colorWithRed:(252/255.0) green:(252/255.0) blue:(252/255.0) alpha:1]];
        [self.monitoringLabel initWithTitle:@"Pas de Détéction" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    else{
        return;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
