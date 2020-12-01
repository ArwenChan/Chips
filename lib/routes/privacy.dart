import 'package:dict/i10n/localizations.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  final String privacyContent = """
本应用尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照本隐私权政策的规定使用和披露您的个人信息。但本应用将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，本应用不会将这些信息对外披露或向第三方提供。本应用会不时更新本隐私权政策。 您在同意本应用服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本应用服务使用协议不可分割的一部分。

1.信息使用

(a)本应用不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和本应用（含本应用关联公司）单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料。

(b) 本应用亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播您的个人信息。任何本应用平台用户如从事上述活动，一经发现，本应用有权立即终止与该用户的服务协议。

3. 信息披露

在如下情况下，本应用将依据您的个人意愿或法律的规定全部或部分的披露您的个人信息：

(a) 经您事先同意，向第三方披露；

(b) 为提供您所要求的产品和服务，而必须和第三方分享您的个人信息；

(c) 根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；

(d) 如您出现违反中国有关法律、法规或者本应用服务协议或相关规则的情况，需要向第三方披露；

(e) 如您是适格的知识产权投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；

(f) 其它本应用根据法律、法规或者网站政策认为合适的披露。

4. 信息存储和交换

本应用收集的有关您的信息和资料将保存在本应用及（或）其关联公司的服务器上。

6. 信息安全

(a) 本应用帐号均有安全保护功能，请妥善保管您的用户名及密码信息。本应用将通过对用户密码进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您注意在信息网络上不存在“完善的安全措施”。

7.本隐私政策的更改

(a)如果决定更改隐私政策，我们会在本政策中、本公司网站中以及我们认为适当的位置发布这些更改，以便您了解我们如何收集、使用您的个人信息，哪些人可以访问这些信息，以及在什么情况下我们会透露这些信息。

(b)本公司保留随时修改本政策的权利，因此请经常查看。

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DefaultLocalizations.of(context).privacy),
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Text(privacyContent),
      ),
    );
  }
}
