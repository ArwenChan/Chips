import 'dart:async';
import 'package:dict/common/api.dart';
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseIOS {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  BuildContext context;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  void init() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      debugPrint('on done');
      _subscription.cancel();
    }, onError: (error) {
      debugPrint('on error');
      debugPrint(error.toString());
      _subscription.cancel();
    });
  }

  Future<void> initStoreInfo(productIDs, context) async {
    this.context = context;
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      throw CustomException('苹果支付服务不可用', 1000);
    }
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(productIDs.toSet());
    if (productDetailResponse.error != null) {
      debugPrint(productDetailResponse.error.message);
      throw CustomException('获取商品失败', 1000);
    }

    if (productDetailResponse.productDetails.isEmpty) {
      throw CustomException('找不到商品', 1000);
    }

    _products = productDetailResponse.productDetails;

    final QueryPurchaseDetailsResponse purchaseResponse = await _connection
        .queryPastPurchases(applicationUserName: Global.profile.user.email);
    if (purchaseResponse.error != null) {
      debugPrint(purchaseResponse.error.message);
      throw CustomException('获取交易记录失败', 1000);
    }
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      // TODO: 测试是否没有 verify 的 purchase 会出现在这里
      // if (await _verifyPurchase(purchase)) {
      //   continue;
      // }
      debugPrint(purchase.toString());
      if (purchase.pendingCompletePurchase) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      _purchases.add(purchase);
    }
  }

  void handleError(IAPError error) {
    String errorMsg = '支付出错';
    if (error.details != null &&
        error.details['NSLocalizedDescription'] != null) {
      errorMsg = error.details['NSLocalizedDescription'];
    }
    if (context != null) {
      Navigator.pop(context);
      Navigator.pop(context);
      showResultDialog(context, errorMsg);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    final int validReceipt = await verifyPurchase(
        purchaseDetails.verificationData.serverVerificationData);
    if (validReceipt == 0) {
      return true;
    }
    return false;
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    if (context != null) {
      Navigator.pop(context);
      Navigator.pop(context);
      showResultDialog(context, '收据验证失败');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('purchase pending');
        if (context == null) {
          _connection.completePurchase(purchaseDetails);
        }
        return;
      }
      if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('purchase error');
        handleError(purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid;
        try {
          valid = await _verifyPurchase(purchaseDetails);
        } on CustomException catch (e) {
          Navigator.pop(context);
          Navigator.pop(context);
          var errDialog = showResultDialog(context, e.toString());
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context, errDialog);
          });
          return;
        } catch (e) {
          Navigator.pop(context);
          Navigator.pop(context);
          showToast(context, e.toString(), true);
          return;
        }
        if (valid) {
          debugPrint('success');
          Navigator.pop(context);
          Navigator.pop(context);
          showResultDialog(context, '购买成功', isError: false);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        debugPrint('to complete');
        await _connection.completePurchase(purchaseDetails);
      }
    });
  }

  void buy() {
    _connection.buyNonConsumable(
        purchaseParam: PurchaseParam(
      productDetails: _products[0],
      sandboxTesting: !Global.isRelease,
      applicationUserName: Global.profile.user.email,
    ));
    showLoadingDialog(context);
  }
}
