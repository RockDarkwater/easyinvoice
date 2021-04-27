class Rule {
  String boolField;
  String boolValue;
  String ruleField;
  String ruleValue;

  Rule({this.boolField, this.boolValue, this.ruleField, this.ruleValue});

  String toString() {
    return 'if $boolField = $boolValue then change $ruleField to $ruleValue';
  }
}
