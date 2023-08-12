#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>


@interface RCT_EXTERN_MODULE(RnUlisSdk, RCTEventEmitter)

// RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
//                 withResolver:(RCTPromiseResolveBlock)resolve
//                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(open:(NSDictionary *)options)

//RCT_EXPORT_METHOD(open : (NSDictionary *)options) {
//
//
//
//    NSString *keyID = (NSString *)[options objectForKey:@"merchantKey"];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//
//    });
//
//
//    [self sendEventWithName:@"Telr::PAYMENT_SUCCESS" body:@ [keyID]];
//}

//+ (BOOL)requiresMainQueueSetup
//{
//  return NO;
//}

@end
