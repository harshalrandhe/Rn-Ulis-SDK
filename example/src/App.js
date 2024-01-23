import * as React from "react";

import {
  Alert,
  KeyboardAvoidingView,
  NativeEventEmitter,
  NativeModules,
  Platform,
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
} from "react-native";

import { OutlinedTextField } from "rn-material-ui-textfield";

import { ScrollView } from "react-native";
import { open } from "rn-pay-sdk";

export default function App() {
  const telrpayEvents = new NativeEventEmitter(NativeModules.RnUlisSdk);

  React.useEffect(() => {
    telrpayEvents.addListener("Telr::PAYMENT_SUCCESS", (data) => {
      console.log("PAYMENT_SUCCESS", data);
      setAPIResponse(data);
      Alert.alert("Transactions successful!");
    });
    telrpayEvents.addListener("Telr::PAYMENT_ERROR", (data) => {
      console.log("PAYMENT_ERROR", data);
      setAPIResponse(data);
      Alert.alert("Transactions error!");
    });
    telrpayEvents.addListener("Telr::PAYMENT_CANCELLED", (data) => {
      console.log("PAYMENT_CANCELLED", data);
      setAPIResponse(data);
      Alert.alert("Transactions cancel!");
    });

    setPIN("123456");

    return () => {
      telrpayEvents.removeAllListeners("Telr::PAYMENT_SUCCESS");
      telrpayEvents.removeAllListeners("Telr::PAYMENT_ERROR");
      telrpayEvents.removeAllListeners("Telr::PAYMENT_CANCELLED");
    };
  }, []);

  const generateOrderId = () => {
    let numbers = "ORD" + Math.floor(10000000 + Math.random() * 89999999);
    return numbers;
  };

  // Merchant keys
  const [MerchantKey, setMerchantKey] = React.useState("live-SH10ZQM18IQ");
  const [MerchantSecret, setMerchantSecret] = React.useState("sec-IW101K818CW");

  // Customer Details
  const [Name, setName] = React.useState("PayTM USER");
  const [Email, setEmail] = React.useState("rasibas152@kameili.com");
  const [Mobile, setMobile] = React.useState("5353453533");
  const [MobileCode, setMobileCode] = React.useState("91");

  // Billing Details
  const [AddressLine1, setAddressLine1] = React.useState("distance");
  const [AddressLine2, setAddressLine2] = React.useState("");
  const [Country, setCountry] = React.useState("india");
  const [City, setCity] = React.useState("Kolkata");
  const [PIN, setPIN] = React.useState("");
  const [Province, setProvince] = React.useState("Abu Dhabi");

  //Shipping Details
  const [ShipAddressLine1, setShipAddressLine1] = React.useState("");
  const [ShipAddressLine2, setShipAddressLine2] = React.useState("");
  const [ShipCountry, setShipCountry] = React.useState("");
  const [ShipCity, setShipCity] = React.useState("");
  const [ShipPIN, setShipPIN] = React.useState("");
  const [ShipProvince, setShipProvince] = React.useState("");

  // Order Details
  const [OrderId, setOrderId] = React.useState("ORD168085");
  const [Amount, setAmount] = React.useState("100.00");
  const [Currency, setCurrency] = React.useState("AED");
  const [Description, setDescription] = React.useState("TShirt");
  const [ReturnUrl, setReturnUrl] = React.useState(
    "https://ulis.live:8081/status"
  );

  // Merchant Url
  const [SuccessUrl, setSuccessUrl] = React.useState(
    "https://ulis.live:8081/status"
  );
  const [CancelUrl, setCancelUrl] = React.useState(
    "https://ulis.live:8081/status"
  );
  const [FailureUrl, setFailureUrl] = React.useState(
    "https://ulis.live:8081/status"
  );

  //Others
  const [Environment, setEnvironment] = React.useState("dev");
  const [MobileSdk, setMobileSdk] = React.useState(1);
  const [TxnClass, setTxnClass] = React.useState("ecom");

  const [APIResponse, setAPIResponse] = React.useState("");

  var options = {
    merchantKey: MerchantKey,
    merchantSecret: MerchantSecret,
    customer_details: {
      name: Name,
      email: Email,
      mobile: Mobile,
      mobile_code: MobileCode,
    },
    productDetails: {
      vendorName: "Nescafe",
      vendorMobile: "1122334455",
      productName: "Classic Instant Coffee",
      productPrice: 125.0,
      currency: "AED",
      image:
        "https://assetscdn1.paytm.com/images/catalog/product/A/AP/APPSCOTT-INTERNSWIT61083A52CCB4C/1562907534025_1..jpg?imwidth=320&impolicy=hq",
    },
    billing_details: {
      address_line1: AddressLine1,
      address_line2: AddressLine2,
      country: Country,
      city: City,
      pin: PIN,
      province: Province,
    },
    shipping_details: {
      address_line1: ShipAddressLine1,
      address_line2: ShipAddressLine2,
      country: ShipCountry,
      city: ShipCity,
      pin: ShipPIN,
      province: ShipProvince,
    },
    order_details: {
      order_id: generateOrderId(),
      amount: Amount,
      currency: Currency,
      description: Description,
      return_url: ReturnUrl,
    },
    merchant_urls: {
      success: SuccessUrl,
      cancel: CancelUrl,
      failure: FailureUrl,
    },
    transaction: {
      class: TxnClass,
      integration: "MOBILESDK",
    },
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : null}
      keyboardVerticalOffset={Platform.OS === "ios" ? 40 : 0}
    >
      <ScrollView>
        <View style={styles.container}>
          <Text style={styles.headerText}>Transaction Mode</Text>

          <OutlinedTextField
            label="Environment"
            value={Environment}
            onChangeText={(value) => {
              setEnvironment(value);
            }}
          />

          <Text style={styles.headerText}>Merchant Key</Text>

          <OutlinedTextField
            label="Merchant Key"
            value={MerchantKey}
            onChangeText={(value) => {
              setMerchantKey(value);
            }}
          />

          <OutlinedTextField
            label="Merchant Secret"
            value={MerchantSecret}
            onChangeText={(value) => {
              setMerchantSecret(value);
            }}
          />

          <Text style={styles.headerText}>Customer Details</Text>

          <OutlinedTextField
            label="Name"
            value={Name}
            onChangeText={(value) => {
              setName(value);
            }}
          />

          <OutlinedTextField
            label="Email"
            value={Email}
            onChangeText={(value) => {
              setEmail(value);
            }}
          />

          <View style={{ flexDirection: "row" }}>
            <OutlinedTextField
              label="Country code"
              value={MobileCode}
              onChangeText={(value) => {
                setMobileCode(value);
              }}
              containerStyle={{ flex: 0.3 }}
            />
            <View style={{ width: 10 }} />
            <OutlinedTextField
              label="Mobile"
              value={Mobile}
              onChangeText={(value) => {
                setMobile(value);
              }}
              containerStyle={{ flex: 1 }}
            />
          </View>

          <Text style={styles.headerText}>Billing Details</Text>

          <OutlinedTextField
            label="AddressLine1"
            value={AddressLine1}
            onChangeText={(value) => {
              setAddressLine1(value);
            }}
          />

          <OutlinedTextField
            label="AddressLine2"
            value={AddressLine2}
            onChangeText={(value) => {
              setAddressLine2(value);
            }}
          />

          <OutlinedTextField
            label="Country"
            value={Country}
            onChangeText={(value) => {
              setCountry(value);
            }}
          />

          <OutlinedTextField
            label="City"
            value={City}
            onChangeText={(value) => {
              setCity(value);
            }}
          />

          <OutlinedTextField
            label="PIN"
            value={PIN}
            onChangeText={(value) => {
              setPIN(value);
            }}
          />

          <OutlinedTextField
            label="Province"
            value={Province}
            onChangeText={(value) => {
              setProvince(value);
            }}
          />

          <Text style={styles.headerText}>Shipping Details</Text>

          <OutlinedTextField
            label="ShipAddressLine1"
            value={ShipAddressLine1}
            onChangeText={(value) => {
              setShipAddressLine1(value);
            }}
          />

          <OutlinedTextField
            label="ShipAddressLine2"
            value={ShipAddressLine2}
            onChangeText={(value) => {
              setShipAddressLine2(value);
            }}
          />

          <OutlinedTextField
            label="ShipCountry"
            value={ShipCountry}
            onChangeText={(value) => {
              setShipCountry(value);
            }}
          />

          <OutlinedTextField
            label="ShipCity"
            value={ShipCity}
            onChangeText={(value) => {
              setShipCity(value);
            }}
          />

          <OutlinedTextField
            label="ShipPIN"
            value={ShipPIN}
            onChangeText={(value) => {
              setShipPIN(value);
            }}
          />

          <OutlinedTextField
            label="ShipProvince"
            value={ShipProvince}
            onChangeText={(value) => {
              setShipProvince(value);
            }}
          />

          <Text style={styles.headerText}>Order Details</Text>

          {/* <OutlinedTextField
            label="OrderId"
            value={OrderId}
            onChangeText={(value) => {
              setOrderId(value);
            }}
          /> */}

          <OutlinedTextField
            label="Amount"
            value={Amount}
            onChangeText={(value) => {
              setAmount(value);
            }}
          />

          <OutlinedTextField
            label="Currency"
            value={Currency}
            onChangeText={(value) => {
              setCurrency(value);
            }}
          />

          <OutlinedTextField
            label="Description"
            value={Description}
            onChangeText={(value) => {
              setDescription(value);
            }}
          />

          <OutlinedTextField
            label="ReturnUrl"
            value={ReturnUrl}
            onChangeText={(value) => {
              setReturnUrl(value);
            }}
          />

          <Text style={styles.headerText}>Merchant Urls</Text>

          <OutlinedTextField
            label="SuccessUrl"
            value={SuccessUrl}
            onChangeText={(value) => {
              setSuccessUrl(value);
            }}
          />

          <OutlinedTextField
            label="CancelUrl"
            value={CancelUrl}
            onChangeText={(value) => {
              setCancelUrl(value);
            }}
          />

          <OutlinedTextField
            label="FailureUrl"
            value={FailureUrl}
            onChangeText={(value) => {
              setFailureUrl(value);
            }}
          />

          {/* ---------------------------------------------------- */}

          <TouchableHighlight
            style={{
              borderColor: "gray",
              borderWidth: 0.8,
              borderRadius: 5,
              padding: 20,
              backgroundColor: "lightgreen",
              alignItems: "center",
              marginTop: 20,
            }}
            onPress={() => {
              console.log("Key>>>>", options.merchantKey);
              console.log("Secret>>>>", options.merchantSecret);

              open(
                options,
                (response) => {
                  console.log("Success", response);
                  setAPIResponse(response);
                  Alert.alert(response.message);
                },
                (error) => {
                  console.log("Error", error);
                  setAPIResponse(error);
                  Alert.alert(error.message);
                }
              );

              // NativeModules.RnUlisSdk.open(options);
            }}
          >
            <Text>PAY</Text>
          </TouchableHighlight>

          <Text style={{ marginVertical: 20 }}>
            Response: {JSON.stringify(APIResponse)}
          </Text>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: "column",
    padding: 30,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  headerText: {
    color: "blue",
    marginVertical: 15,
  },
  textInputStyles: {
    color: "green",
    fontSize: 15,
  },
  otherTextInputProps: {
    fontSize: 15,
  },
});

function useRef() {
  throw new Error("Function not implemented.");
}
