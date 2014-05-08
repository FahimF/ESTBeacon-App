//
//  RangingViewController.m
//  ESTBeacon
//
//  Created by Yvan Siggen on 01.05.14.
//  Copyright (c) 2014 EIAFR. All rights reserved.
//

#import "RangingViewController.h"
#import <EstimoteSDK/ESTBeaconManager.h>

@interface RangingViewController () <ESTBeaconManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *connectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconUUIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconRangeLabel;

@property (strong, nonatomic) IBOutlet UIButton *connectBT;
@property (strong, nonatomic) IBOutlet UIButton *disconnectBT;

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
    
    /*Set labels and buttons*/
    [self.connectBT setEnabled:NO];
    [self.disconnectBT setEnabled:NO];
    [self.connectionLabel setText:@"Not connected"];
    [self.beaconUUIDLabel setText:@"No ranged Beacon"];
    [self.beaconRangeLabel setText:@"Range : Status unknown"];
    
    
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
            NSLog(@"beacon %d : IMMEDIATE", i);//TEST
            [self.connectBT setEnabled:YES];
            [self.beaconRangeLabel setText:@"Range : Immediate proximity"];
        }else if (rangedBeacon.proximity == CLProximityNear)
        {
            NSLog(@"beacon %d : NEAR", i);//TEST
            [self.connectBT setEnabled:NO];
            [self.beaconRangeLabel setText:@"Range : Near proximity"];
        }else if (rangedBeacon.proximity == CLProximityFar)
        {
            NSLog(@"beacon %d : FAR", i);//TEST
            [self.connectBT setEnabled:NO];
            [self.beaconRangeLabel setText:@"Range : Far proximity"];
        }else
        {
            NSLog(@"beacon %d : UNKNOWN", i);//TEST
            [self.connectBT setEnabled:NO];
            [self.beaconRangeLabel setText:@"Range : Status unknown"];
        }
        i++;
    }
    
    self.beaconsArray = beacons;
    if(self.beaconsArray.count != 0)
    {
      self.beacon = self.beaconsArray[0];
    }
    NSLog(@"beacon uuid : %@", self.beacon.proximityUUID);//TEST
    
    /*Set UUID Label*/
    NSString *beaconUUIDString = [[NSString alloc] initWithFormat:@"%@", self.beacon.proximityUUID];
    [self.beaconUUIDLabel setText:beaconUUIDString];
    
    /*If not connected to any beacon, disable disconnect button and set the connection label*/
    if (self.beacon.isConnected == NO)
    {
        [self.disconnectBT setEnabled:NO];
        [self.connectionLabel setText:@"Not connected"];
    }/*If connected to a beacon, set the connection label*/
    else if (self.beacon.isConnected == YES)
    {
        [self.disconnectBT setEnabled:YES];
        [self.connectionLabel setText:@"Is connected"];
    }
    
}

- (IBAction)connectBeacon:(id)sender
{
    /*Connect to ranged beacon*/
    [self.beacon connectToBeacon];
    
    //TEST
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
    
    //TEST
    if (self.beacon.isConnected == YES)
    {
        NSLog(@"is connected");
    }else if (self.beacon.isConnected == YES)
    {
       NSLog(@"is NOT connected");
    }
}



@end
