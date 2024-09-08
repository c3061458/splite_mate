import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/home/get_home_transactions_model.dart';
import 'package:splite_mate/services/api/budget.dart';
import 'package:splite_mate/services/api/home.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  GetHomeTransactionsModel homeTransactionsModel = GetHomeTransactionsModel();

  SharedServices sharedServices = SharedServices();

  LoginResponseModel loginResponseModel = LoginResponseModel();

  int budget = -1;
  double expanse = 0;

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
        appBar: MyAppBar.myAppBar(context, "Home"),
        backgroundColor: Colors.black12,
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      color: MyThemes.customPrimary,
                      child: Column(
                        children: [
                          Text(
                            "OVERVIEW",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Here is the list of your transactions",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Icon(CupertinoIcons.left_chevron),
                              Text(
                                "August 2024",
                                style: MyTextStyle.label2(),
                              ),
                              // const Icon(CupertinoIcons.right_chevron),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Budget",
                                    style: MyTextStyle.lightSubHeading(),
                                  ),
                                  Text(
                                    budget != -1 ? "£$budget" : "No Budget",
                                    style: MyTextStyle.elevatedButtonText(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Expanses",
                                    style: MyTextStyle.lightSubHeading(),
                                  ),
                                  Text(
                                    "£$expanse",
                                    style: MyTextStyle.elevatedButtonText(),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Balance",
                                    style: MyTextStyle.lightSubHeading(),
                                  ),
                                  Text(
                                    budget != -1
                                        ? "£${budget - expanse}"
                                        : "No Budget",
                                    style: MyTextStyle.elevatedButtonText(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: homeTransactionsModel.data!.length > 2 ? 2 : homeTransactionsModel.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('EEEE, dd MMM')
                                        .format(DateTime.parse(
                                            homeTransactionsModel
                                                .data![index]!.date!))
                                        .toUpperCase(),
                                    style: MyTextStyle.lightSubHeading(),
                                  ),
                                  Text(
                                    "-£${homeTransactionsModel.data![index]!.amount!}",
                                    style: MyTextStyle.lightSubHeading(),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: homeTransactionsModel
                                    .data![index]!.transactions!.length,
                                itemBuilder: (context, index2) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            homeTransactionsModel
                                                .data![index]!.transactions![index2]!.description!,
                                            style: MyTextStyle.heading2(),
                                          ),
                                          Text(
                                            "-£${homeTransactionsModel
                                                .data![index]!.transactions![index2]!.amount}",
                                            style: MyTextStyle.heading2(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void getData(LoginResponseModel loginResponseModel, context) {
    BudgetAPIServices.getBudget(loginResponseModel.token!).then(
      (budgetResponse) {
        if (budgetResponse.budgets != null) {
          budget = budgetResponse.budgets!.first!.budget!;
          HomeAPIServices.getCurrentMonthTotal(loginResponseModel.token!).then(
            (expenseResponse) {
              if (expenseResponse.totalAmount != null &&
                  double.parse(expenseResponse.totalAmount!) >= 0) {
                expanse = double.parse(expenseResponse.totalAmount!);
                HomeAPIServices.getHomeDetails(loginResponseModel.token!).then(
                  (homeResponse) {
                    if (homeResponse.data != null) {
                      homeTransactionsModel = homeResponse;
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Sorry",
                        text: "Something went wrong",
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
                // setState(() {
                //   _isLoading = false;
                // });
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Sorry",
                  text: "Something went wrong",
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
        } else {
          HomeAPIServices.getCurrentMonthTotal(loginResponseModel.token!).then(
                (expenseResponse) {
              if (expenseResponse.totalAmount != null &&
                  double.parse(expenseResponse.totalAmount!) >= 0) {
                expanse = double.parse(expenseResponse.totalAmount!);
                HomeAPIServices.getHomeDetails(loginResponseModel.token!).then(
                      (homeResponse) {
                    if (homeResponse.data != null) {
                      homeTransactionsModel = homeResponse;
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Sorry",
                        text: "Something went wrong",
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
                // setState(() {
                //   _isLoading = false;
                // });
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Sorry",
                  text: "Something went wrong",
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
                HomeAPIServices.getHomeDetails(loginResponseModel.token!).then(
                      (homeResponse) {
                    if (homeResponse.data != null) {
                      homeTransactionsModel = homeResponse;
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Sorry",
                        text: "Something went wrong",
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
            },
          );
        }
      },
    );
  }
}
