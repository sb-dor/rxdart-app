import 'package:flutter/material.dart';
import 'package:rxdart_app/getit/getit_inj.dart';
import 'package:rxdart_app/wish_list_app/domain/entity/wish.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_bloc.dart';
import 'package:rxdart_app/wish_list_app/view/pages/wish_list_creator_page.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late WishListBloc _wishListBloc;

  @override
  void initState() {
    super.initState();
    _wishListBloc = locator<WishListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WishListCreatorPage(),
          ),
        ),
        child: const Icon(Icons.forward),
      ),
      appBar: AppBar(
        title: const Text(
          "Wish list",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: _wishListBloc.wishlistStates,
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              final currentState = snap.requireData;
              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentState.wishListStateModel.wishList.length,
                    itemBuilder: (context, index) {
                      final wish = currentState.wishListStateModel.wishList[index];
                      return _WishListTile(wish: wish);
                    },
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class _WishListTile extends StatelessWidget {
  final Wish wish;

  const _WishListTile({super.key, required this.wish});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wish.wishName),
      trailing: const Icon(Icons.widgets_sharp),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WishListCreatorPage(
              wish: wish,
            ),
          ),
        );
      },
    );
  }
}
