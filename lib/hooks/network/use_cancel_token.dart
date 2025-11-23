import 'package:dio/dio.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

CancelToken useCancelToken() {
  final cancelToken = useMemoized(CancelToken.new);

  useEffect(() {
    return () => cancelToken.cancel('Widget disposed');
  }, []);

  return cancelToken;
}
