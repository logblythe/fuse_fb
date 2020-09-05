import 'package:fuse/models/post_model.dart';
import 'package:fuse/services/navigation_service.dart';
import 'package:fuse/services/post_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: NavigationService()),
  Provider.value(value: PostService()),
];

List<SingleChildWidget> dependentServices = [];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<List<Post>>(
    create: (context) =>
        Provider.of<PostService>(context, listen: false).postStream,
    updateShouldNotify: (_, __) => true,
  ),
];
