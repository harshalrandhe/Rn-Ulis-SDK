import { NativeEventEmitter, NativeModules, Platform, } from 'react-native';

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

// export function multiply(a: number, b: number): Promise<number> {
// return RnUlisSdk.multiply(a, b);
// }


const telrpayEvents = new NativeEventEmitter(NativeModules.RnUlisSdk);

const removeSubscriptions = () => {
  telrpayEvents.removeAllListeners('Telr::PAYMENT_SUCCESS');
  telrpayEvents.removeAllListeners('Telr::PAYMENT_ERROR');
  telrpayEvents.removeAllListeners('Telr::PAYMENT_CANCELLED');
};

export function open(options: any, successCallback: any, errorCallback: any): Promise<any> {

  console.log(">>>>>>>>>", NativeModules.RnUlisSdk)

  return new Promise(function (resolve, reject) {

    telrpayEvents.addListener('Telr::PAYMENT_SUCCESS', (data: any) => {
      console.log("Success: ")
      let resolveCallback = successCallback || resolve;
      resolveCallback(data);
      removeSubscriptions();
    });
    telrpayEvents.addListener('Telr::PAYMENT_ERROR', (data: any) => {
      console.log("Error: ")
      let rejectCallback = errorCallback || reject;
      rejectCallback(data);
      removeSubscriptions();
    });
    telrpayEvents.addListener('Telr::PAYMENT_CANCELLED', (data: any) => {
      console.log("Cancelled: ")
      let rejectCallback = errorCallback || reject;
      rejectCallback(data);
      removeSubscriptions();
    });

    RnUlisSdk.open(options);
  });
}

