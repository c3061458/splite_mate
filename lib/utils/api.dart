class MyAPI {

  static String api = "http://192.168.0.15:3000/";

  static String currencyAPI = "https://v6.exchangerate-api.com/v6/72272ca2240362cba0b6f71b/latest/GBP";

  static String register = "${api}register";
  static String verifyOTP = "${api}verify_otp";
  static String login = "${api}login";
  static String changePin = "${api}change_security_pin";
  static String changePassword = "${api}change_password";

  static String getTransactions = "${api}get_transactions";
  static String getAccounts = "${api}get_accounts";

  static String getHomeTransactions = "${api}get_transactions";
  static String getTotalAmountCurrentMonth = "${api}get_total_amount_current_month";

  static String getBudget = "${api}fetch_budget";
  static String addBudget = "${api}create_budget";
  static String updateBudget = "${api}update_budget/";

  static String addFriend = "${api}add_friend";
  static String getFriends = "${api}get_friends";
  static String getFriendByMobile = "${api}get_friend_by_mobile/";
  static String nonGroupMemberFriends = "${api}non_group_member_friends/";

  static String createGroup = "${api}create_group";
  static String getAllGroups = "${api}list_groups";
  static String getGroupDetails = "${api}get_group_details/";
  static String addMember = "${api}add_group_member";
  static String addMembers = "${api}add_group_members";
  static String removeMember = "${api}remove_group_member";
  static String deleteGroup = "${api}delete_group";

  static String uploadBill = "${api}upload_bill";
  static String addPayment = "${api}create_payment";

}