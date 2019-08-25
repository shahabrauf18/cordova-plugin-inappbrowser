//
//  LocationService.h
//  HelloCordova
//
//  Created by Asad Khan on 23/08/2019.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol LocationServiceDelegate<NSObject>
-(void)tracingLocation:(CLLocation*)currentLocation;
-(void)tracingLocationDidFailWithError:(NSError*)error;

@end

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property(strong, nonnull)CLLocationManager *locationManager;

@property(strong, nonnull)CLLocation *lastLocation;

@property(nonatomic, weak)id <LocationServiceDelegate>  delegate;

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;
-(instancetype)init;
@end

NS_ASSUME_NONNULL_END
