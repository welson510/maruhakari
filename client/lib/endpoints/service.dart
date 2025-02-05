
import 'package:client/repositories/auth_repository.dart';
import 'package:client/schema/account.dart';
import 'package:client/schema/container_template.dart';
import 'package:client/schema/create_measurement_history_request.dart';
import 'package:client/schema/device.dart';
import 'package:client/schema/food.dart';
import 'package:client/schema/food_chart.dart';
import 'package:client/schema/food_template.dart';
import 'package:client/schema/measurement_history.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'service.g.dart';

@RestApi(baseUrl: "https://maruhakari.panta.systems")
abstract class MaruhakariApiClient {
  factory MaruhakariApiClient(Dio dio, {String baseUrl}) = _MaruhakariApiClient;
  @POST("api/v1/accounts/register")
  Future<TokenWithAccount> register(@Body() CreateAccountRequest req);

  @POST("api/v1/accounts/login")
  Future<TokenWithAccount> login(@Body() LoginAccountRequest req);

  @GET("api/v1/accounts/verify")
  Future<Account> verifyToken();

  @GET("api/v1/container-templates")
  Future<List<ContainerTemplate>> getContainerTemplates();

  @GET("api/v1/food-templates")
  Future<List<FoodTemplate>> getFoodTemplates();

  @GET("api/v1/foods")
  Future<MyFoodsResponse> getOwnFoods();

  @GET("api/v1/foods/{foodId}")
  Future<Food> getFood(@Path("foodId") String foodId);
  
  @GET("api/v1/foods/{nfcUid}/related-nfc")
  Future<Food> getFoodByNfcUid(@Path("nfcUid") String nfcUid);

  @POST("api/v1/foods")
  Future<Food> createFood(@Body() CreateFoodRequest req);

  @PUT("api/v1/foods/{foodId}")
  Future<Food> updateFood(@Path("foodId") String foodId, @Body() UpdateFoodRequest req);

  @DELETE("api/v1/foods/{foodId}")
  Future<void> deleteFood(@Path("foodId") String foodId);

  @GET("api/v1/devices")
  Future<List<Device>> getDevices();

  @POST("api/v1/devices")
  Future<Device> saveDevice(@Body() SaveDeviceRequest req);
  
  @GET("api/v1/foods/{foodId}/chart")
  Future<FoodChart> getFoodChart(@Path("foodId") String foodId, @Query("begin_at") String beginAt, @Query("end_at") String endAt);

  @GET("api/v1/foods/{foodId}/measurement-histories")
  Future<List<MeasurementHistory>> getMeasurementHistories(@Path("foodId") String foodId, @Query("begin_at") String beginAt, @Query("end_at") String endAt);

  @POST("api/v1/foods/{foodId}/measurement-histories")
  Future<MeasurementHistory> createMeasurementHistory(@Path("foodId") String foodId, @Body() CreateMeasurementHistoryRequest req);

}


MaruhakariApiClient create(AuthRepository service,
    {String baseUrl = 'https://maruhakari.panta.systems'}) {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final token = await service.getToken();
    if (token != null) {
      options.headers['Authorization'] = "Bearer $token";
    }
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }));
  return MaruhakariApiClient(dio, baseUrl: baseUrl);
}