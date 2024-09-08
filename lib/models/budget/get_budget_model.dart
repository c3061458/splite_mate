///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetBudgetModelBudgets {
  int? budget;
  int? budgetId;
  String? createdAt;
  String? updatedAt;

  GetBudgetModelBudgets({
    this.budget,
    this.budgetId,
    this.createdAt,
    this.updatedAt,
  });
  GetBudgetModelBudgets.fromJson(Map<String, dynamic> json) {
    budget = json['budget']?.toInt();
    budgetId = json['budget_id']?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['budget'] = budget;
    data['budget_id'] = budgetId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetBudgetModel {
/*
{
  "budgets": [
    {
      "budget": 6000,
      "budget_id": 1,
      "created_at": "Wed, 04 Sep 2024 09:14:01 GMT",
      "updated_at": "Wed, 04 Sep 2024 09:14:45 GMT"
    }
  ]
}
*/

  List<GetBudgetModelBudgets?>? budgets;

  GetBudgetModel({
    this.budgets,
  });
  GetBudgetModel.fromJson(Map<String, dynamic> json) {
    if (json['budgets'] != null) {
      final v = json['budgets'];
      final arr0 = <GetBudgetModelBudgets>[];
      v.forEach((v) {
        arr0.add(GetBudgetModelBudgets.fromJson(v));
      });
      budgets = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (budgets != null) {
      final v = budgets;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['budgets'] = arr0;
    }
    return data;
  }
}