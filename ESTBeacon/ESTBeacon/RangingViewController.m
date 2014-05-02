//
//  RangingViewController.m
//  ESTBeacon
//
//  Created by Yvan Siggen on 01.05.14.
//  Copyright (c) 2014 EIAFR. All rights reserved.
//

#import "RangingViewController.h"
#import <EstimoteSDK/ESTBeaconManager.h>
#import <EstimoteSDK/ESTBeacon.h>

@interface RangingViewController () <ESTBeaconManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *beaconUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconRangeLabel;

@property (nonatomic, strong) ESTBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *beaconRegion;
@property (nonatomic, strong) NSArray *beaconsArray;

@end

@implementation RangingViewController

- (id)initWithBeacon:(ESTBeacon *)beacon
{
    self = [super init];
    if (self)
    {
        self.beacon = beacon;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*Alloc the UUID we would like to range/connect too*/
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    /*Create manager instance*/
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    //    self.beaconManager.avoidUnknowsnStateBeacons = YES;
    
    /*Init region & start ranging : ranging is necessary to connect to the ranged beacon!*/
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:UUID identifier:@"EstimoteUUID"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated
{
    /*Stops ranging and disconnects from Beacon when we switch view*/
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.beacon disconnectBeacon];
    
    [super viewDidDisappear:animated];
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    int i = 0;
    for (ESTBeacon* rangedBeacon in beacons) {
        if (rangedBeacon.proximity == CLProximityImmediate) {
            NSLog(@"beacon %d : IMMEDIATE", i);
        }else if (rangedBeacon.proximity == CLProximityNear)
        {
            NSLog(@"beacon %d : NEAR", i);
        }else if (rangedBeacon.proximity == CLProximityFar)
        {
            NSLog(@"beacon %d : FAR", i);
        }else
        {
            NSLog(@"beacon %d : UNKNOWN", i);
        }
        i++;
    }
    
    self.beaconsArray = beacons;
    self.beacon = self.beaconsArray[0];
    NSLog(@"beacon uuid : %@", self.beacon.proximityUUID);
}

- (IBAction)connectBeacon:(id)sender
{
    /*Connect to ranged beacon*/
    [self.beacon connectToBeacon];
    
    if (self.beacon.isConnected == YES)
    {
        NSLog(@"is connected");
    }else if (self.beacon.isConnected == YES)
    {
        NSLog(@"is NOT connected");
    }
    
}


- (IBAction)disconnectBeacon:(id)sender
{
    /*Disconnect from Beacon when Button is pressed*/
    [self.beacon disconnectBeacon];
    if (self.beacon.isConnected == YES)
    {
        NSLog(@"is connected");
    }else if (self.beacon.isConnected == YES)
    {
       NSLog(@"is NOT connected");
    }
}



@end
