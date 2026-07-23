class HomeResponseModel {
  HomeResponseModel({
    required this.stats,
    required this.accountsByType,
    required this.monthlyFlow,
    required this.recentTransactions,
  });

  final Stats? stats;
  final List<dynamic> accountsByType;
  final List<MonthlyFlow> monthlyFlow;
  final List<dynamic> recentTransactions;

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      accountsByType: json["accountsByType"] == null
          ? []
          : List<dynamic>.from(json["accountsByType"]!.map((x) => x)),
      monthlyFlow: json["monthlyFlow"] == null
          ? []
          : List<MonthlyFlow>.from(
              json["monthlyFlow"]!.map((x) => MonthlyFlow.fromJson(x)),
            ),
      recentTransactions: json["recentTransactions"] == null
          ? []
          : List<dynamic>.from(json["recentTransactions"]!.map((x) => x)),
    );
  }
}

class MonthlyFlow {
  MonthlyFlow({
    required this.label,
    required this.receipts,
    required this.payments,
  });

  final String? label;
  final int? receipts;
  final int? payments;

  factory MonthlyFlow.fromJson(Map<String, dynamic> json) {
    return MonthlyFlow(
      label: json["label"],
      receipts: json["receipts"],
      payments: json["payments"],
    );
  }
}

class Stats {
  Stats({
    required this.accounts,
    required this.activeAccounts,
    required this.loanAccounts,
    required this.payments,
    required this.receipts,
    required this.netFlow,
    required this.transactions,
  });

  final int? accounts;
  final int? activeAccounts;
  final int? loanAccounts;
  final int? payments;
  final int? receipts;
  final int? netFlow;
  final int? transactions;

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      accounts: json["accounts"],
      activeAccounts: json["activeAccounts"],
      loanAccounts: json["loanAccounts"],
      payments: json["payments"],
      receipts: json["receipts"],
      netFlow: json["netFlow"],
      transactions: json["transactions"],
    );
  }
}
