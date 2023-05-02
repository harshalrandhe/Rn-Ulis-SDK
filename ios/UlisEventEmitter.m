//
//  UlisEventEmitter.m
//  RnUlisSdk
//
//  Created by Hydrus on 28/04/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(UlisEventEmitter, RCTEventEmitter)

RCT_EXTERN_METHOD(supportedEvents)

@end
