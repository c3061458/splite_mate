import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/transaction/all_transaction_model.dart';
import 'package:splite_mate/services/api/transaction.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool _isLoading = true;
  AllTransactionModel model = AllTransactionModel();

  SharedServices sharedServices = SharedServices();

  LoginResponseModel loginResponseModel = LoginResponseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        getData(loginResponseModel);
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
        appBar: MyAppBar.myAppBar(context, "Transactions"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: model.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.data![index]!.date!,
                            style: MyTextStyle.lightSubHeading(),
                          ),
                          ListView.builder(
                            itemCount: model.data![index]!.transactions!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 75.0,
                                            width: 75.0,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        40.0)),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                model
                                                    .data![index]!
                                                    .transactions![index2]!
                                                    .description!,
                                                style: MyTextStyle
                                                    .elevatedButtonText(),
                                              ),
                                              Text(
                                                model
                                                    .data![index]!
                                                    .transactions![index2]!
                                                    .createdAt!,
                                                style: MyTextStyle
                                                    .lightSubHeading(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (double.parse(model
                                                    .data![index]!
                                                    .transactions![index2]!
                                                    .amount!) >=
                                                0
                                            ? '£${model.data![index]!.transactions![index2]!.amount!}'
                                            : '-£${model.data![index]!.transactions![index2]!.amount!.substring(1)}'),
                                        style: MyTextStyle.elevatedButtonText(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Divider()
                                ],
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  void getData(LoginResponseModel loginResponseModel) {
    TransactionAPIServices.getAllTransactions(loginResponseModel.token!).then(
      (response) {
        if (response.data != null) {
          model = response;
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: response.message,
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }
}
