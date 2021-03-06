import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart' show ProductDetails;

Future<void> subscribe(String productId, BuildContext context) async {
  try {
    showLoadingDialog(context);
    final ProductDetails productDetail =
        await Global.purchase.p.initStoreInfo([productId], context);
    closeDialog(context);
    Global.purchase.showBuyDialog(productDetail);
  } catch (e) {
    closeDialog(context);
    showResultDialog(context, e.toString());
    Future.delayed(Duration(seconds: 2), () {
      closeDialog(context);
    });
  }
}
