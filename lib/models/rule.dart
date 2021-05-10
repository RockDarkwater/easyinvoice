class Rule {
  String boolField;
  String boolValue;
  String ruleField;
  String ruleValue;

  Rule({this.boolField, this.boolValue, this.ruleField, this.ruleValue});

  Rule.fromJson(Map<String, dynamic> json)
      : boolField = json['boolField'],
        boolValue = json['boolValue'],
        ruleField = json['ruleField'],
        ruleValue = json['ruleValue'];

  Map<String, dynamic> toJson() => {
        'boolField': boolField,
        'boolValue': boolValue,
        'ruleField': ruleField,
        'ruleValue': ruleValue
      };

  String toString() {
    return 'if $boolField = $boolValue then change $ruleField to $ruleValue';
  }
}
