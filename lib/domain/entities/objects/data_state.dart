class DataState<T> {
  final bool isLoading;
  final String? error;
  T? data;
  DataState({required this.isLoading, this.error, this.data});

  factory DataState.loading() => DataState(isLoading: true);
  factory DataState.error(String error) =>
      DataState(isLoading: false, error: error);
  factory DataState.data(T data) => DataState(isLoading: false, data: data);
}
