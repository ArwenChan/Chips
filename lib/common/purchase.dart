import 'dart:io';

import 'package:dict/common/purchaseAndroid.dart';
import 'package:dict/common/purchaseIOS.dart';
import 'package:dict/models/product.dart';
import 'package:flutter/material.dart';

class Purchase {
  dynamic p;
  Purchase() {
    if (Platform.isIOS) {
      p = PurchaseIOS();
    } else {
      p = PurchaseAndroid();
    }
  }
  Future<void> showBuyDialog(Product product) async {
    await showDialog(
      context: p.context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              title: Text('订阅 【${product.name}】', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'ONLY ￥${(product.promotionPrice ?? product.price / 100.0).toStringAsFixed(2)}  永久有效',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: RaisedButton(
                      autofocus: true,
                      color: Theme.of(context).primaryColor,
                      child: Text('订阅', style: TextStyle(fontSize: 22)),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () {
                        p.buy();
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      '再想想',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: <Widget>[],
            ),
            Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Image.asset("assets/logo.png", width: 50)),
          ],
        );
      },
    );
  }
}