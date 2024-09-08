import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/transaction/get_accounts_model.dart';
import 'package:splite_mate/services/api/budget.dart';
import 'package:splite_mate/services/api/payment.dart';
import 'package:splite_mate/services/api/transaction.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isValidImage = true;
  XFile? _pickedImage;
  bool _isLoading = true;

  SharedServices sharedServices = SharedServices();

  LoginResponseModel loginResponseModel = LoginResponseModel();

  GetAccountsModel accountsModel = GetAccountsModel();

  int budget = -1;
  int budgetId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        getData(loginResponseModel, context);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.loginRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar.myAppBar(context, "Payment"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Payment Management",
                        style: MyTextStyle.heading2(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () => manageBudget(context),
                        style: MyButtonStyle.outlinedButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.purchased,
                              color: MyThemes.customPrimary,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Manage Budget",
                              style: MyTextStyle.outlinedButtonText(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () => scanBill(),
                        style: MyButtonStyle.elevatedButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.switch_camera,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Scan Bill",
                              style: MyTextStyle.elevatedButtonText(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, MyRoutes.paymentRoute),
                        style: MyButtonStyle.outlinedButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.add_circled,
                              color: MyThemes.customPrimary,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Add Payment",
                              style: MyTextStyle.outlinedButtonText(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(),
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
                        itemCount: accountsModel.data!.length,
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
                                        borderRadius:
                                            BorderRadius.circular(100.0),
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
                                        borderRadius:
                                            BorderRadius.circular(81.0),
                                        child: accountsModel
                                                    .data![index]!.gender ==
                                                "male"
                                            ? Image.asset(
                                                "assets/images/male.jpg",
                                                height: 75.0,
                                              )
                                            : Image.asset(
                                                "assets/images/female.jpg",
                                                height: 75.0,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      accountsModel
                                          .data![index]!.involvedUserName!,
                                      style: MyTextStyle.elevatedButtonText(),
                                    ),
                                  ],
                                ),
                                Text(
                                  (double.parse(accountsModel
                                              .data![index]!.totalAmount!) >=
                                          0
                                      ? '£${accountsModel.data![index]!.totalAmount!}'
                                      : '-£${accountsModel.data![index]!.totalAmount!.substring(1)}'),
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w900,
                                    color: double.parse(accountsModel
                                                .data![index]!.totalAmount!) >=
                                            0
                                        ? Colors
                                            .green // Green for positive amounts
                                        : Colors
                                            .red, // Red for negative amounts
                                  ),
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

  manageBudget(context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Save',
      customAsset: 'assets/images/budget.jpg',
      widget: TextFormField(
        initialValue: budget.toString(),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MyThemes.customAccent, width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MyThemes.customAccent, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: MyThemes.customAccent, width: 3.0),
          ),
          alignLabelWithHint: true,
          hintText: 'Budget',
          prefixIcon: const Icon(
            CupertinoIcons.money_pound,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            budget = int.parse(value);
          });
        },
      ),
      onConfirmBtnTap: () => setBudget(),
    );
  }

  scanBill() {
    _showPicker();
  }

  Future<void> _showPicker() async {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/uploadImage.jpg"),
            Text(
              "Please choose image source",
              style: MyTextStyle.heading2(),
            )
          ],
        ),
        // title: Text('Choose Image Source'),
        actions: [
          ElevatedButton(
            style: MyButtonStyle.elevatedButton3(),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text(
              "Camera",
              style: MyTextStyle.elevatedButtonText2(),
            ),
          ),
          ElevatedButton(
            style: MyButtonStyle.elevatedButton3(),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text(
              "Gallery",
              style: MyTextStyle.elevatedButtonText2(),
            ),
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (pickedFile == null) return;

      setState(() => _pickedImage = XFile(pickedFile.path));

      setState(() {
        _isLoading = true;
      });
      PaymentAPIServices.uploadBill(_pickedImage!, loginResponseModel.token!)
          .then((response) {
        if (response.amount != "-1") {
          Navigator.pushNamed(context, MyRoutes.paymentRoute,
              arguments: {"amount": response.amount});
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Unable to scan bill",
          );
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  void getData(LoginResponseModel loginResponseModel, BuildContext context) {
    BudgetAPIServices.getBudget(loginResponseModel.token!).then(
      (budgetResponse) {
        if (budgetResponse.budgets != null) {
          budget = budgetResponse.budgets!.first!.budget!;
          budgetId = budgetResponse.budgets!.first!.budgetId!;
          getAccounts(context);
        } else {
          getAccounts(context);
        }
      },
    );
  }

  setBudget() {
    if (budget != -1 && budgetId == 0) {
      BudgetAPIServices.addBudget(budget, loginResponseModel.token!).then(
        (response) {
          if (response.message != null) {
            // setState(() {});
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "Budget '$budget' has been saved!.",
              onConfirmBtnTap: () {
                getData(loginResponseModel, context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          } else {
            setState(() {
              budget = -1;
              budgetId = 0;
            });
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Budget Not Added",
            );
          }
        },
      );
    } else {
      // print("Else");
      BudgetAPIServices.updateBudget(
              budget, loginResponseModel.token!, budgetId.toString())
          .then(
        (response) {
          if (response.message != null) {
            setState(() {});
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "Budget '$budget' has been saved!.",
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          } else {
            setState(() {
              budget = -1;
            });
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Something went wrong",
            );
          }
        },
      );
    }
  }

  void getAccounts(BuildContext context) {
    TransactionAPIServices.getAccounts(loginResponseModel.token!).then(
      (response) {
        if (response.data != null) {
          accountsModel = response;
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: "Account not found",
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
