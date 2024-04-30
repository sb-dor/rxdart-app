import 'package:get_it/get_it.dart';
import 'package:rxdart_app/counter_app/view/bloc/counter_bloc.dart';
import 'package:rxdart_app/pusher/service/pusher_service.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_bloc.dart';

final locator = GetIt.instance;

abstract class GetItInj {
  static Future<void> inj() async {
    locator.registerLazySingleton<CounterBloc>(() => CounterBloc());

    locator.registerLazySingleton<WishListBloc>(() => WishListBloc());

    locator.registerLazySingleton<PusherService>(() => PusherService());
  }
}
