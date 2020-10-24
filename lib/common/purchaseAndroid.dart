import 'package:dict/common/api.dart';
import 'package:dict/common/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';

class PurchaseAndroid {
  BuildContext context;
  String productID;

  void init() {}
  Future<void> initStoreInfo(productIDs, context) async {
    productID = productIDs[0];
  }

  Future<void> buy() async {
    Navigator.pop(context);
    await showBottom(
      context: context,
      list: [
        FlatButton(
          child: Text('支付宝', style: TextStyle(fontSize: 16)),
          onPressed: () async {
            dynamic orderResult = await order(productID);
            Navigator.pop(context);
            dynamic payResult = await FlutterAlipay.pay(orderResult);
          },
        ),
        FlatButton(
          child: Text('微信', style: TextStyle(fontSize: 16)),
          onPressed: () {
            // 微信支付
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
