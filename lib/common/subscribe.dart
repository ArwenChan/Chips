import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:dict/models/product.dart';
import 'package:flutter/material.dart';

Future<void> subscribe(Product product, BuildContext context) async {
  try {
    showLoadingDialog(context);
    await Global.purchase.p.initStoreInfo([product.id], context);
    closeDialog(context);
    Global.purchase.showBuyDialog(product);
  } catch (e) {
    closeDialog(context);
    showResultDialog(context, e.toString());
    Future.delayed(Duration(seconds: 2), () {
      closeDialog(context);
    });
  }
}
