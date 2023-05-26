'use strict';

import { NativeModules, NativeEventEmitter } from 'react-native';

const paymentCallbackEvents = new NativeEventEmitter(NativeModules.RazorpayEventEmitter);

const removeSubscriptions = () => {
    paymentCallbackEvents.removeAllListeners('Telr::PAYMENT_SUCCESS');
    paymentCallbackEvents.removeAllListeners('Telr::PAYMENT_ERROR');
    paymentCallbackEvents.removeAllListeners('Telr::PAYMENT_CANCELLED');
};

class ULISCheckout {
    static open(options, successCallback, errorCallback) {
        return new Promise(function (resolve, reject) {
            paymentCallbackEvents.addListener('Telr::PAYMENT_SUCCESS', (data) => {
                let resolveFn = successCallback || resolve;
                resolveFn(data);
                removeSubscriptions();
            });
            paymentCallbackEvents.addListener('Telr::PAYMENT_ERROR', (data) => {
                let rejectFn = errorCallback || reject;
                rejectFn(data);
                removeSubscriptions();
            });
            NativeModules.RnUlisSdk.open(options);
        });
    }
}

export default ULISCheckout;