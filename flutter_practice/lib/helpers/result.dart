class Result<T> {
  T? _result;
  Object? _occurredError;
  final bool _isSucceed;

  T? get result => _result;
  Object? get occurredError => _occurredError;
  bool get isSucceed => _isSucceed;
  bool get hasResult => _result != null;
  bool get isSuccessHasNoResult => _isSucceed && _result == null;
  bool get hasFailedWithoutError => !_isSucceed && _occurredError == null;

  Result.fromFailur() : _isSucceed = false;

  Result.fromSuccess() : _isSucceed = true;

  Result.fromError(Object? occurredError)
      : _isSucceed = false,
        _occurredError = occurredError;

  Result.fromResult(T result)
      : _isSucceed = true,
        _result = result;
}
