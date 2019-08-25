//
//  LocationService.m
//  HelloCordova
//
//  Created by Asad Khan on 23/08/2019.
//

#import "LocationService.h"


@implementation LocationService

-(instancetype)init{

    self = [super init];
    
    if(self){
        self.locationManager = [[CLLocationManager alloc] init];
    

        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ){
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            [self.locationManager requestAlwaysAuthorization];
        
        }
    
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // The accuracy of the location data
        self.locationManager.distanceFilter = 100; // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        self.locationManager.delegate = self;
    }
    
    return self;
}

-(void)startUpdatingLocation{
    
    NSLog(@"Starting location");
    [self.locationManager startUpdatingLocation];
    
}

-(void)stopUpdatingLocation{
    
    NSLog(@"Stop location");
    [self.locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.lastLocation = locations.lastObject;
    
    [self updateLocation:self.lastLocation];
}

-(void)updateLocation:(CLLocation*)location{
    
    if([self.delegate respondsToSelector:@selector(tracingLocation:)]){
        [self.delegate tracingLocation:location];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // do on error
    
    if([self.delegate respondsToSelector:@selector(tracingLocationDidFailWithError:)]){
        [self.delegate tracingLocationDidFailWithError:error];
    }
    
    
}

@end
