import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/utils/constants.dart';
import '../../enums/snack_type.dart';
import '../../utils/routes.dart';
import '../../utils/session.dart';
import '../../models/terminal.dart';
import '../../models/merchant.dart';
import '../../utils/main_util.dart';

class SettingsView extends StatelessWidget {
  final Terminal terminal;
  final Merchant merchant;

  const SettingsView({super.key, required this.terminal, required this.merchant});

  @override
  Widget build(BuildContext context) {
    var rates = Session.instance.softposRates;
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/hst-icon.png'),
          fit: BoxFit.fitHeight,
          height: 50,
        ),
        centerTitle: true,
        backgroundColor: Constants.PRIMARY,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _settingsSectionTitle('Terminal Bilgileri'),
          _settingsCard('Terminal Adı', terminal.terminalName ?? '-'),
          _settingsCard('Terminal Kodu', terminal.terminalCode ?? '-'),
          _settingsCard('Durum', terminal.terminalStatus ?? '-'),
          if (Session.instance.softposRates?.softRate1 != null) ...[
            const Divider(),
            _settingsSectionTitle('Oranlarım'),
            _settingsCard('0 - ${rates?.paymentRange1.ceil()} arası', "${rates?.softRate1.toString()}%"),
            _settingsCard('${rates?.paymentRange1.ceil()} üzeri', "${rates?.softRate2.toString()}%"),
          ],
          const Divider(),
          _settingsSectionTitle('Firma Bilgileri'),
          _settingsCard('Firma Adı', merchant.companyName ?? '-'),
          _settingsCard('İletişim Telefonu', merchant.contactPhone ?? '-'),
          _settingsCard('İletişim E-posta', merchant.contactMail ?? '-'),
          _settingsCard('Adres', merchant.address ?? '-'),
          const Divider(),
          _settingsSectionTitle('Kullanıcı Ayarları'),
          _settingsCard('Kullanıcı Adı', terminal.userName ?? '-'),
          _settingsCard('Otomatik Batch Durumu', terminal.isOtoBatch ? 'Açık' : 'Kapalı'),
          const SizedBox(height: 20),
          _logoutButton(context),
        ],
      ),
    );
  }

  Widget _settingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _settingsCard(String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        ),
        onPressed: () => _handleLogout(context),
        child: const Text(
          'Çıkış Yap',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('TOKEN-${Session.instance.loggedInUser != null ? Session.instance.loggedInUser!.gsmNumber! : ''}');
    await pref.remove('USER_NAME');
    await pref.remove('USER_PASSWORD');
    Session.instance.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.LOGIN, ModalRoute.withName("/login"));
    MainUtil.showSnack(context, 'Çıkış yapıldı', SnackType.INFO);
  }
}
