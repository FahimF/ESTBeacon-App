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
@property (strong, nonatomic) IBOutlet UILabel *beaconRangeLabel;
@property (strong, nonatomic) IBOutlet UITextView *UUIDText;

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
    [self.UUIDText setText:@"No ranged Beacon"];
    [self.beaconRangeLabel setText:@"Range : Status unknown"];
    
    
    /*Alloc the UUID we would like to range/connect too*/
    
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    /*Create manager instance*/
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    //    self.beaconManager.avoidUnknowsnStateBeacons = YES;
    
    /*Init region & start ranging : ranging is necessary to connect to the ranged beacon!*/
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:UUID identifier:@"ProximityUUID"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidDisappear:(BOOL)animated
{
    /*Stops ranging and disconnects from Beacon when we switch view*/
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.beacon disconnectBeacon];
    
    [super viewDidDisappear:animated];
}

#pragma ranging

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
    NSString *beaconUUIDString = [[NSString alloc] initWithFormat:@"UUID : %@", self.beacon.proximityUUID];
    [self.UUIDText setText:beaconUUIDString];
    
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

#pragma Connection

/*Connect to a Beacon when pressing a button*/
- (IBAction)connectBeacon:(id)sender
{
    /*Connect to ranged beacon*/
    [self.beacon connectToBeacon];
}

/*Disconnect from a Beacon when pressing a button*/
- (IBAction)disconnectBeacon:(id)sender
{
    /*Disconnect from Beacon when Button is pressed*/
    [self.beacon disconnectBeacon];
    /*Start ranging again*/
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

#pragma UUID

- (IBAction)getProximityUUID:(id)sender
{
    [self.beacon readBeaconProximityUUIDWithCompletion:^(NSString *UUID, NSError *error){
        NSLog(@"UUID : %@", self.beacon.proximityUUID);
    }];
}

- (IBAction)setProximityUUID:(id)sender
{
    if (self.beacon.isConnected == YES) {
//        B9407F30-F5F8-466E-AFF9-25556B57FE6D
        [self.beacon writeBeaconProximityUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" withCompletion:nil];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma Major

- (IBAction)getMajor:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconMajorWithCompletion:^(unsigned short Major, NSError *error){
            NSLog(@"Major : %@", self.beacon.major);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

- (IBAction)setMajor:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon writeBeaconMajor:0 withCompletion:nil];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma Minor

- (IBAction)getMinor:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconMinorWithCompletion:^(unsigned short Minor, NSError *error){
            NSLog(@"Minor : %@", self.beacon.minor);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

- (IBAction)setMinor:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon writeBeaconMinor:2 withCompletion:nil];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma AdvInterval

- (IBAction)getInterval:(id)sender
{
    /*Stop ranging*/
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    /*If connected, get some Beacon values*/
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconAdvIntervalWithCompletion:^(unsigned short AdvInterval, NSError *error) {
            NSLog(@"Adv interval : %@", self.beacon.advInterval);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

- (IBAction)setInterval:(id)sender
{
    /*If connected, set some Beacon values*/
    if (self.beacon.isConnected == YES) {
        [self.beacon writeBeaconAdvInterval:500 withCompletion:nil];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma Power

- (IBAction)getPower:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconPowerWithCompletion:^(ESTBeaconPower Power, NSError *error){
            NSLog(@"Power : %@", self.beacon.power);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

- (IBAction)setPower:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon writeBeaconPower:0 withCompletion:nil];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma Battery

- (IBAction)getBattery:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconBatteryWithCompletion:^(unsigned short Battery, NSError *error) {
            NSLog(@"Battery level : %@", self.beacon.batteryLevel);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

#pragma Firmware

- (IBAction)getFirmware:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconFirmwareVersionWithCompletion:^(NSString *firmware, NSError *error){
            NSLog(@"Firmware : %@", self.beacon.firmwareVersion);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
}

- (IBAction)checkFirmwareUpdate:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon checkFirmwareUpdateWithCompletion:^(BOOL updateAvailable, ESTBeaconUpdateInfo *updateInfo, NSError *error){
            NSLog(@"Firmware update available : %d", self.beacon.firmwareState);
            NSLog(@"Firmware update info : %d", self.beacon.firmwareUpdateInfo);
        }];
    }
    else if (self.beacon.isConnected == NO)
    {
        NSLog(@"Can't get any properties, your are not connected!");//TEST
    }
    
    /*How to tell what is what with the NSLogs from "checkFirmwareUpdate":
     * firmwareState :
     *
     * typedef enum : int
     * {
     * ESTBeaconFirmwareStateBoot,             ==> NSLog output : 0
     * ESTBeaconFirmwareStateApp               ==> NSLog output : 1
     * } ESTBeaconFirmwareState;
     *
     * firmwareUpdateInfo :
     *
     * typedef enum : int
     * {
     * ESTBeaconFirmwareUpdateNone,            ==> NSLog output : 0
     * ESTBeaconFirmwareUpdateAvailable,       ==> NSLog output : 1
     * ESTBeaconFirmwareUpdateNotAvailable     ==> NSLog output : 2
     * } ESTBeaconFirmwareUpdate;
     *
     */
}

- (IBAction)updateFirmware:(id)sender
{
    #warning TODO (updateFirmware:)
}

#pragma Hardware

- (IBAction)getHardware:(id)sender
{
    if (self.beacon.isConnected == YES) {
        [self.beacon readBeaconHardwareVersionWithCompletion:^(NSString *Hardware, NSError *error){
            NSLog(@"Hardware : %@", self.beacon.hardwareVersion);
        }];
    }
}

@end
