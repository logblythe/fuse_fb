import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/services/api_service.dart';
import 'package:fuse/core/services/navigation_service.dart';
import 'package:fuse/core/services/post_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: NavigationService()),
  Provider.value(value: ApiService()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<ApiService, PostService>(
    update: (context, apiService, postService) {
      return PostService(api: apiService);
    },
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<List<Post>>(
    create: (context) =>
        Provider.of<PostService>(context, listen: false).postStream,
    updateShouldNotify: (_, __) => true,
  ),
];
