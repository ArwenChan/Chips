// import 'package:dict/common/api.dart';
// import 'package:dict/common/dialogs.dart';
// import 'package:dict/common/global.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_alipay/flutter_alipay.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PurchaseAndroid {
//   BuildContext context;
//   String productID;

//   void init() {}
//   Future<void> initStoreInfo(productIDs, context) async {
//     this.productID = productIDs[0];
//     this.context = context;
//   }

//   Future<void> buy() async {
//     Navigator.pop(context);
//     await showBottom(
//       context: context,
//       list: [
//         FlatButton.icon(
//           height: 60,
//           minWidth: double.infinity,
//           shape: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
//           icon: Image.asset('assets/alipay.png', width: 40),
//           label: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '支付宝',
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//           onPressed: () async {
//             toPayApp();
//           },
//         ),
//         FlatButton.icon(
//           height: 60,
//           minWidth: double.infinity,
//           icon: Image.asset('assets/wepay.png', width: 35),
//           label: Align(
//             alignment: Alignment.centerLeft,
//             child: Text('微信', style: TextStyle(fontSize: 18)),
//           ),
//           onPressed: () {
//             // 微信支付
//             Navigator.pop(context);
//           },
//         ),
//       ],
//     );
//   }

//   Future toPayApp() async {
//     try {
//       if (!await canLaunch('alipays://')) {
//         showResultDialog(context, '未安装应用');
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pop(context);
//         });
//         return;
//       }
//       Navigator.pop(context);
//       showLoadingDialog(context, tips: '跳转支付中');
//       dynamic orderResult = await order(productID);
//       debugPrint(orderResult.toString());
//       closeDialog(context);
//       AlipayResult payResult = await FlutterAlipay.pay(orderResult);
//       debugPrint(payResult.toString());
//       if (payResult.memo != null) {
//         showResultDialog(
//             context, payResult.memo.split(new RegExp(r'[,，.。]'))[0]);
//         Future.delayed(Duration(seconds: 2), () {
//           closeDialog(context);
//         });
//       }
//     } catch (e) {
//       closeDialog(context);
//       debugPrint(e.toString());
//       showToast(context, e.toString(), true);
//     }
//   }
// }
