//package in.appyflow.splash;
//
//import android.app.AlertDialog;
//import android.content.DialogInterface;
//import android.content.Intent;
//import android.support.v7.app.AppCompatActivity;
//import android.os.Bundle;
//import android.util.Log;
//import android.widget.Toast;
//
//import com.payumoney.core.PayUmoneyConfig;
//import com.payumoney.core.PayUmoneySdkInitializer;
//import com.payumoney.core.entity.TransactionResponse;
//import com.payumoney.sdkui.ui.utils.PayUmoneyFlowManager;
//import com.payumoney.sdkui.ui.utils.ResultModel;
//
//
//public class PaymentActivity extends AppCompatActivity {
//
//
//    private PayUmoneySdkInitializer.PaymentParam mPaymentParams;
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_payment);
//
//        launchPayUMoneyFlow();
//    }
//
//    private void launchPayUMoneyFlow() {
//
//        Log.i("Hello","I am Called");
//
//        PayUmoneyConfig payUmoneyConfig = PayUmoneyConfig.getInstance();
//
//        //Use this to set your custom text on result screen button
//        payUmoneyConfig.setDoneButtonText("Done Payment !!");
//
//        //Use this to set your custom title for the activity
//        payUmoneyConfig.setPayUmoneyActivityTitle("Splash WorkSpaces");
//
//
//
//
//
//        payUmoneyConfig.disableExitConfirmation(false);
//
//        PayUmoneySdkInitializer.PaymentParam.Builder builder = new PayUmoneySdkInitializer.PaymentParam.Builder();
//
//
//
////        try {
////            amount = Double.parseDouble(amount_et.getText().toString());
////
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
//
//        Intent i=getIntent();
//
//        String txnId = i.getStringExtra("txnId").toString();
//        String phone = i.getStringExtra("userPhone").toString().trim();
//        String productName =i.getStringExtra("pInfo").toString().trim();
//        String firstName = i.getStringExtra("firstName").toString();
//        double amount=i.getDoubleExtra("amount",100.0);
//        String email = i.getStringExtra("email").toString().trim();
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
//        Log.i("Hello","I am Here");
//
//        AppEnvironment appEnvironment = AppEnvironment.SANDBOX;
//
//        Log.i("Hello",udf5+"");
//
//        try {
//            builder.setAmount(amount)
//                    .setTxnId(txnId)
//                    .setPhone(phone)
//                    .setProductName(productName)
//                    .setFirstName(firstName)
//                    .setEmail(email)
//                    .setsUrl(appEnvironment.surl())
//                    .setfUrl(appEnvironment.furl())
//                    .setUdf1(udf1)
//                    .setUdf2(udf2)
//                    .setUdf3(udf3)
//                    .setUdf4(udf4)
//                    .setUdf5(udf5)
//                    .setUdf6(udf6)
//                    .setUdf7(udf7)
//                    .setUdf8(udf8)
//                    .setUdf9(udf9)
//                    .setUdf10(udf10)
//                    .setIsDebug(appEnvironment.debug())
//                    .setKey(appEnvironment.merchant_Key())
//                    .setMerchantId(appEnvironment.merchant_ID());
//
//        }catch (Exception e){
//
//            Log.d("Hello",e.getMessage());
//
//        }
//
//
//        Log.d("Hello",builder.build().toString());
//
//        try {
//            mPaymentParams = builder.build();
//
//
//
//            /*
//             * Hash should always be generated from your server side.
//             * */
//            String merchantHash=i.getStringExtra("hash").toString();
//            if (merchantHash.isEmpty() || merchantHash.equals("")) {
//                Toast.makeText(PaymentActivity.this, "Could not generate hash", Toast.LENGTH_SHORT).show();
//            } else {
//                mPaymentParams.setMerchantHash(merchantHash);
//
//                try {
//                    Log.d("Hello",mPaymentParams.toString());
//                    PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams, PaymentActivity.this, R.style.AppThemePayment, false);
//                } catch (Exception e) {
//                    Log.d("Error",e.getMessage());
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
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//
//        // Result Code is -1 send from Payumoney activity
//
//        Log.d("MainActivity", "request code " + requestCode + " resultcode " + resultCode);
//        if (requestCode == PayUmoneyFlowManager.REQUEST_CODE_PAYMENT && resultCode == RESULT_OK && data != null) {
//            TransactionResponse transactionResponse = data.getParcelableExtra( PayUmoneyFlowManager.INTENT_EXTRA_TRANSACTION_RESPONSE );
//
//            ResultModel resultModel = data.getParcelableExtra(PayUmoneyFlowManager.ARG_RESULT);
//
//            if (transactionResponse != null && transactionResponse.getPayuResponse() != null) {
//
//                if(transactionResponse.getTransactionStatus().equals( TransactionResponse.TransactionStatus.SUCCESSFUL )){
//                    //Success Transaction
//                } else{
//                    //Failure Transaction
//                }
//
//                // Response from Payumoney
//                String payuResponse = transactionResponse.getPayuResponse();
//
//                // Response from SURl and FURL
//                String merchantResponse = transactionResponse.getTransactionDetails();
//
//                new AlertDialog.Builder(this)
//                        .setCancelable(false)
//                        .setMessage("Payu's Data : " + payuResponse + "\n\n\n Merchant's Data: " + merchantResponse)
//                        .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
//                            public void onClick(DialogInterface dialog, int whichButton) {
//                                dialog.dismiss();
//                                finish();
//                            }
//                        }).show();
//
//
//            }  else if (resultModel != null && resultModel.getError() != null) {
//                Log.d("Payment", "Error response : " + resultModel.getError().getTransactionResponse());
//            } else {
//                Log.d("Payment", "Both objects are null!");
//            }
//        }
//    }
//
//}
