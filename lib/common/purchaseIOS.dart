import 'dart:async';
import 'package:dict/common/api.dart' show restoreAPI, verifyPurchase;
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/store_kit_wrappers.dart';

class TransactionObserver extends SKTransactionObserverWrapper {
  paymentQueueRestoreCompletedTransactionsFinished() {
    debugPrint('restore part finish transaction');
  }

  removedTransactions({List<SKPaymentTransactionWrapper> transactions}) {}
  restoreCompletedTransactionsFailed({SKError error}) {
    debugPrint('restore part error: $error');
  }

  shouldAddStorePayment({SKPaymentWrapper payment, SKProductWrapper product}) {
    // 是否接受 app store 购买, 实际上现在没有入口
    return true;
  }

  updatedTransactions({List<SKPaymentTransactionWrapper> transactions}) {
    transactions.forEach((SKPaymentTransactionWrapper transaction) async {
      debugPrint('----restore part listen----');
      Global.purchase.p.restoreTransaction(transaction);
    });
  }
}

class PurchaseIOS {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  BuildContext context;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  SKPaymentQueueWrapper skPaymentQueueWrapper = SKPaymentQueueWrapper();

  void init() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      debugPrint('on purchase update done');
      _subscription.cancel();
    }, onError: (error) {
      debugPrint('on purchase update error');
      debugPrint(error.toString());
      _subscription.cancel();
    });
    TransactionObserver observer = TransactionObserver();
    skPaymentQueueWrapper.setTransactionObserver(observer);
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
        .queryPastPurchases(applicationUserName: Global.profile.user.username);
    if (purchaseResponse.error != null) {
      debugPrint(purchaseResponse.error.message);
      throw CustomException('获取交易记录失败', 1000);
    }
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
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
      closeDialog(context);
      Navigator.pop(context);
      showResultDialog(context, errorMsg);
      Future.delayed(Duration(seconds: 2), () {
        closeDialog(context);
      });
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails,
      {int depth: 0}) async {
    final int validReceipt = await verifyPurchase(
        purchaseDetails.verificationData.serverVerificationData);
    if (validReceipt == 0) {
      return true;
    } else if (validReceipt == 1) {
      if (depth < 3) {
        return await _verifyPurchase(purchaseDetails, depth: depth++);
      } else {
        throw CustomException('请稍后再尝试验证', 1000);
      }
    }
    return false;
  }

  void _handleInvalidPurchase() {
    if (context != null) {
      closeDialog(context);
      Navigator.pop(context);
      showResultDialog(context, '收据验证失败');
      Future.delayed(Duration(seconds: 2), () {
        closeDialog(context);
      });
    }
  }

  void _handleValidPurchase() {
    if (context != null) {
      closeDialog(context);
      Navigator.pop(context);
      showResultDialog(context, '购买成功', isError: false);
      Future.delayed(Duration(seconds: 2), () {
        closeDialog(context);
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      debugPrint(purchaseDetails.status.toString());
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (context == null) {
          _connection.completePurchase(purchaseDetails);
        }
        return;
      }
      if (purchaseDetails.status == PurchaseStatus.error) {
        handleError(purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid;
        try {
          valid = await _verifyPurchase(purchaseDetails);
        } on CustomException catch (e) {
          if (context != null) {
            closeDialog(context);
            Navigator.pop(context);
            showResultDialog(context, e.toString());
            Future.delayed(Duration(seconds: 2), () {
              closeDialog(context);
            });
          }
          if (e.code == 4006) {
            if (purchaseDetails.pendingCompletePurchase) {
              debugPrint('to complete');
              await _connection.completePurchase(purchaseDetails);
            }
          }
          return;
        } catch (e) {
          if (context != null) {
            closeDialog(context);
            Navigator.pop(context);
            showToast(context, e.toString(), true);
          }
          return;
        }
        if (valid) {
          debugPrint('success');
          _handleValidPurchase();
        } else {
          _handleInvalidPurchase();
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
    showLoadingDialog(context);
    _connection
        .buyNonConsumable(
            purchaseParam: PurchaseParam(
      productDetails: _products[0],
      applicationUserName: Global.profile.user.username,
    ))
        .catchError((e) {
      closeDialog(context);
      Navigator.pop(context);
      if (e.message.contains('pending')) {
        showAppleDialog(context, '有未完成的购买，您可以重启应用再继续或重新购买。');
      }
    });
  }

  void restore(BuildContext context) {
    debugPrint('---restore---');
    this.context = context;
    showLoadingDialog(context);
    skPaymentQueueWrapper.restoreTransactions(
        applicationUserName: Global.profile.user.username);
  }

  Future<void> restoreTransaction(
      SKPaymentTransactionWrapper transaction) async {
    try {
      if (transaction.transactionState ==
          SKPaymentTransactionStateWrapper.restored) {
        await restoreAPI(transaction.originalTransaction.transactionIdentifier);
        if (context != null) {
          closeDialog(context);
        }
      }
    } on CustomException catch (e) {
      if (context != null) {
        closeDialog(context);
        showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          closeDialog(context);
        });
      }
    } catch (e) {
      if (context != null) {
        closeDialog(context);
        showToast(context, e.toString(), true);
      }
    } finally {
      SKPaymentQueueWrapper().finishTransaction(transaction);
    }
  }
}
