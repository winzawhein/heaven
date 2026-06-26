import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/broker_listing_input.dart';
import 'firestore_keys.dart';

class BrokerListingsRepository {
  const BrokerListingsRepository();

  Future<void> createListing({required BrokerListingInput input}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Broker must be authenticated');
    }

    final payload = <String, dynamic>{
      FirestoreKeys.brokerId: user.uid,
      FirestoreKeys.brokerEmail: user.email,
      FirestoreKeys.createdAt: FieldValue.serverTimestamp(),

      FirestoreKeys.title: input.title,
      FirestoreKeys.description: input.description,
      FirestoreKeys.price: input.price,
      FirestoreKeys.area: input.area,
      FirestoreKeys.bedrooms: input.bedrooms,
      FirestoreKeys.bathrooms: input.bathrooms,
      FirestoreKeys.location: input.location,
      FirestoreKeys.phone: input.phone,
      FirestoreKeys.yearBuilt: input.yearBuilt,
      FirestoreKeys.listedDate: input.listedDate,

      FirestoreKeys.type: input.type,
      FirestoreKeys.status: input.status,
      FirestoreKeys.isFurnished: input.isFurnished,
      FirestoreKeys.amenities: input.amenities,
      FirestoreKeys.imageUrls: input.imageUrls,
    };

    await FirebaseFirestore.instance
        .collection(FirestoreKeys.listingsCollection)
        .add(payload);
  }

  //   Future<void> createListing({
  //   required Map<String, dynamic> payload,
  // }) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     throw StateError('Broker must be authenticated');
  //   }

  //   // Inject active security metadata safely prior to payload transit
  //   final verifiedPayload = {
  //     ...payload,
  //     'brokerId': user.uid,
  //     'brokerEmail': user.email,
  //     'listedDate': DateTime.now().toIso8601String(),
  //   };

  //   await _firestore.collection('properties').add(verifiedPayload);
  // }
}
