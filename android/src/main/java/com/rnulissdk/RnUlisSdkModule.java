package com.rnulissdk;

import androidx.annotation.NonNull;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import org.json.JSONObject;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import com.google.gson.Gson;
import com.ulisfintech.telrpay.helper.PaymentData;
import com.ulisfintech.telrpay.helper.SyncMessage;
import com.ulisfintech.telrpay.ui.Gateway;
import com.ulisfintech.telrpay.ui.GatewaySecureCallback;

@ReactModule(name = RnUlisSdkModule.NAME)
public class RnUlisSdkModule extends ReactContextBaseJavaModule
    implements ActivityEventListener, GatewaySecureCallback {

  public static final String NAME = "RnUlisSdk";
  public static final String MAP_KEY_ERROR_CODE = "code";
  public static final String MAP_KEY_ERROR_DESC = "message";
  public static final String MAP_KEY_DATA = "data";
  Promise promise = null;
  ReactApplicationContext reactContext;

  public RnUlisSdkModule(ReactApplicationContext reactContext) {
    super(reactContext);

    this.reactContext = reactContext;
    reactContext.addActivityEventListener(this);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void multiply(double a, double b, Promise promise) {
    promise.resolve(a * b);
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void add(double a, double b, Promise promise) {
    promise.resolve(a + b);
  }

  @ReactMethod
  public void open(ReadableMap options, Promise promise) {

    this.promise = promise;

    Activity currentActivity = getCurrentActivity();

    try {

      JSONObject optionsJSON = Utils.readableMapToJson(options);

      Gateway.startReceivingPaymentActivity(currentActivity, optionsJSON);

    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    // After Result
    Gateway.handleSecureResult(requestCode, resultCode, data, this);
  }

  @Override
  public void onNewIntent(Intent intent) {

  }

  @Override
  public void onTransactionComplete(SyncMessage syncMessage) {

    Gson gson = new Gson();

    if (syncMessage.status) {

      JSONObject paymentDataJson = new JSONObject();
      try {
        paymentDataJson.put(MAP_KEY_ERROR_CODE, syncMessage.status);
        paymentDataJson.put(MAP_KEY_ERROR_DESC, syncMessage.message);
        paymentDataJson.put(MAP_KEY_DATA, new JSONObject(gson.toJson(syncMessage)));
      } catch (Exception e) {
        e.printStackTrace();
      }
      sendEvent("Telr::PAYMENT_SUCCESS", Utils.jsonToWritableMap(paymentDataJson));

    } else {

      WritableMap errorParams = Arguments.createMap();
      JSONObject paymentDataJson = new JSONObject();
      try {
        paymentDataJson.put(MAP_KEY_ERROR_CODE, syncMessage.status);
        paymentDataJson.put(MAP_KEY_ERROR_DESC, syncMessage.message);
        paymentDataJson.put(MAP_KEY_DATA, new JSONObject(gson.toJson(syncMessage)));
      } catch (Exception e) {
        e.printStackTrace();
      }
      sendEvent("Telr::PAYMENT_ERROR", Utils.jsonToWritableMap(paymentDataJson));
    }
  }

  @Override
  public void onTransactionCancel(SyncMessage syncMessage) {
    Gson gson = new Gson();
    WritableMap errorParams = Arguments.createMap();
    JSONObject paymentDataJson = new JSONObject();
    try {
      paymentDataJson.put(MAP_KEY_ERROR_CODE, syncMessage.status);
      paymentDataJson.put(MAP_KEY_ERROR_DESC, syncMessage.message);
      paymentDataJson.put(MAP_KEY_DATA, new JSONObject(gson.toJson(syncMessage)));
    } catch (Exception e) {
      e.printStackTrace();
    }
    sendEvent("Telr::PAYMENT_CANCELLED", Utils.jsonToWritableMap(paymentDataJson));
  }

  private void sendEvent(String eventName, WritableMap params) {
    reactContext
        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params);
  }

  @ReactMethod
  public void addListener(String eventName) {
    // Keep: Required for RN built in Event Emitter Calls.
  }

  @ReactMethod
  public void removeListeners(int count) {
    // Keep: Required for RN built in Event Emitter Calls.
  }

}
