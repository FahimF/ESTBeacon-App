//
//  Monitoring.m
//  
//
//  Created by Yvan Siggen on 01.05.14.
//
//

#import "Monitoring.h"
#import <EstimoteSDK/ESTBeaconManager.h>

@interface Monitoring () <ESTBeaconManagerDelegate>

@end

@implementation Monitoring

- (void)initLocationManager
{
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
//    self.beaconManager = [[ESTBeaconManager alloc] init];
//    self.beaconManager.delegate = self;
    
//    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:UUID identifier:@"EstimoteUUID"];
//    [self.beaconManager startMonitoringForRegion:_beaconRegion];
}

@end
