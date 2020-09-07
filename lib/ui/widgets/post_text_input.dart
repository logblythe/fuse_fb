import 'package:flutter/material.dart';

class PostTextInput extends StatelessWidget {
  final Function(dynamic) onChanged;
  final TextEditingController controller;

  const PostTextInput({Key key, this.onChanged, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
            textInputAction: TextInputAction.done,
            minLines: 5,
            maxLines: 10,
            controller: controller,
            decoration: InputDecoration(
              hintText: "What\'s on your mind?",
              border: const OutlineInputBorder(),
              hintStyle: Theme.of(context).textTheme.headline6,
            ),
            onChanged: onChanged),
      ),
    );
  }
}
