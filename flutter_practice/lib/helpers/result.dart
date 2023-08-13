class Result<value> {
  final value? _result;
  final Object? _occurredError;

  value? get result => _result;
  Object? get occurredError => _occurredError;
  bool get isSucceed => occurredError == null;

  Result({result, occurredError})
      : _result = result,
        _occurredError = occurredError;
}
