import 'package:flutter_modular/flutter_modular.dart';
import '../../repositories/order/order_repository.dart';
import '../../repositories/order/order_repository_impl.dart';
import '../../services/order/get_order_by_id.dart';
import '../../services/order/get_order_by_id_impl.dart';
import 'order_controller.dart';
import 'order_page.dart';

class OrderModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<OrderRepository>((i) => OrderRepositoryImpl(i())),
        Bind.lazySingleton<GetOrderById>(
            (i) => GetOrderByIdImpl(i(), i(), i(),),),
        Bind.lazySingleton((i) => OrderController(i(), i(),)),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const OrderPage(),
        ),
      ];
}
