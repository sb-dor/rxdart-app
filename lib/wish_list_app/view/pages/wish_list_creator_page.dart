import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_app/getit/getit_inj.dart';
import 'package:rxdart_app/main.dart';
import 'package:rxdart_app/wish_list_app/domain/entity/wish.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_bloc.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_events.dart';
import 'package:uuid/uuid.dart';

class WishListCreatorPage extends StatefulWidget {
  final Wish? wish;

  const WishListCreatorPage({super.key, this.wish});

  @override
  State<WishListCreatorPage> createState() => _WishListCreatorPageState();
}

class _WishListCreatorPageState extends State<WishListCreatorPage> {
  late final WishListBloc _wishListBloc;

  final TextEditingController _wishNameController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wishListBloc = locator<WishListBloc>();
    if (widget.wish != null) {
      _wishListBloc.wishlistEvents.add(InitTempWishListEvent(wish: widget.wish!));
      _wishNameController.text = widget.wish?.wishName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Wish list creator page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_wishNameController.text.trim().isEmpty) return;

          _wishListBloc.wishlistEvents.add(AddWishListEvent(name: _wishNameController.text.trim()));

          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: _wishNameController,
            decoration: const InputDecoration(hintText: "Name of wish"),
          )
        ],
      ),
    );
  }
}
