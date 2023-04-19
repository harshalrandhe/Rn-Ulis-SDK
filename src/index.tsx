import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'rn-ulis-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const RnUlisSdk = NativeModules.RnUlisSdk
  ? NativeModules.RnUlisSdk
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

export function multiply(a: number, b: number): Promise<number> {
  return RnUlisSdk.multiply(a, b);
}

export function add(a: number, b: number): Promise<number> {
  return RnUlisSdk.add(a, b);
}

// export function open(a: any): Promise<any> {
//   return RnUlisSdk.open(a);
// }

const telrpayEvents = new NativeEventEmitter(NativeModules.TelrpayEventEmitter);

const removeSubscriptions = () => {
  telrpayEvents.removeAllListeners('Telrpay::PAYMENT_SUCCESS');
  telrpayEvents.removeAllListeners('Telrpay::PAYMENT_ERROR');
  telrpayEvents.removeAllListeners('Telrpay::EXTERNAL_WALLET_SELECTED');
};


export function open(options: any, successCallback: any, errorCallback: any): Promise<any> {
  return new Promise(function (resolve, reject) {
    telrpayEvents.addListener('Telrpay::PAYMENT_SUCCESS', (data: any) => {
      let resolveCallback = successCallback || resolve;
      resolveCallback(data);
      removeSubscriptions();
    });
    telrpayEvents.addListener('Telrpay::PAYMENT_ERROR', (data: any) => {
      let rejectCallback = errorCallback || reject;
      rejectCallback(data);
      removeSubscriptions();
    });
    telrpayEvents.addListener('Telrpay::PAYMENT_CANCEL', (data: any) => {
      let rejectCallback = errorCallback || reject;
      rejectCallback(data);
      removeSubscriptions();
    });

    RnUlisSdk.open(options);
  });
}
