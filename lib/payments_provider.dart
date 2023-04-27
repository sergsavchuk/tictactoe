import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum PurchaseState { none, pending, error, invalid, purchased }

class ProductNotFoundException implements Exception {
  ProductNotFoundException(this.productId);

  final String productId;

  @override
  String toString() => 'Product not found: $productId';
}

class IAPNotAvailableException implements Exception {
  @override
  String toString() => 'In-app purchase is not available on this device';
}

// TODO(sergsavchuk): cover with unit tests
class PaymentsProvider extends ChangeNotifier {
  static const noAdsProductId = 'no_ads';

  late final StreamSubscription<List<PurchaseDetails>>
      _purchaseStreamSubscription;

  bool _available = false;
  PurchaseState _noAdsState = PurchaseState.none;

  bool get available => _available;

  bool get noAds => _noAdsState == PurchaseState.purchased;

  Future<void> init() async {
    _available = await InAppPurchase.instance.isAvailable();

    final purchaseStream = InAppPurchase.instance.purchaseStream;
    _purchaseStreamSubscription = purchaseStream.listen(
      (purchaseDetailsList) =>
          purchaseDetailsList.forEach(_processPurchaseDetails),
      // ignore: unnecessary_lambdas
      onDone: () => _purchaseStreamSubscription.cancel(),
      onError: (_) {
        // TODO(sergsavchuk): handle error
      },
    );

    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      log('Restore purchases error: $e');
    }

    notifyListeners();
  }

  Future<ProductDetails> noAdsDetails() => _loadProduct(noAdsProductId);

  Future<bool> purchaseNoAds() async {
    final productDetails = await _loadProduct(noAdsProductId);
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    return InAppPurchase.instance
        .buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<ProductDetails> _loadProduct(String id) async {
    if (!_available) {
      throw IAPNotAvailableException();
    }

    final response = await InAppPurchase.instance.queryProductDetails({id});
    if (response.notFoundIDs.isNotEmpty) {
      throw ProductNotFoundException(response.notFoundIDs.first);
    }

    return response.productDetails.first;
  }

  Future<void> _processPurchaseDetails(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      _noAdsState = PurchaseState.pending;
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        _noAdsState = PurchaseState.error;
        // TODO(sergsavchuk): handle error
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _noAdsState = PurchaseState.purchased;
        } else {
          _noAdsState = PurchaseState.invalid;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }

    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO(sergsavchuk): verify using
    // https://github.com/zsafder/firebase-function-iap-verification
    return Future.value(true);
  }

  @override
  void dispose() {
    super.dispose();

    _purchaseStreamSubscription.cancel();
  }
}
