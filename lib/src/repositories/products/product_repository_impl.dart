import 'dart:developer';
import '../../core/exceptions/repository_exception.dart';
import '../../core/rest_client/custom_dio.dart';
import 'package:dio/dio.dart';
import '../../models/product_model.dart';
import './product_repository.dart';
import 'dart:typed_data';

class ProductRepositoryImpl implements ProductRepository {
  final CustomDio _dio;

  ProductRepositoryImpl(this._dio);

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.auth().put(
        '/products/$id',
        data: {
          'enabled': false,
        },
      );
    } on DioException catch (e, s) {
      log('Erro ao deletar produto', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao deletar produto');
    }
  }

  @override
  Future<List<ProductModel>> findAll(String? name) async {
    try {
      final productResult = await _dio.auth().get(
        '/products',
        queryParameters: {
          if (name != null) 'name': name,
          'enabled': true,
        },
      );

      return productResult.data
          .map<ProductModel>((p) => ProductModel.fromMap(p))
          .toList();
    } on DioException catch (e, s) {
      log('Erro ao encontrar produtos', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao encontrar produtos');
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final productResult = await _dio.auth().get(
            '/products/$id',
          );
      return ProductModel.fromMap(productResult.data);
    } on DioException catch (e, s) {
      log('Erro ao buscar produto $id', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produto $id');
    }
  }

  @override
  Future<void> save(ProductModel productModel) async {
    try {
      final client = _dio.auth();
      final data = productModel.toMap();

      if (productModel.id != null) {
        await client.put('/products/${productModel.id}', data: data);
      } else {
        await client.post('/products', data: data);
      }
    } on DioException catch (e, s) {
      log('Erro ao salvar produto', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar produto');
    }
  }

  @override
  Future<String> uploadImageProduct(Uint8List file, String filename) async {
    try {
      final formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(file, filename: filename),
        },
      );
      final response = await _dio.auth().post(
            '/uploads',
            data: formData,
          );
      return response.data['url'];
    } on DioException catch (e, s) {
      log('Erro ao fazer upload do arquivo', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao fazer upload do arquivo');
    }
  }
}
