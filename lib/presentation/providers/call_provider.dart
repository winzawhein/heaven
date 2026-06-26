import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final callProvider = Provider<CallService>((ref) => CallService());

class CallService {
  Future<bool> callBroker(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    // On some devices, canLaunchUrl still returns false even with intents whitelisted.
    // Launching directly with fallback fallback is more secure.
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendSms(String phoneNumber) async {
    final uri = Uri(scheme: 'sms', path: phoneNumber);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendWhatsApp(String phoneNumber) async {
    // Strips out spaces, dashes, or parentheses
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), ''); 
    final uri = Uri.parse('https://wa.me/$cleanNumber');
    
    try {
      return await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } catch (_) {
      // Fallback to normal browser launch context if WhatsApp app isn't installed
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}