// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Marekat`
  String get app_name {
    return Intl.message(
      'Marekat',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Flash Deal`
  String get flash_deal {
    return Intl.message(
      'Flash Deal',
      name: 'flash_deal',
      desc: '',
      args: [],
    );
  }

  /// `Today's Deal`
  String get today_deal {
    return Intl.message(
      'Today\'s Deal',
      name: 'today_deal',
      desc: '',
      args: [],
    );
  }

  /// `Top Sellers`
  String get top_sellers {
    return Intl.message(
      'Top Sellers',
      name: 'top_sellers',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `Top Categories`
  String get top_categories {
    return Intl.message(
      'Top Categories',
      name: 'top_categories',
      desc: '',
      args: [],
    );
  }

  /// `Feature Categories`
  String get feature_categories {
    return Intl.message(
      'Feature Categories',
      name: 'feature_categories',
      desc: '',
      args: [],
    );
  }

  /// `Feature Products`
  String get products {
    return Intl.message(
      'Feature Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `You are not logged in`
  String get notLogin {
    return Intl.message(
      'You are not logged in',
      name: 'notLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Sellers`
  String get sellers {
    return Intl.message(
      'Sellers',
      name: 'sellers',
      desc: '',
      args: [],
    );
  }

  /// `View Sub-Categories`
  String get view_sub_product {
    return Intl.message(
      'View Sub-Categories',
      name: 'view_sub_product',
      desc: '',
      args: [],
    );
  }

  /// `View Products`
  String get view_products {
    return Intl.message(
      'View Products',
      name: 'view_products',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search Here?`
  String get search_here {
    return Intl.message(
      'Search Here?',
      name: 'search_here',
      desc: '',
      args: [],
    );
  }

  /// `Login to Marekat`
  String get login_to_daemmart {
    return Intl.message(
      'Login to Marekat',
      name: 'login_to_daemmart',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get forget_password {
    return Intl.message(
      'Forget Password',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message(
      'Log in',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `or, create a new account ?`
  String get create_new_account {
    return Intl.message(
      'or, create a new account ?',
      name: 'create_new_account',
      desc: '',
      args: [],
    );
  }

  /// `You are not logged in`
  String get youAreNotLoggedIn {
    return Intl.message(
      'You are not logged in',
      name: 'youAreNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `My Wishlist`
  String get myWishlist {
    return Intl.message(
      'My Wishlist',
      name: 'myWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to logout`
  String get areYouSureWantToLogout {
    return Intl.message(
      'Are you sure want to logout',
      name: 'areYouSureWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to see the wishlist items`
  String get pleaseLogInToSeeTheWishlistItems {
    return Intl.message(
      'Please log in to see the wishlist items',
      name: 'pleaseLogInToSeeTheWishlistItems',
      desc: '',
      args: [],
    );
  }

  /// `Your wishlist is empty!`
  String get yourWishlistIsEmpty {
    return Intl.message(
      'Your wishlist is empty!',
      name: 'yourWishlistIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No top selling products from this seller`
  String get noTopSellingProductsFromThisSeller {
    return Intl.message(
      'No top selling products from this seller',
      name: 'noTopSellingProductsFromThisSeller',
      desc: '',
      args: [],
    );
  }

  /// `START SHOPPING`
  String get startShopping {
    return Intl.message(
      'START SHOPPING',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Amount cannot be empty`
  String get amountCannotBeEmpty {
    return Intl.message(
      'Amount cannot be empty',
      name: 'amountCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No More History`
  String get noMoreHistory {
    return Intl.message(
      'No More History',
      name: 'noMoreHistory',
      desc: '',
      args: [],
    );
  }

  /// `Loading More History ...`
  String get loadingMoreHistory {
    return Intl.message(
      'Loading More History ...',
      name: 'loadingMoreHistory',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get myWallet {
    return Intl.message(
      'My Wallet',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `Not recharged yet`
  String get noRechargesYet {
    return Intl.message(
      'Not recharged yet',
      name: 'noRechargesYet',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Approval Status`
  String get approvalStatus {
    return Intl.message(
      'Approval Status',
      name: 'approvalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance`
  String get walletBalance {
    return Intl.message(
      'Wallet Balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Last recharge : `
  String get lastRecharged {
    return Intl.message(
      'Last recharge : ',
      name: 'lastRecharged',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Recharge History`
  String get walletRechargeHistory {
    return Intl.message(
      'Wallet Recharge History',
      name: 'walletRechargeHistory',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enterAmount {
    return Intl.message(
      'Enter Amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `CLOSE`
  String get close {
    return Intl.message(
      'CLOSE',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `Top Sellers`
  String get topSellers {
    return Intl.message(
      'Top Sellers',
      name: 'topSellers',
      desc: '',
      args: [],
    );
  }

  /// `Today's Deals`
  String get todaysDeals {
    return Intl.message(
      'Today\'s Deals',
      name: 'todaysDeals',
      desc: '',
      args: [],
    );
  }

  /// `Creating order ...`
  String get creatingOrder {
    return Intl.message(
      'Creating order ...',
      name: 'creatingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Payment cancelled`
  String get paymentCancelled {
    return Intl.message(
      'Payment cancelled',
      name: 'paymentCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Stripe`
  String get payWithStripe {
    return Intl.message(
      'Pay with Stripe',
      name: 'payWithStripe',
      desc: '',
      args: [],
    );
  }

  /// `Enter Address`
  String get enterAddress {
    return Intl.message(
      'Enter Address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Select a city`
  String get selectACity {
    return Intl.message(
      'Select a city',
      name: 'selectACity',
      desc: '',
      args: [],
    );
  }

  /// `Select a country`
  String get selectACountry {
    return Intl.message(
      'Select a country',
      name: 'selectACountry',
      desc: '',
      args: [],
    );
  }

  /// `Address *`
  String get address {
    return Intl.message(
      'Address *',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address_ {
    return Intl.message(
      'Address',
      name: 'address_',
      desc: '',
      args: [],
    );
  }

  /// `City *`
  String get city {
    return Intl.message(
      'City *',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Enter City`
  String get enterCity {
    return Intl.message(
      'Enter City',
      name: 'enterCity',
      desc: '',
      args: [],
    );
  }

  /// `Postal Code`
  String get postalCode {
    return Intl.message(
      'Postal Code',
      name: 'postalCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Postal Code`
  String get enterPostalCode {
    return Intl.message(
      'Enter Postal Code',
      name: 'enterPostalCode',
      desc: '',
      args: [],
    );
  }

  /// `Country *`
  String get country {
    return Intl.message(
      'Country *',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone`
  String get enterPhone {
    return Intl.message(
      'Enter Phone',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `ADD`
  String get add {
    return Intl.message(
      'ADD',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Cost`
  String get shippingCost {
    return Intl.message(
      'Shipping Cost',
      name: 'shippingCost',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to see the cart items`
  String get pleaseLogInToSeeTheCartItems {
    return Intl.message(
      'Please log in to see the cart items',
      name: 'pleaseLogInToSeeTheCartItems',
      desc: '',
      args: [],
    );
  }

  /// `No Addresses is added`
  String get noAddressesIsAdded {
    return Intl.message(
      'No Addresses is added',
      name: 'noAddressesIsAdded',
      desc: '',
      args: [],
    );
  }

  /// `PROCEED TO CHECKOUT`
  String get proceedToCheckout {
    return Intl.message(
      'PROCEED TO CHECKOUT',
      name: 'proceedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `No More Products`
  String get noMoreProducts {
    return Intl.message(
      'No More Products',
      name: 'noMoreProducts',
      desc: '',
      args: [],
    );
  }

  /// `Loading More Products ...`
  String get loadingMoreProducts {
    return Intl.message(
      'Loading More Products ...',
      name: 'loadingMoreProducts',
      desc: '',
      args: [],
    );
  }

  /// `Search products of shop : `
  String get searchProductsOfShop {
    return Intl.message(
      'Search products of shop : ',
      name: 'searchProductsOfShop',
      desc: '',
      args: [],
    );
  }

  /// `No data is available`
  String get noDataIsAvailable {
    return Intl.message(
      'No data is available',
      name: 'noDataIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `New Arrivals`
  String get newArrivals {
    return Intl.message(
      'New Arrivals',
      name: 'newArrivals',
      desc: '',
      args: [],
    );
  }

  /// `Top Selling Products`
  String get topSellingProducts {
    return Intl.message(
      'Top Selling Products',
      name: 'topSellingProducts',
      desc: '',
      args: [],
    );
  }

  /// `Featured Products`
  String get featuredProducts {
    return Intl.message(
      'Featured Products',
      name: 'featuredProducts',
      desc: '',
      args: [],
    );
  }

  /// `No featured product is available from this seller`
  String get noFeaturedProductIsAvailableFromThisSeller {
    return Intl.message(
      'No featured product is available from this seller',
      name: 'noFeaturedProductIsAvailableFromThisSeller',
      desc: '',
      args: [],
    );
  }

  /// `View All Products From This Seller`
  String get viewAllProductsFromThisSeller {
    return Intl.message(
      'View All Products From This Seller',
      name: 'viewAllProductsFromThisSeller',
      desc: '',
      args: [],
    );
  }

  /// `No new arrivals`
  String get noNewArrivals {
    return Intl.message(
      'No new arrivals',
      name: 'noNewArrivals',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmYourPassword {
    return Intl.message(
      'Confirm your password',
      name: 'confirmYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least 6 characters`
  String get passwordMustContainAtLeast6Characters {
    return Intl.message(
      'Password must contain at least 6 characters',
      name: 'passwordMustContainAtLeast6Characters',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message(
      'Join',
      name: 'join',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `John Doe`
  String get johnDoe {
    return Intl.message(
      'John Doe',
      name: 'johnDoe',
      desc: '',
      args: [],
    );
  }

  /// `johndoe@example.com`
  String get johndoeexamplecom {
    return Intl.message(
      'johndoe@example.com',
      name: 'johndoeexamplecom',
      desc: '',
      args: [],
    );
  }

  /// `or, Register with a phone number`
  String get orRegisterWithAPhoneNumber {
    return Intl.message(
      'or, Register with a phone number',
      name: 'orRegisterWithAPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `01710 333 558`
  String get mobHint {
    return Intl.message(
      '01710 333 558',
      name: 'mobHint',
      desc: '',
      args: [],
    );
  }

  /// `or, Register with an email`
  String get orRegisterWithAnEmail {
    return Intl.message(
      'or, Register with an email',
      name: 'orRegisterWithAnEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 character`
  String get passwordMustBeAtLeast6Character {
    return Intl.message(
      'Password must be at least 6 character',
      name: 'passwordMustBeAtLeast6Character',
      desc: '',
      args: [],
    );
  }

  /// `Retype Password`
  String get retypePassword {
    return Intl.message(
      'Retype Password',
      name: 'retypePassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Already have an Account ?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an Account ?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get logIn {
    return Intl.message(
      'Log in',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Please choose one option to pay`
  String get pleaseChooseOneOptionToPay {
    return Intl.message(
      'Please choose one option to pay',
      name: 'pleaseChooseOneOptionToPay',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to pay`
  String get nothingToPay {
    return Intl.message(
      'Nothing to pay',
      name: 'nothingToPay',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Wallet`
  String get rechargeWallet {
    return Intl.message(
      'Recharge Wallet',
      name: 'rechargeWallet',
      desc: '',
      args: [],
    );
  }

  /// `No payment method is added`
  String get noPaymentMethodIsAdded {
    return Intl.message(
      'No payment method is added',
      name: 'noPaymentMethodIsAdded',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Razorpay`
  String get payWithRazorpay {
    return Intl.message(
      'Pay with Razorpay',
      name: 'payWithRazorpay',
      desc: '',
      args: [],
    );
  }

  /// `Photo Permission`
  String get photoPermission {
    return Intl.message(
      'Photo Permission',
      name: 'photoPermission',
      desc: '',
      args: [],
    );
  }

  /// `This app needs photo to take pictures for upload user profile photo`
  String get thisAppNeedsPhotoToTakePicturesForUploadUser {
    return Intl.message(
      'This app needs photo to take pictures for upload user profile photo',
      name: 'thisAppNeedsPhotoToTakePicturesForUploadUser',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get deny {
    return Intl.message(
      'Deny',
      name: 'deny',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Go to your application settings and give photo permission`
  String get goToYourApplicationSettingsAndGivePhotoPermission {
    return Intl.message(
      'Go to your application settings and give photo permission',
      name: 'goToYourApplicationSettingsAndGivePhotoPermission',
      desc: '',
      args: [],
    );
  }

  /// `No file is chosen`
  String get noFileIsChosen {
    return Intl.message(
      'No file is chosen',
      name: 'noFileIsChosen',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to see the profile`
  String get pleaseLogInToSeeTheProfile {
    return Intl.message(
      'Please log in to see the profile',
      name: 'pleaseLogInToSeeTheProfile',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basicInformation {
    return Intl.message(
      'Basic Information',
      name: 'basicInformation',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Coming soon`
  String get comingSoon {
    return Intl.message(
      'Coming soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Purchase History`
  String get purchaseHistory {
    return Intl.message(
      'Purchase History',
      name: 'purchaseHistory',
      desc: '',
      args: [],
    );
  }

  /// `In your cart`
  String get inYourCart {
    return Intl.message(
      'In your cart',
      name: 'inYourCart',
      desc: '',
      args: [],
    );
  }

  /// `In wishlist`
  String get inWishlist {
    return Intl.message(
      'In wishlist',
      name: 'inWishlist',
      desc: '',
      args: [],
    );
  }

  /// `Ordered`
  String get ordered {
    return Intl.message(
      'Ordered',
      name: 'ordered',
      desc: '',
      args: [],
    );
  }

  /// `Check Balance`
  String get checkBalance {
    return Intl.message(
      'Check Balance',
      name: 'checkBalance',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `You need to login to give a review`
  String get youNeedToLoginToGiveAReview {
    return Intl.message(
      'You need to login to give a review',
      name: 'youNeedToLoginToGiveAReview',
      desc: '',
      args: [],
    );
  }

  /// `Review cannot be empty`
  String get reviewCannotBeEmpty {
    return Intl.message(
      'Review cannot be empty',
      name: 'reviewCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `At least one star must be given`
  String get atLeastOneStarMustBeGiven {
    return Intl.message(
      'At least one star must be given',
      name: 'atLeastOneStarMustBeGiven',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `No reviews yet. Be the first one to review this product`
  String get noReviewsYetBeTheFirstOneToReviewThis {
    return Intl.message(
      'No reviews yet. Be the first one to review this product',
      name: 'noReviewsYetBeTheFirstOneToReviewThis',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get viewMore {
    return Intl.message(
      'View More',
      name: 'viewMore',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get showLess {
    return Intl.message(
      'Show Less',
      name: 'showLess',
      desc: '',
      args: [],
    );
  }

  /// `No More Reviews`
  String get noMoreReviews {
    return Intl.message(
      'No More Reviews',
      name: 'noMoreReviews',
      desc: '',
      args: [],
    );
  }

  /// `Loading More Reviews ...`
  String get loadingMoreReviews {
    return Intl.message(
      'Loading More Reviews ...',
      name: 'loadingMoreReviews',
      desc: '',
      args: [],
    );
  }

  /// `Type your review here ...`
  String get typeYourReviewHere {
    return Intl.message(
      'Type your review here ...',
      name: 'typeYourReviewHere',
      desc: '',
      args: [],
    );
  }

  /// `Added to cart`
  String get addedToCart {
    return Intl.message(
      'Added to cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `SHOW CART`
  String get showCart {
    return Intl.message(
      'SHOW CART',
      name: 'showCart',
      desc: '',
      args: [],
    );
  }

  /// `Description: `
  String get description {
    return Intl.message(
      'Description: ',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Seller Policy`
  String get sellerPolicy {
    return Intl.message(
      'Seller Policy',
      name: 'sellerPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Return Policy`
  String get returnPolicy {
    return Intl.message(
      'Return Policy',
      name: 'returnPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Support Policy`
  String get supportPolicy {
    return Intl.message(
      'Support Policy',
      name: 'supportPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Products you may also like`
  String get productsYouMayAlsoLike {
    return Intl.message(
      'Products you may also like',
      name: 'productsYouMayAlsoLike',
      desc: '',
      args: [],
    );
  }

  /// `Top Selling Products from this seller`
  String get topSellingProductsFromThisSeller {
    return Intl.message(
      'Top Selling Products from this seller',
      name: 'topSellingProductsFromThisSeller',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get seller {
    return Intl.message(
      'Seller',
      name: 'seller',
      desc: '',
      args: [],
    );
  }

  /// `Chat with seller`
  String get chatWithSeller {
    return Intl.message(
      'Chat with seller',
      name: 'chatWithSeller',
      desc: '',
      args: [],
    );
  }

  /// `Total Price:`
  String get totalPrice {
    return Intl.message(
      'Total Price:',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Quantity: `
  String get quantity {
    return Intl.message(
      'Quantity: ',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `available`
  String get available {
    return Intl.message(
      'available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Color:`
  String get color {
    return Intl.message(
      'Color:',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Club Point: `
  String get clubPoint {
    return Intl.message(
      'Club Point: ',
      name: 'clubPoint',
      desc: '',
      args: [],
    );
  }

  /// `Price:`
  String get price {
    return Intl.message(
      'Price:',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message(
      'Buy Now',
      name: 'buyNow',
      desc: '',
      args: [],
    );
  }

  /// `No related products`
  String get noRelatedProducts {
    return Intl.message(
      'No related products',
      name: 'noRelatedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch`
  String get couldNotLaunch {
    return Intl.message(
      'Could not launch',
      name: 'couldNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Fetching paypal url ...`
  String get fetchingPaypalUrl {
    return Intl.message(
      'Fetching paypal url ...',
      name: 'fetchingPaypalUrl',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Paypal`
  String get payWithPaypal {
    return Intl.message(
      'Pay with Paypal',
      name: 'payWithPaypal',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code`
  String get enterTheCode {
    return Intl.message(
      'Enter the code',
      name: 'enterTheCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent`
  String get enterTheCodeSent {
    return Intl.message(
      'Enter the code sent',
      name: 'enterTheCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code that sent to your email recently.`
  String get enterTheVerificationCodeThatSentToYourEmailRecently {
    return Intl.message(
      'Enter the verification code that sent to your email recently.',
      name: 'enterTheVerificationCodeThatSentToYourEmailRecently',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code that sent to your phone recently.`
  String get enterTheVerificationCodeThatSentToYourPhoneRecently {
    return Intl.message(
      'Enter the verification code that sent to your phone recently.',
      name: 'enterTheVerificationCodeThatSentToYourPhoneRecently',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password ?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password ?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `or, send code via phone number`
  String get orSendCodeViaPhoneNumber {
    return Intl.message(
      'or, send code via phone number',
      name: 'orSendCodeViaPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `or, send code via email`
  String get orSendCodeViaEmail {
    return Intl.message(
      'or, send code via email',
      name: 'orSendCodeViaEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter verification code`
  String get enterVerificationCode {
    return Intl.message(
      'Enter verification code',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify your`
  String get verifyYour {
    return Intl.message(
      'Verify your',
      name: 'verifyYour',
      desc: '',
      args: [],
    );
  }

  /// `Email Account`
  String get emailAccount {
    return Intl.message(
      'Email Account',
      name: 'emailAccount',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `A X B 4 J H`
  String get aXB4JH {
    return Intl.message(
      'A X B 4 J H',
      name: 'aXB4JH',
      desc: '',
      args: [],
    );
  }

  /// `No More Orders`
  String get noMoreOrders {
    return Intl.message(
      'No More Orders',
      name: 'noMoreOrders',
      desc: '',
      args: [],
    );
  }

  /// `Loading More order ...`
  String get loadingMoreOrder {
    return Intl.message(
      'Loading More order ...',
      name: 'loadingMoreOrder',
      desc: '',
      args: [],
    );
  }

  /// `All Payments`
  String get allPayments {
    return Intl.message(
      'All Payments',
      name: 'allPayments',
      desc: '',
      args: [],
    );
  }

  /// `All Deliveries`
  String get allDeliveries {
    return Intl.message(
      'All Deliveries',
      name: 'allDeliveries',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status - `
  String get paymentStatus {
    return Intl.message(
      'Payment Status - ',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Status - `
  String get deliveryStatus {
    return Intl.message(
      'Delivery Status - ',
      name: 'deliveryStatus',
      desc: '',
      args: [],
    );
  }

  /// `Login to`
  String get loginTo {
    return Intl.message(
      'Login to',
      name: 'loginTo',
      desc: '',
      args: [],
    );
  }

  /// `or, Login with a phone number`
  String get orLoginWithAPhoneNumber {
    return Intl.message(
      'or, Login with a phone number',
      name: 'orLoginWithAPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `or, Login with an email`
  String get orLoginWithAnEmail {
    return Intl.message(
      'or, Login with an email',
      name: 'orLoginWithAnEmail',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or, create a new account ?`
  String get orCreateANewAccount {
    return Intl.message(
      'or, create a new account ?',
      name: 'orCreateANewAccount',
      desc: '',
      args: [],
    );
  }

  /// `No sub categories available`
  String get noSubCategoriesAvailable {
    return Intl.message(
      'No sub categories available',
      name: 'noSubCategoriesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Search products from : `
  String get searchProductsFrom {
    return Intl.message(
      'Search products from : ',
      name: 'searchProductsFrom',
      desc: '',
      args: [],
    );
  }

  /// `Flash deal is ended`
  String get flashDealIsEnded {
    return Intl.message(
      'Flash deal is ended',
      name: 'flashDealIsEnded',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get ended {
    return Intl.message(
      'Ended',
      name: 'ended',
      desc: '',
      args: [],
    );
  }

  /// `Flash Deals`
  String get flashDeals {
    return Intl.message(
      'Flash Deals',
      name: 'flashDeals',
      desc: '',
      args: [],
    );
  }

  /// `No More Brands`
  String get noMoreBrands {
    return Intl.message(
      'No More Brands',
      name: 'noMoreBrands',
      desc: '',
      args: [],
    );
  }

  /// `Loading More Brands ...`
  String get loadingMoreBrands {
    return Intl.message(
      'Loading More Brands ...',
      name: 'loadingMoreBrands',
      desc: '',
      args: [],
    );
  }

  /// `No More Shops`
  String get noMoreShops {
    return Intl.message(
      'No More Shops',
      name: 'noMoreShops',
      desc: '',
      args: [],
    );
  }

  /// `Loading More Shops ...`
  String get loadingMoreShops {
    return Intl.message(
      'Loading More Shops ...',
      name: 'loadingMoreShops',
      desc: '',
      args: [],
    );
  }

  /// `You can use filters while searching for products.`
  String get youCanUseFiltersWhileSearchingForProducts {
    return Intl.message(
      'You can use filters while searching for products.',
      name: 'youCanUseFiltersWhileSearchingForProducts',
      desc: '',
      args: [],
    );
  }

  /// `Sort Products By`
  String get sortProductsBy {
    return Intl.message(
      'Sort Products By',
      name: 'sortProductsBy',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get default_ {
    return Intl.message(
      'Default',
      name: 'default_',
      desc: '',
      args: [],
    );
  }

  /// `Price high to low`
  String get priceHighToLow {
    return Intl.message(
      'Price high to low',
      name: 'priceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Price low to high`
  String get priceLowToHigh {
    return Intl.message(
      'Price low to high',
      name: 'priceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `New Arrival`
  String get newArrival {
    return Intl.message(
      'New Arrival',
      name: 'newArrival',
      desc: '',
      args: [],
    );
  }

  /// `Popularity`
  String get popularity {
    return Intl.message(
      'Popularity',
      name: 'popularity',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated`
  String get topRated {
    return Intl.message(
      'Top Rated',
      name: 'topRated',
      desc: '',
      args: [],
    );
  }

  /// `You can use sorting while searching for products.`
  String get youCanUseSortingWhileSearchingForProducts {
    return Intl.message(
      'You can use sorting while searching for products.',
      name: 'youCanUseSortingWhileSearchingForProducts',
      desc: '',
      args: [],
    );
  }

  /// `Search here ?`
  String get searchHere {
    return Intl.message(
      'Search here ?',
      name: 'searchHere',
      desc: '',
      args: [],
    );
  }

  /// `Price Range`
  String get priceRange {
    return Intl.message(
      'Price Range',
      name: 'priceRange',
      desc: '',
      args: [],
    );
  }

  /// `Minimum`
  String get minimum {
    return Intl.message(
      'Minimum',
      name: 'minimum',
      desc: '',
      args: [],
    );
  }

  /// `Maximum`
  String get maximum {
    return Intl.message(
      'Maximum',
      name: 'maximum',
      desc: '',
      args: [],
    );
  }

  /// `No categories available`
  String get noCategoriesAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCategoriesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No brands available`
  String get noBrandsAvailable {
    return Intl.message(
      'No brands available',
      name: 'noBrandsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `CLEAR`
  String get clear {
    return Intl.message(
      'CLEAR',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `APPLY`
  String get apply {
    return Intl.message(
      'APPLY',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Min price cannot be larger than max price`
  String get minPriceCannotBeLargerThanMaxPrice {
    return Intl.message(
      'Min price cannot be larger than max price',
      name: 'minPriceCannotBeLargerThanMaxPrice',
      desc: '',
      args: [],
    );
  }

  /// `No product is available`
  String get noProductIsAvailable {
    return Intl.message(
      'No product is available',
      name: 'noProductIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No brand is available`
  String get noBrandIsAvailable {
    return Intl.message(
      'No brand is available',
      name: 'noBrandIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No shop is available`
  String get noShopIsAvailable {
    return Intl.message(
      'No shop is available',
      name: 'noShopIsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Enter coupon code`
  String get enterCouponCode {
    return Intl.message(
      'Enter coupon code',
      name: 'enterCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `SUB TOTAL`
  String get subTotal {
    return Intl.message(
      'SUB TOTAL',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `TAX`
  String get tax {
    return Intl.message(
      'TAX',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `DISCOUNT`
  String get discount {
    return Intl.message(
      'DISCOUNT',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `GRAND TOTAL`
  String get grandTotal {
    return Intl.message(
      'GRAND TOTAL',
      name: 'grandTotal',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `see details`
  String get seeDetails {
    return Intl.message(
      'see details',
      name: 'seeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get couponCode {
    return Intl.message(
      'Coupon Code',
      name: 'couponCode',
      desc: '',
      args: [],
    );
  }

  /// `APPLY COUPON`
  String get applyCoupon {
    return Intl.message(
      'APPLY COUPON',
      name: 'applyCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `PLACE MY ORDER`
  String get placeMyOrder {
    return Intl.message(
      'PLACE MY ORDER',
      name: 'placeMyOrder',
      desc: '',
      args: [],
    );
  }

  /// `View Sub-Categories`
  String get viewSubcategories {
    return Intl.message(
      'View Sub-Categories',
      name: 'viewSubcategories',
      desc: '',
      args: [],
    );
  }

  /// `View Products`
  String get viewProducts {
    return Intl.message(
      'View Products',
      name: 'viewProducts',
      desc: '',
      args: [],
    );
  }

  /// `All Products of`
  String get allProductsOf {
    return Intl.message(
      'All Products of',
      name: 'allProductsOf',
      desc: '',
      args: [],
    );
  }

  /// `Cannot order more than`
  String get cannotOrderMoreThan {
    return Intl.message(
      'Cannot order more than',
      name: 'cannotOrderMoreThan',
      desc: '',
      args: [],
    );
  }

  /// `item(s) of this`
  String get itemsOfThis {
    return Intl.message(
      'item(s) of this',
      name: 'itemsOfThis',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to remove this item`
  String get areYouSureToRemoveThisItem {
    return Intl.message(
      'Are you sure to remove this item',
      name: 'areYouSureToRemoveThisItem',
      desc: '',
      args: [],
    );
  }

  /// `Cart is empty`
  String get cartIsEmpty {
    return Intl.message(
      'Cart is empty',
      name: 'cartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE CART`
  String get updateCart {
    return Intl.message(
      'UPDATE CART',
      name: 'updateCart',
      desc: '',
      args: [],
    );
  }

  /// `PROCEED TO SHIPPING`
  String get proceedToShipping {
    return Intl.message(
      'PROCEED TO SHIPPING',
      name: 'proceedToShipping',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty! add items in your cart`
  String get yourCartIsEmptyAddItemsInYourCart {
    return Intl.message(
      'Your cart is empty! add items in your cart',
      name: 'yourCartIsEmptyAddItemsInYourCart',
      desc: '',
      args: [],
    );
  }

  /// `Add Now`
  String get addNow {
    return Intl.message(
      'Add Now',
      name: 'addNow',
      desc: '',
      args: [],
    );
  }

  /// `Search products of brand : `
  String get searchProductsOfBrand {
    return Intl.message(
      'Search products of brand : ',
      name: 'searchProductsOfBrand',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to remove this address`
  String get areYouSureToRemoveThisAddress {
    return Intl.message(
      'Are you sure to remove this address',
      name: 'areYouSureToRemoveThisAddress',
      desc: '',
      args: [],
    );
  }

  /// `UPDATE`
  String get update {
    return Intl.message(
      'UPDATE',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Addresses of user`
  String get addressesOfUser {
    return Intl.message(
      'Addresses of user',
      name: 'addressesOfUser',
      desc: '',
      args: [],
    );
  }

  /// `* Double tap on an address to make it default`
  String get doubleTapOnAnAddressToMakeItDefault {
    return Intl.message(
      '* Double tap on an address to make it default',
      name: 'doubleTapOnAnAddressToMakeItDefault',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Video not available`
  String get videoNotAvailable {
    return Intl.message(
      'Video not available',
      name: 'videoNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get oops {
    return Intl.message(
      'Oops!',
      name: 'oops',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Postal Code`
  String get pleaseEnterPostalCode {
    return Intl.message(
      'Please enter Postal Code',
      name: 'pleaseEnterPostalCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Phone Number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter Phone Number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Ordered Product`
  String get orderedProduct {
    return Intl.message(
      'Ordered Product',
      name: 'orderedProduct',
      desc: '',
      args: [],
    );
  }

  /// `No items are ordered`
  String get noItemsAreOrdered {
    return Intl.message(
      'No items are ordered',
      name: 'noItemsAreOrdered',
      desc: '',
      args: [],
    );
  }

  /// `Order placed`
  String get orderPlaced {
    return Intl.message(
      'Order placed',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `On Delivery`
  String get onDelivery {
    return Intl.message(
      'On Delivery',
      name: 'onDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message(
      'Delivered',
      name: 'delivered',
      desc: '',
      args: [],
    );
  }

  /// `Order Code`
  String get orderCode {
    return Intl.message(
      'Order Code',
      name: 'orderCode',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Method`
  String get shippingMethod {
    return Intl.message(
      'Shipping Method',
      name: 'shippingMethod',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message(
      'Order Date',
      name: 'orderDate',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Address`
  String get shippingAddress {
    return Intl.message(
      'Shipping Address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get item {
    return Intl.message(
      'item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Ask For Refund`
  String get askForRefund {
    return Intl.message(
      'Ask For Refund',
      name: 'askForRefund',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message(
      'Confirmed',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `GET MY LOCATION`
  String get getMyLocation {
    return Intl.message(
      'GET MY LOCATION',
      name: 'getMyLocation',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Explore more and shortlist some items`
  String get exploreMoreAndShortlistSomeItems {
    return Intl.message(
      'Explore more and shortlist some items',
      name: 'exploreMoreAndShortlistSomeItems',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Marekat smart store to continue\nshopping healthy and organic products`
  String get signUpWithAppnameSmartStoreToContinuenshoppingHealthyAnd {
    return Intl.message(
      'Sign up with Marekat smart store to continue\nshopping healthy and organic products',
      name: 'signUpWithAppnameSmartStoreToContinuenshoppingHealthyAnd',
      desc: '',
      args: [],
    );
  }

  /// `\nLogin to browse through huge amounts\nof healthy goods`
  String get nloginToBrowseThroughHugeAmountsnofHealthyGoods {
    return Intl.message(
      '\nLogin to browse through huge amounts\nof healthy goods',
      name: 'nloginToBrowseThroughHugeAmountsnofHealthyGoods',
      desc: '',
      args: [],
    );
  }

  /// `Top Ten Brands`
  String get topTenBrands {
    return Intl.message(
      'Top Ten Brands',
      name: 'topTenBrands',
      desc: '',
      args: [],
    );
  }

  /// `Pay with PayTab`
  String get payWithPaytab {
    return Intl.message(
      'Pay with PayTab',
      name: 'payWithPaytab',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to cancel`
  String get areYouSureToCancel {
    return Intl.message(
      'Are you sure to cancel',
      name: 'areYouSureToCancel',
      desc: '',
      args: [],
    );
  }

  /// `Please pull down to Refresh\nor check your Internet or wi-fi`
  String get pleasePullDownToRefreshnorCheckYourInternetOr {
    return Intl.message(
      'Please pull down to Refresh\nor check your Internet or wi-fi',
      name: 'pleasePullDownToRefreshnorCheckYourInternetOr',
      desc: '',
      args: [],
    );
  }

  /// `Explore the hottest trend with your favourite Brand`
  String get exploreTheHottestTrendWithYournfavouriteBrand {
    return Intl.message(
      'Explore the hottest trend with your favourite Brand',
      name: 'exploreTheHottestTrendWithYournfavouriteBrand',
      desc: '',
      args: [],
    );
  }

  /// `Top Brands`
  String get topBrands {
    return Intl.message(
      'Top Brands',
      name: 'topBrands',
      desc: '',
      args: [],
    );
  }

  /// `Best Men's Watches collections`
  String get bestMensWatchesCollections {
    return Intl.message(
      'Best Men\'s Watches collections',
      name: 'bestMensWatchesCollections',
      desc: '',
      args: [],
    );
  }

  /// `Men's Watches`
  String get mensWatches {
    return Intl.message(
      'Men\'s Watches',
      name: 'mensWatches',
      desc: '',
      args: [],
    );
  }

  /// `Best Women's Watches collections`
  String get bestWomensWatchesCollectionss {
    return Intl.message(
      'Best Women\'s Watches collections',
      name: 'bestWomensWatchesCollectionss',
      desc: '',
      args: [],
    );
  }

  /// `Women's Watches`
  String get womensWatches {
    return Intl.message(
      'Women\'s Watches',
      name: 'womensWatches',
      desc: '',
      args: [],
    );
  }

  /// `Best Men's sunglasses collections`
  String get bestMensSunglassesCollections {
    return Intl.message(
      'Best Men\'s sunglasses collections',
      name: 'bestMensSunglassesCollections',
      desc: '',
      args: [],
    );
  }

  /// `Men's Sunglasses`
  String get mensSunglasses {
    return Intl.message(
      'Men\'s Sunglasses',
      name: 'mensSunglasses',
      desc: '',
      args: [],
    );
  }

  /// `Best Women's sunglasses collections`
  String get bestWomensSunglassesCollections {
    return Intl.message(
      'Best Women\'s sunglasses collections',
      name: 'bestWomensSunglassesCollections',
      desc: '',
      args: [],
    );
  }

  /// `Women's Sunglasses`
  String get womensSunglasses {
    return Intl.message(
      'Women\'s Sunglasses',
      name: 'womensSunglasses',
      desc: '',
      args: [],
    );
  }

  /// `Add the finishing touch to your look with our Range`
  String get addTheFinishingTouchToYourLookWithnourRange {
    return Intl.message(
      'Add the finishing touch to your look with our Range',
      name: 'addTheFinishingTouchToYourLookWithnourRange',
      desc: '',
      args: [],
    );
  }

  /// `Perfumes`
  String get perfumes {
    return Intl.message(
      'Perfumes',
      name: 'perfumes',
      desc: '',
      args: [],
    );
  }

  /// `Shoes from the best brands, Must have shoes for every one`
  String get shoesFromTheBestBrandsMustHavenshoesForEvery {
    return Intl.message(
      'Shoes from the best brands, Must have shoes for every one',
      name: 'shoesFromTheBestBrandsMustHavenshoesForEvery',
      desc: '',
      args: [],
    );
  }

  /// `Women's Shoes`
  String get womensShoes {
    return Intl.message(
      'Women\'s Shoes',
      name: 'womensShoes',
      desc: '',
      args: [],
    );
  }

  /// `Discover our bags for women vibrant designs`
  String get discoverOurBagsForWomenVibrantDesigns {
    return Intl.message(
      'Discover our bags for women vibrant designs',
      name: 'discoverOurBagsForWomenVibrantDesigns',
      desc: '',
      args: [],
    );
  }

  /// `Women's Bags`
  String get womensBags {
    return Intl.message(
      'Women\'s Bags',
      name: 'womensBags',
      desc: '',
      args: [],
    );
  }

  /// `Push yourself further with our trendy sportswear`
  String get pushYourselfFurtherWithOurTrendySportswear {
    return Intl.message(
      'Push yourself further with our trendy sportswear',
      name: 'pushYourselfFurtherWithOurTrendySportswear',
      desc: '',
      args: [],
    );
  }

  /// `Women's Sportswear`
  String get womensSportswear {
    return Intl.message(
      'Women\'s Sportswear',
      name: 'womensSportswear',
      desc: '',
      args: [],
    );
  }

  /// `Match the daily journey with our kids essential`
  String get matchTheDailyJourneyWithOurKidsNessential {
    return Intl.message(
      'Match the daily journey with our kids essential',
      name: 'matchTheDailyJourneyWithOurKidsNessential',
      desc: '',
      args: [],
    );
  }

  /// `Kid's Collections`
  String get kidsCollections {
    return Intl.message(
      'Kid\'s Collections',
      name: 'kidsCollections',
      desc: '',
      args: [],
    );
  }

  /// `Shop the latest and trend Women's Europe Fashion`
  String get shopTheLatestAndTrendWomensneuropeFashion {
    return Intl.message(
      'Shop the latest and trend Women\'s Europe Fashion',
      name: 'shopTheLatestAndTrendWomensneuropeFashion',
      desc: '',
      args: [],
    );
  }

  /// `Europe Fashion`
  String get europeFashion {
    return Intl.message(
      'Europe Fashion',
      name: 'europeFashion',
      desc: '',
      args: [],
    );
  }

  /// `Latest Additions to our Women's style USA`
  String get latestAdditionsToOurWomensnstyleUsa {
    return Intl.message(
      'Latest Additions to our Women\'s style USA',
      name: 'latestAdditionsToOurWomensnstyleUsa',
      desc: '',
      args: [],
    );
  }

  /// `Fashion USA`
  String get fashionUsa {
    return Intl.message(
      'Fashion USA',
      name: 'fashionUsa',
      desc: '',
      args: [],
    );
  }

  /// `Men's Collections`
  String get mensCollections {
    return Intl.message(
      'Men\'s Collections',
      name: 'mensCollections',
      desc: '',
      args: [],
    );
  }

  /// `Discover a wide range of high-quality Men Collection`
  String get discoverAWideRangeOfHighqualitynmenCollection {
    return Intl.message(
      'Discover a wide range of high-quality Men Collection',
      name: 'discoverAWideRangeOfHighqualitynmenCollection',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get colors {
    return Intl.message(
      'Colors',
      name: 'colors',
      desc: '',
      args: [],
    );
  }

  /// `No Colors Available`
  String get noColorsAvailable {
    return Intl.message(
      'No Colors Available',
      name: 'noColorsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Search product here?`
  String get searchProductHere {
    return Intl.message(
      'Search product here?',
      name: 'searchProductHere',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}