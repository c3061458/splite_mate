import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/friends/get_all_friends_model.dart';
import 'package:splite_mate/models/group/get_all_groups_model.dart';
import 'package:splite_mate/models/payment/add_payment_request_model.dart';
import 'package:splite_mate/models/payment/get_currency_rate_model.dart';
import 'package:splite_mate/services/api/friend.dart';
import 'package:splite_mate/services/api/group.dart';
import 'package:splite_mate/services/api/payment.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/config.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String amount = "";
  String mobile = "";
  String desc = "";
  bool isChecked = true;
  bool isChecked2 = false;
  bool _isLoading = true;
  SharedServices sharedServices = SharedServices();
  LoginResponseModel loginResponseModel = LoginResponseModel();
  final TextEditingController _amountController = TextEditingController();
  GetAllGroupsModel groupModel = GetAllGroupsModel();
  GetAllFriendsModel friendsModel = GetAllFriendsModel();
  GetCurrencyRateModel currencyRateModel = GetCurrencyRateModel();
  final _formKey = GlobalKey<FormState>();
  List<int> friendIds = [];
  int groupId = 0;
  int memberCount = 0;
  double payableAmount = 0;

  String selectedCurrency = "GBP";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        if (ModalRoute.of(context)!.settings.arguments != null) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          amount = args['amount']!;
          _amountController.text = amount;
          setState(() {});
          getCurrency();
        } else {
          setState(() {});
          getCurrency();
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.loginRoute, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void setAmount() {
    if (amount.isEmpty || amount == "" || double.parse(amount) <= 0) {
      print(selectedCurrency);
    } else {
      // print((double.parse(amount) / currencyRateModel.conversionRates!.AED!));
      // print(selectedCurrency);
      printCurrencyName(selectedCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar2.myAppBar(context, "Payment"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Currency",
                        style: MyTextStyle.formLabel(),
                      ),
                      DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyThemes.customPrimary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButton(
                      value: selectedCurrency,
                      underline: const SizedBox(),
                      isDense: true,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 19.0),
                      items: Config.currencyList.map((String value) {
                        if (value == selectedCurrency) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurrency = value!;
                        });
                        setAmount();
                      },
                    ),
                  ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Description",
                        style: MyTextStyle.formLabel(),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        cursorColor: MyThemes.customPrimary,
                        decoration: MyInputStyle.textFormField(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value == "" || value.isEmpty) {
                            return "Please enter description";
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() {
                          desc = value;
                        }),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Amount",
                        style: MyTextStyle.formLabel(),
                      ),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        cursorColor: MyThemes.customPrimary,
                        decoration: MyInputStyle.textFormField(),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value == "" || value.isEmpty) {
                            return "Please enter amount";
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() {
                          amount = value;
                          setAmount();
                        }),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add New Friend",
                              style: MyTextStyle.formLabel(),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: MyThemes.customPrimary,
                              decoration: InputDecoration(
                                hintText: "Mobile Number",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: MyThemes.customPrimary,
                                      width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: MyThemes.customPrimary,
                                      width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: MyThemes.customPrimary,
                                      width: 3.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 3.0),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null ||
                                    value == "" ||
                                    value.isEmpty) {
                                  return "Please enter amount";
                                }
                                return null;
                              },
                              onChanged: (value) => setState(() {
                                mobile = value;
                              }),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ElevatedButton(
                              onPressed: () => addFriend(),
                              style: MyButtonStyle.elevatedButton(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    CupertinoIcons.person_add,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Add Friend",
                                    style: MyTextStyle.elevatedButtonText(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        onPressed: () => managePayment(context),
                        style: MyButtonStyle.elevatedButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.purchased,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Pay",
                              style: MyTextStyle.elevatedButtonText(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "*Note: Payment can be split between multiple friends or a Group",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.red),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Groups",
                        style: MyTextStyle.lightSubHeading(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: groupModel.groups != null ? groupModel.groups!.length : 0,
                          itemBuilder: (context, index) => Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 75.0,
                                        width: 75.0,
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.circular(40.0),
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.group,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            groupModel.groups![index]!.groupName!,
                                            style: MyTextStyle.elevatedButtonText(),
                                          ),
                                          Text(
                                            "Members: ${groupModel.groups![index]!.memberCount!.toString()}",
                                            style: MyTextStyle.heading2(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: groupId == groupModel.groups![index]!.groupId,
                                    onChanged: (value) {
                                      if (value == true) {
                                        setState(() {
                                          groupId = groupModel.groups![index]!.groupId!;
                                          memberCount = groupModel.groups![index]!.memberCount!;
                                          friendIds = [];
                                        });
                                      } else {
                                        setState(() {
                                          groupId = 0;
                                          memberCount = 0;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Divider(),
                            ],
                          ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Friends",
                        style: MyTextStyle.lightSubHeading(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: friendsModel.friends != null ? friendsModel.friends!.length : 0,
                          itemBuilder: (context, index) => Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(100.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: const Offset(
                                                0,
                                                0,
                                              ), // Changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(81.0),
                                          child:
                                          friendsModel.friends![index]!.gender == "male"
                                              ? Image.asset(
                                            "assets/images/male.jpg",
                                            height: 50.0,
                                          )
                                              : Image.asset(
                                            "assets/images/female.jpg",
                                            height: 50.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friendsModel.friends![index]!.userName!,
                                            style: MyTextStyle.elevatedButtonText(),
                                          ),
                                          Text(
                                            friendsModel.friends![index]!.mobile!.toString(),
                                            style: MyTextStyle.heading2(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: friendIds.contains(friendsModel.friends![index]!.userId),
                                    onChanged: (value) {
                                      if (value == true) {
                                        setState(() {
                                          groupId = 0;
                                          memberCount = 0;
                                          if (!friendIds.contains(friendsModel.friends![index]!.userId)) {
                                            friendIds.add(friendsModel.friends![index]!.userId!);
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          groupId = 0;
                                          memberCount = 0;
                                          friendIds.remove(friendsModel.friends![index]!.userId);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Divider(),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  managePayment(context) {
    if (amount.isEmpty || amount == "" || double.parse(amount) <= 0) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Sorry",
        text: "Please enter a valid amount",
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        textColor: Colors.black,
        confirmBtnText: "Okay",
        confirmBtnColor: MyThemes.customPrimary,
        disableBackBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        },
      );
    } else {
      String a = friendIds.isEmpty ? groupId == 0 ? payableAmount.toStringAsFixed(2) : (payableAmount / memberCount).toStringAsFixed(2) : (payableAmount / (friendIds.length + 1)).toStringAsFixed(2);
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: MyTextStyle.formLabel(),
                        ),
                        Text(
                          amount,
                          style: MyTextStyle.formLabel(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Splite among",
                          style: MyTextStyle.formLabel(),
                        ),
                        Text(
                          friendIds.isNotEmpty ? (friendIds.length + 1).toString() : groupId != 0 ?memberCount.toString() : "None",
                          style: MyTextStyle.formLabel(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount to pay",
                          style: MyTextStyle.heading2(),
                        ),
                        Text(
                          a,
                          style: MyTextStyle.heading2(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: MyButtonStyle.elevatedButton(),
                      onPressed: () => addPayment(),
                      child: Text(
                        'Make Payment',
                        style: MyTextStyle.elevatedButtonText(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void getFriends() {
    FriendAPIServices.getFriends(loginResponseModel.token!).then(
      (response) {
        if (response.friends != null) {
          friendsModel = response;
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: "No Friend Found",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }

  void getGroups() {
    setState(() {
      _isLoading = true;
    });
    GroupAPIServices.getAllGroups(loginResponseModel.token!).then(
      (response) {
        if (response.groups != null) {
          groupModel = response;
          getFriends();
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: "No Groups found",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              getFriends();
            },
          );
        }
      },
    );
  }

  void addFriend() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      FriendAPIServices.addFriend(mobile, loginResponseModel.token!).then(
        (response) {
          if (response.message == "Friend added successfully") {
            getFriends();
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "Sorry",
              text:
                  response.message ?? response.error ?? "Something went wrong",
              backgroundColor: Colors.white,
              titleColor: Colors.black,
              textColor: Colors.black,
              confirmBtnText: "Okay",
              confirmBtnColor: MyThemes.customPrimary,
              disableBackBtn: true,
              onConfirmBtnTap: () {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              },
            );
          }
        },
      );
    }
  }

  addPayment() {
    AddPaymentRequestModelSplits splits = AddPaymentRequestModelSplits();
    if (friendIds.isEmpty && groupId != 0)  {
      splits.amount =  payableAmount;
      splits.groupId = groupId;
    } else {
      friendIds.add(loginResponseModel.user!.userId!);
      splits.amount =  payableAmount;
      splits.userId = friendIds;
    }

    AddPaymentRequestModel paymentRequestModel = AddPaymentRequestModel(
      amount: payableAmount,
      description: desc,
      splits: [splits]
    );
    print(jsonEncode(paymentRequestModel));
    PaymentAPIServices.createPayment(paymentRequestModel, loginResponseModel.token!).then((response) {
      if (response.message == "Payment recorded successfully") {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Success",
          text: response.message,
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
          confirmBtnText: "Okay",
          confirmBtnColor: MyThemes.customPrimary,
          disableBackBtn: true,
          onConfirmBtnTap: () {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Sorry",
          text: response.message ?? response.error ?? "Something went wrong",
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
          confirmBtnText: "Okay",
          confirmBtnColor: MyThemes.customPrimary,
          disableBackBtn: true,
          onConfirmBtnTap: () {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context);
          },
        );
      }
    },);
  }

  void getCurrency() {
    PaymentAPIServices.getCurrency(loginResponseModel.token!).then((response) {
      if (response.result != "Fail") {
        setState(() {
          currencyRateModel = response;
        });
        getGroups();
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Sorry",
          text: "Multi currency not supported for this payment",
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
          confirmBtnText: "Okay",
          confirmBtnColor: MyThemes.customPrimary,
          disableBackBtn: true,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            getGroups();
          },
        );
      }
    },);
  }

  void printCurrencyName(String currencyCode) {
    switch (currencyCode) {
      case 'GBP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GBP!);
        setState(() {});
        break;
      case 'AED':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AED!);
        setState(() {});
        break;
      case 'AFN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AFN!);
        setState(() {});
        break;
      case 'ALL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ALL!);
        setState(() {});
        break;
      case 'AMD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AMD!);
        setState(() {});
        break;
      case 'ANG':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ANG!);
        setState(() {});
        break;
      case 'AOA':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AOA!);
        setState(() {});
        break;
      case 'ARS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ARS!);
        setState(() {});
        break;
      case 'AUD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AUD!);
        setState(() {});
        break;
      case 'AWG':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AWG!);
        setState(() {});
        break;
      case 'AZN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.AZN!);
        setState(() {});
        break;
      case 'BAM':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BAM!);
        setState(() {});
        break;
      case 'BBD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BBD!);
        setState(() {});
        break;
      case 'BDT':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BDT!);
        setState(() {});
        break;
      case 'BGN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BGN!);
        setState(() {});
        break;
      case 'BHD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BHD!);
        setState(() {});
        break;
      case 'BIF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BIF!);
        setState(() {});
        break;
      case 'BMD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BMD!);
        setState(() {});
        break;
      case 'BND':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BND!);
        setState(() {});
        break;
      case 'BOB':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BOB!);
        setState(() {});
        break;
      case 'BRL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BRL!);
        setState(() {});
        break;
      case 'BSD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BSD!);
        setState(() {});
        break;
      case 'BTN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BTN!);
        setState(() {});
        break;
      case 'BWP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BWP!);
        setState(() {});
        break;
      case 'BYN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BYN!);
        setState(() {});
        break;
      case 'BZD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.BZD!);
        setState(() {});
        break;
      case 'CAD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CAD!);
        setState(() {});
        break;
      case 'CDF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CDF!);
        setState(() {});
        break;
      case 'CHF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CHF!);
        setState(() {});
        break;
      case 'CLP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CLP!);
        setState(() {});
        break;
      case 'CNY':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CNY!);
        setState(() {});
        break;
      case 'COP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.COP!);
        setState(() {});
        break;
      case 'CRC':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CRC!);
        setState(() {});
        break;
      case 'CUP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CUP!);
        setState(() {});
        break;
      case 'CVE':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CVE!);
        setState(() {});
        break;
      case 'CZK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.CZK!);
        setState(() {});
        break;
      case 'DJF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.DJF!);
        setState(() {});
        break;
      case 'DKK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.DKK!);
        setState(() {});
        break;
      case 'DOP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.DOP!);
        setState(() {});
        break;
      case 'DZD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.DZD!);
        setState(() {});
        break;
      case 'EGP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.EGP!);
        setState(() {});
        break;
      case 'ERN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ERN!);
        setState(() {});
        break;
      case 'ETB':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ETB!);
        setState(() {});
        break;
      case 'EUR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.EUR!);
        setState(() {});
        break;
      case 'FJD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.FJD!);
        setState(() {});
        break;
      case 'FKP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.FKP!);
        setState(() {});
        break;
      case 'FOK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.FOK!);
        setState(() {});
        break;
      case 'GEL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GEL!);
        setState(() {});
        break;
      case 'GGP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GGP!);
        setState(() {});
        break;
      case 'GHS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GHS!);
        setState(() {});
        break;
      case 'GIP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GIP!);
        setState(() {});
        break;
      case 'GMD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GMD!);
        setState(() {});
        break;
      case 'GNF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GNF!);
        setState(() {});
        break;
      case 'GTQ':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GTQ!);
        setState(() {});
        break;
      case 'GYD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.GYD!);
        setState(() {});
        break;
      case 'HKD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.HKD!);
        setState(() {});
        break;
      case 'HNL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.HNL!);
        setState(() {});
        break;
      case 'HRK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.HRK!);
        setState(() {});
        break;
      case 'HTG':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.HTG!);
        setState(() {});
        break;
      case 'HUF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.HUF!);
        setState(() {});
        break;
      case 'IDR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.IDR!);
        setState(() {});
        break;
      case 'ILS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ILS!);
        setState(() {});
        break;
      case 'INR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.INR!);
        setState(() {});
        break;
      case 'IQD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.IQD!);
        setState(() {});
        break;
      case 'IRR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.IRR!);
        setState(() {});
        break;
      case 'ISK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ISK!);
        setState(() {});
        break;
      case 'JEP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.JEP!);
        setState(() {});
        break;
      case 'JMD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.JMD!);
        setState(() {});
        break;
      case 'JOD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.JOD!);
        setState(() {});
        break;
      case 'JPY':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.JPY!);
        setState(() {});
        break;
      case 'KES':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KES!);
        setState(() {});
        break;
      case 'KGS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KGS!);
        setState(() {});
        break;
      case 'KHR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KHR!);
        setState(() {});
        break;
      case 'KID':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KID!);
        setState(() {});
        break;
      case 'KMF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KMF!);
        setState(() {});
        break;
      case 'KRW':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KRW!);
        setState(() {});
        break;
      case 'KWD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KWD!);
        setState(() {});
        break;
      case 'KYD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KYD!);
        setState(() {});
        break;
      case 'KZT':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.KZT!);
        setState(() {});
        break;
      case 'LAK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.LAK!);
        setState(() {});
        break;
      case 'LBP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.LBP!);
        setState(() {});
        break;
      case 'LKR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.LKR!);
        setState(() {});
        break;
      case 'LRD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.LRD!);
        setState(() {});
        break;
      case 'LSL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.LSL!);
        setState(() {});
        break;
      case 'MAD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MAD!);
        setState(() {});
        break;
      case 'MDL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MDL!);
        setState(() {});
        break;
      case 'MGA':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MGA!);
        setState(() {});
        break;
      case 'MKD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MKD!);
        setState(() {});
        break;
      case 'MMK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MMK!);
        setState(() {});
        break;
      case 'MNT':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MNT!);
        setState(() {});
        break;
      case 'MOP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MOP!);
        setState(() {});
        break;
      case 'MRU':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MRU!);
        setState(() {});
        break;
      case 'MUR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MUR!);
        setState(() {});
        break;
      case 'MVR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MVR!);
        setState(() {});
        break;
      case 'MWK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MWK!);
        setState(() {});
        break;
      case 'MXN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MXN!);
        setState(() {});
        break;
      case 'MYR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MYR!);
        setState(() {});
        break;
      case 'MZN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.MZN!);
        setState(() {});
        break;
      case 'NAD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NAD!);
        setState(() {});
        break;
      case 'NGN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NGN!);
        setState(() {});
        break;
      case 'NIO':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NIO!);
        setState(() {});
        break;
      case 'NOK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NOK!);
        setState(() {});
        break;
      case 'NPR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NPR!);
        setState(() {});
        break;
      case 'NZD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.NZD!);
        setState(() {});
        break;
      case 'OMR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.OMR!);
        setState(() {});
        break;
      case 'PAB':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PAB!);
        setState(() {});
        break;
      case 'PEN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PEN!);
        setState(() {});
        break;
      case 'PGK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PGK!);
        setState(() {});
        break;
      case 'PHP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PHP!);
        setState(() {});
        break;
      case 'PKR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PKR!);
        setState(() {});
        break;
      case 'PLN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PLN!);
        setState(() {});
        break;
      case 'PYG':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.PYG!);
        setState(() {});
        break;
      case 'QAR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.QAR!);
        setState(() {});
        break;
      case 'RON':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.RON!);
        setState(() {});
        break;
      case 'RSD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.RSD!);
        setState(() {});
        break;
      case 'RUB':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.RUB!);
        setState(() {});
        break;
      case 'RWF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.RWF!);
        setState(() {});
        break;
      case 'SAR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SAR!);
        setState(() {});
        break;
      case 'SBD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SBD!);
        setState(() {});
        break;
      case 'SCR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SCR!);
        setState(() {});
        break;
      case 'SDG':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SDG!);
        setState(() {});
        break;
      case 'SEK':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SEK!);
        setState(() {});
        break;
      case 'SGD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SGD!);
        setState(() {});
        break;
      case 'SHP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SHP!);
        setState(() {});
        break;
      case 'SLL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SLL!);
        setState(() {});
        break;
      case 'SOS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SOS!);
        setState(() {});
        break;
      case 'SRD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SRD!);
        setState(() {});
        break;
      case 'SSP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SSP!);
        setState(() {});
        break;
      case 'STN':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.STN!);
        setState(() {});
        break;
      case 'SYP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SYP!);
        setState(() {});
        break;
      case 'SZL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.SZL!);
        setState(() {});
        break;
      case 'THB':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.THB!);
        setState(() {});
        break;
      case 'TJS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TJS!);
        setState(() {});
        break;
      case 'TMT':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TMT!);
        setState(() {});
        break;
      case 'TND':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TND!);
        setState(() {});
        break;
      case 'TOP':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TOP!);
        setState(() {});
        break;
      case 'TRY':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TRY!);
        setState(() {});
        break;
      case 'TTD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TTD!);
        setState(() {});
        break;
      case 'TVD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TVD!);
        setState(() {});
        break;
      case 'TZS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.TZS!);
        setState(() {});
        break;
      case 'UAH':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.UAH!);
        setState(() {});
        break;
      case 'UGX':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.UGX!);
        setState(() {});
        break;
      case 'USD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.USD!);
        setState(() {});
        break;
      case 'UYU':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.UYU!);
        setState(() {});
        break;
      case 'UZS':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.UZS!);
        setState(() {});
        break;
      case 'VES':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.VES!);
        setState(() {});
        break;
      case 'VND':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.VND!);
        setState(() {});
        break;
      case 'VUV':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.VUV!);
        setState(() {});
        break;
      case 'WST':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.WST!);
        setState(() {});
        break;
      case 'XAF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.XAF!);
        setState(() {});
        break;
      case 'XCD':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.XCD!);
        setState(() {});
        break;
      case 'XDR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.XDR!);
        setState(() {});
        break;
      case 'XOF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.XOF!);
        setState(() {});
        break;
      case 'XPF':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.XPF!);
        setState(() {});
        break;
      case 'YER':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.YER!);
        setState(() {});
        break;
      case 'ZAR':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ZAR!);
        setState(() {});
        break;
      case 'ZMW':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ZMW!);
        setState(() {});
        break;
      case 'ZWL':
        payableAmount = (double.parse(amount) / currencyRateModel.conversionRates!.ZWL!);
        setState(() {});
        break;
    }
  }
}
