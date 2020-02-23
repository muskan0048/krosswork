package in.appyflow.splash;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.EditText;
import android.widget.Toast;


import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "flutter.appyflow.in.channel";
//    private PayUmoneySdkInitializer.PaymentParam mPaymentParams;


    MethodChannel.Result resultBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        // TODO

                        resultBack = result;

                        if (call.method.equals("showPaymentView")) {

                            Log.i("Hello", call.arguments.toString());

                            String txnId = call.argument("txnId").toString();
                            String phone = call.argument("userPhone").toString().trim();
                            String productName = call.argument("pInfo").toString().trim();
                            String firstName = call.argument("userName").toString();
                            String email = call.argument("userEmail").toString().trim();

                            startActivityForResult(new Intent(getApplicationContext(), RazorPayTestActivirty.class).putExtra("txnId", txnId)
                                    .putExtra("userPhone", phone)
                                    .putExtra("pInfo", productName)
                                    .putExtra("email", email)
                                    .putExtra("firstName", firstName)
                                    .putExtra("amount", Double.parseDouble(call.argument("amount").toString().trim()))
                                    , 101
                            );

//                            launchPayUMoneyFlow(call);

                        }
                    }
                });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 101 && resultCode == 101 && data!=null) {

            HashMap<String, Object> hashMap = new HashMap<>();

            hashMap.put("status", data.getIntExtra("status", 2));
            hashMap.put("paymentId",data.getStringExtra("paymentId"));

            resultBack.success(hashMap);

        }else if(requestCode==101){

            HashMap<String, Object> hashMap = new HashMap<>();

            hashMap.put("status", 1);
            hashMap.put("paymentId","");

            resultBack.success(hashMap);

        }

    }

    //    private void launchPayUMoneyFlow(MethodCall call) {
//
//
//        PayUmoneyConfig payUmoneyConfig = PayUmoneyConfig.getInstance();
//
//        //Use this to set your custom text on result screen button
//        payUmoneyConfig.setDoneButtonText("Done Payment !!");
//
//        //Use this to set your custom title for the activity
//        payUmoneyConfig.setPayUmoneyActivityTitle("Splash WorkSpaces");
//
//        payUmoneyConfig.disableExitConfirmation(false);
//
//        PayUmoneySdkInitializer.PaymentParam.Builder builder = new PayUmoneySdkInitializer.PaymentParam.Builder();
//
//        double amount = 10.0;
//
////        try {
////            amount = Double.parseDouble(amount_et.getText().toString());
////
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
//
//        String txnId = call.argument("txnId").toString();
//        String phone = call.argument("userPhone").toString().trim();
//        String productName =call.argument("pInfo").toString().trim();
//        String firstName = call.argument("userName").toString();
//        String email = call.argument("userEmail").toString().trim();
//        String udf1 = "";
//        String udf2 = "";
//        String udf3 = "";
//        String udf4 = "";
//        String udf5 = "hi";
//        String udf6 = "";
//        String udf7 = "";
//        String udf8 = "";
//        String udf9 = "";
//        String udf10 = "";
//
//        AppEnvironment appEnvironment = AppEnvironment.PRODUCTION;
//
//        builder.setAmount(amount)
//                .setTxnId(txnId)
//                .setPhone(phone)
//                .setProductName(productName)
//                .setFirstName(firstName)
//                .setEmail(email)
//                .setsUrl(appEnvironment.surl())
//                .setfUrl(appEnvironment.furl())
//                .setUdf1(udf1)
//                .setUdf2(udf2)
//                .setUdf3(udf3)
//                .setUdf4(udf4)
//                .setUdf5(udf5)
//                .setUdf6(udf6)
//                .setUdf7(udf7)
//                .setUdf8(udf8)
//                .setUdf9(udf9)
//                .setUdf10(udf10)
//                .setIsDebug(appEnvironment.debug())
//                .setKey(appEnvironment.merchant_Key())
//                .setMerchantId(appEnvironment.merchant_ID());
//
//        try {
//            mPaymentParams = builder.build();
//
//            /*
//             * Hash should always be generated from your server side.
//             * */
//            String merchantHash=call.argument("hash").toString();
//            if (merchantHash.isEmpty() || merchantHash.equals("")) {
//                Toast.makeText(MainActivity.this, "Could not generate hash", Toast.LENGTH_SHORT).show();
//            } else {
//                mPaymentParams.setMerchantHash(merchantHash);
//
//
//                try {
//                    PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams, MainActivity.this, R.style.AppTheme_default, true);
//                } catch (Exception e) {
//                    Log.i("Error",e.getMessage());
//                }
//
////
////                if (AppPreference.selectedTheme != -1) {
////                    PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams, MainActivity.this, AppPreference.selectedTheme, mAppPreference.isOverrideResultScreen());
////                } else {
////
////                }
//            }
//
//            /*            *//**
//             * Do not use below code when going live
//             * Below code is provided to generate hash from sdk.
//             * It is recommended to generate hash from server side only.
//             * */
//           /* mPaymentParams = calculateServerSideHashAndInitiatePayment1(mPaymentParams);
//
//           if (AppPreference.selectedTheme != -1) {
//                PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams,MainActivity.this, AppPreference.selectedTheme,mAppPreference.isOverrideResultScreen());
//            } else {
//                PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams,MainActivity.this, R.style.AppTheme_default, mAppPreference.isOverrideResultScreen());
//            }*/
//
//        } catch (Exception e) {
//            // some exception occurred
//            Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
////            payNowButton.setEnabled(true);
//        }
//    }
}
