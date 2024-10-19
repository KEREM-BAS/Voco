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
          _settingsItem('Terminal Adı', terminal.terminalName ?? '-'),
          _settingsItem('Terminal Kodu', terminal.terminalCode ?? '-'),
          _settingsItem('Durum', terminal.terminalStatus ?? '-'),
          const Divider(),
          _settingsSectionTitle('Firma Bilgileri'),
          _settingsItem('Firma Adı', merchant.companyName ?? '-'),
          _settingsItem('İletişim Telefonu', merchant.contactPhone ?? '-'),
          _settingsItem('İletişim E-posta', merchant.contactMail ?? '-'),
          _settingsItem('Adres', merchant.address ?? '-'),
          const Divider(),
          _settingsSectionTitle('Kullanıcı Ayarları'),
          _settingsItem('Kullanıcı Adı', terminal.userName ?? '-'),
          _settingsItem('Otomatik Batch Durumu', terminal.isOtoBatch ? 'Açık' : 'Kapalı'),
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

  Widget _settingsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
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
