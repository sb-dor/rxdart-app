import 'package:get_it/get_it.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/counter_bloc.dart';

final locator = GetIt.instance;

abstract class GetItInj {
  static Future<void> inj() async {
    locator.registerLazySingleton<CounterBloc>(() => CounterBloc());
  }
}
