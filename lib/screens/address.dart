import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/data_model/city_response.dart';
import 'package:marekat/data_model/country_response.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/address_repositories.dart';
import 'package:marekat/ui_sections/loader.dart';

class Address extends StatefulWidget {
  Address({Key key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  ScrollController _mainScrollController = ScrollController();

  int _default_shipping_address = 0;
  City _selected_city;
  Country _selected_country;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];
  String _selected_city_name = "";
  String _selected_country_name = "";

  Country getCountryById(String id) =>
      _countryList.firstWhere((country) => country.id == id);

  Country getCountryByPartialName(String partial_name) =>
      _countryList.firstWhere((country) => country.name == partial_name);

  List<Country> getCountriesByPartialName(String partial_name) =>
      _countryList.where((country) => country.name == partial_name).toList();

  City getCityById(String id) => _cityList.firstWhere((city) => city.id == id);

  City getCityByPartialName(String partial_name) =>
      _cityList.firstWhere((city) => city.name == partial_name);

  List<City> getCitiesByPartialName(String partial_name) =>
      _cityList.where((city) => city.name == partial_name).toList();

  //controllers for add purpose
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<String> _selected_city_name_list_for_update = [];
  List<String> _selected_country_name_list_for_update = [];
  List<City> _selected_city_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  // for current location
  TextEditingController _mobileNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    fetchCityList();
    fetchCountryList();
    //_isInitial = false;
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    if (_shippingAddressList.length > 0) {
      _default_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _default_shipping_address = address.id;
        }
        _addressControllerListForUpdate
            .add(TextEditingController(text: address.address));
        _postalCodeControllerListForUpdate
            .add(TextEditingController(text: address.postal_code));
        _phoneControllerListForUpdate
            .add(TextEditingController(text: address.phone));
        _selected_city_name_list_for_update.add(address.city);
        _selected_city_list_for_update.add(getCityByPartialName(address.city));
        _selected_country_name_list_for_update.add(address.country);
        _selected_country_list_for_update
            .add(getCountryByPartialName(address.country));
      });
    }

    setState(() {});
  }

  fetchCityList() async {
    var cityResponse = await AddressRepository().getCityList();

    _cityList.addAll(cityResponse.cities);
    setState(() {});
  }

  fetchCountryList() async {
    var countryResponse = await AddressRepository().getCountryList();

    _countryList.addAll(countryResponse.countries);
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
    }
    _isInitial = false;
    setState(() {});
  }

  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _countryList.clear();
    _selected_city_name = "";
    _selected_country_name = "";
    _isInitial = true;

    //update-ables
    _addressControllerListForUpdate.clear();
    _postalCodeControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _selected_city_name_list_for_update.clear();
    _selected_country_name_list_for_update.clear();
    _selected_city_list_for_update.clear();
    _selected_country_list_for_update.clear();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    // reset();
    // fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  afterDeletingAnAddress() {
    reset();
    fetchAll();
  }

  afterUpdatingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse = await AddressRepository()
        .getAddressMakeDefaultResponse(_default_shipping_address);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(addressMakeDefaultResponse.message);
      return;
    }

    ToastComponent.showDialog(addressMakeDefaultResponse.message);

    setState(() {
      _default_shipping_address = _shippingAddressList[index].id;
    });
  }

  onPressDelete(id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  S.of(context).areYouSureToRemoveThisAddress,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    confirmDelete(id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(id) async {
    Loader.showLoaderDialog(context);
    var addressDeleteResponse =
        await AddressRepository().getAddressDeleteResponse(id);

    if (addressDeleteResponse.result == false) {
      ToastComponent.showDialog(addressDeleteResponse.message);
      return;
    }

    ToastComponent.showDialog(addressDeleteResponse.message);

    afterDeletingAnAddress();
    Loader.dismissDialog(context);
  }

  onAddressAdd(context) async {
    var address = _addressController.text.toString();
    var postal_code = _postalCodeController.text.toString();
    var phone = _phoneController.text.toString();

    if (address == "") {
      ToastComponent.showDialog(S.of(context).enterAddress);
      return;
    }

    if (_selected_city_name == "") {
      ToastComponent.showDialog(S.of(context).selectACity);
      return;
    }

    if (_selected_country_name == "") {
      ToastComponent.showDialog(S.of(context).selectACountry);
      return;
    }
    Loader.showLoaderDialog(context);
    var addressAddResponse = await AddressRepository().getAddressAddResponse(
        address,
        _selected_country_name,
        _selected_city_name,
        postal_code,
        phone);
    Loader.dismissDialog(context);

    if (addressAddResponse.result == false) {
      ToastComponent.showDialog(addressAddResponse.message);
      return;
    }

    ToastComponent.showDialog(addressAddResponse.message);

    Navigator.of(context).pop();
    afterAddingAnAddress();
  }

  onAddressUpdate(context, index, id) async {
    var address = _addressControllerListForUpdate[index].text.toString();
    var postal_code = _postalCodeControllerListForUpdate[index].text.toString();
    var phone = _phoneControllerListForUpdate[index].text.toString();

    if (address == "") {
      ToastComponent.showDialog(S.of(context).enterAddress);
      return;
    }

    if (_selected_city_name_list_for_update[index] == "") {
      ToastComponent.showDialog(S.of(context).selectACity);
      return;
    }

    if (_selected_country_name_list_for_update[index] == "") {
      ToastComponent.showDialog(S.of(context).selectACountry);
      return;
    }
    Loader.showLoaderDialog(context);
    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateResponse(
            id,
            address,
            _selected_country_name_list_for_update[index],
            _selected_city_name_list_for_update[index],
            postal_code,
            phone);

    Loader.dismissDialog(context);

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message);

    Navigator.of(context).pop();
    afterUpdatingAnAddress();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          displacement: 0,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildAddressList(),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width - 16,
                        height: 50,
                        color: Color.fromRGBO(252, 252, 252, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Icon(
                          FontAwesome.plus,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                        onPressed: () {
                          buildShowAddFormDialog(context);
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _getMyCurrentLocation();
                        },
                        icon: Icon(
                          Icons.my_location,
                          size: 16,
                        ),
                        label: Text(
                          "GET MY LOCATION",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ]))
            ],
          ),
        ));
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).address,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: S.of(context).enterAddress,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0,
                                    top: 16.0,
                                    bottom: 16.0,
                                    right: 8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).city,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<City>(
                            items: _cityList,
                            maxHeight: 300,
                            label: S.of(context).selectACity,
                            showSearchBox: true,
                            selectedItem: _selected_city,
                            dropdownSearchDecoration: InputDecoration(
                                hintText: S.of(context).enterCity,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                            onChanged: (City city) {
                              setState(() {
                                _selected_city = city;
                                _selected_city_name = city.name;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).postalCode,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _postalCodeController,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: S.of(context).enterPostalCode,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).country,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<Country>(
                            items: _countryList,
                            maxHeight: 300,
                            label: S.of(context).selectACountry,
                            showSearchBox: true,
                            selectedItem: _selected_country,
                            dropdownSearchDecoration: InputDecoration(
                                hintText: S.of(context).enterPostalCode,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                            onChanged: (Country country) {
                              setState(() {
                                _selected_country = country;
                                _selected_country_name = country.name;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).phone,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _phoneController,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: S.of(context).enterPhone,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MaterialButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Text(
                          S.of(context).close,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: MaterialButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Text(
                          S.of(context).add,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressAdd(context);
                        },
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  Future buildShowUpdateFormDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).address,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: S.of(context).enterAddress,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).city,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<City>(
                            items: _cityList,
                            maxHeight: 300,
                            label: S.of(context).selectACity,
                            showSearchBox: true,
                            selectedItem: _selected_city_list_for_update[index],
                            dropdownSearchDecoration: InputDecoration(
                                hintText: S.of(context).enterCity,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                            onChanged: (City city) {
                              setState(() {
                                _selected_city_list_for_update[index] = city;
                                _selected_city_name_list_for_update[index] =
                                    city.name;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).postalCode,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller:
                                _postalCodeControllerListForUpdate[index],
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: S.of(context).enterPostalCode,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).country,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<Country>(
                            items: _countryList,
                            maxHeight: 300,
                            label: S.of(context).selectACountry,
                            showSearchBox: true,
                            selectedItem:
                                _selected_country_list_for_update[index],
                            dropdownSearchDecoration: InputDecoration(
                                hintText: S.of(context).enterPostalCode,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                            onChanged: (Country country) {
                              setState(() {
                                _selected_country_list_for_update[index] =
                                    country;
                                _selected_country_name_list_for_update[index] =
                                    country.name;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(S.of(context).phone,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: S.of(context).enterPhone,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 8.0, right: 8)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MaterialButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Text(
                          S.of(context).close,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: MaterialButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Text(
                          S.of(context).update,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressUpdate(
                              context, index, _shippingAddressList[index].id);
                        },
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Column(
        children: [
          Text(
            S.of(context).addressesOfUser,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
          Text(
            S.of(context).doubleTapOnAnAddressToMakeItDefault,
            style: TextStyle(fontSize: 10, color: MyTheme.medium_grey),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildAddressList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            S.of(context).pleaseLogInToSeeTheCartItems,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 4, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildAddressItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            S.of(context).noAddressesIsAdded,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildAddressItemCard(index) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index].id) {
          onAddressSwitch(index);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _default_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            S.of(context).address,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                              right: langCode.$ == "ar" ? 0 : 28,
                              left: langCode.$ == "ar" ? 28 : 0,
                            ),
                            child: Text(
                              _shippingAddressList[index].address,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.dark_grey,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            S.of(context).city,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _shippingAddressList[index].city,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.dark_grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            S.of(context).postalCode,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _shippingAddressList[index].postal_code,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.dark_grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            S.of(context).country,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _shippingAddressList[index].country,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.dark_grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            S.of(context).phone,
                            style: TextStyle(
                              color: MyTheme.grey_153,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _shippingAddressList[index].phone,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.dark_grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                right: isRTL ? null : 0.0,
                top: 0.0,
                left: isRTL ? 0.0 : null,
                child: InkWell(
                  onTap: () {
                    buildShowUpdateFormDialog(context, index);
                    //Toast.show("hello $index", context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.edit,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )),
            Positioned(
                right: isRTL ? null : 0,
                top: 40.0,
                left: isRTL ? 0 : null,
                child: InkWell(
                  onTap: () {
                    onPressDelete(_shippingAddressList[index].id);
                    //Toast.show("index $index", context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 16,
                            width: 16,
                            child: SvgPicture.asset(
                              "assets/recycle_bin.svg",
                              color: MyTheme.dark_grey,
                            ),
                          )),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _getMyCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var add = "";

    Loader.showLoaderDialog(context);
    _locationData = await location.getLocation();
    final address4 = await http.get(
        Uri.parse("https://maps.googleapis"
            ".com/maps/api/geocode/json?latlng=${_locationData.latitude},"
            "${_locationData.longitude}&key=${AppConfig.GOOGLE_API_KEY}"),
        headers: {"Accept-Language": langCode.$});
    if (address4.statusCode == HttpStatus.ok) {
      final json = jsonDecode(address4.body);
      if (json["results"].length > 0) {
        add = json["results"][0]["formatted_address"].toString();
      }
    }
    Loader.dismissDialog(context);
    _addressController.text = add;
    buildShowAddFormDialog(context);
  }
}
