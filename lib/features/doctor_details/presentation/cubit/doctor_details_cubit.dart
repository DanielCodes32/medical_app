import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/doctor_details_response.dart';
import 'package:medical_app/features/doctor_details/data/repo/details_repo.dart';
import 'package:medical_app/features/doctor_details/presentation/cubit/doctor_details_states.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState>{
  final String id;
  DoctorDetailsResponse? doctorDetails;

  DoctorDetailsCubit({required this.id}) : super(DoctorDetailsInitial()) {
    getDoctorDetails(id);
  }

  Future<DoctorDetailsResponse?> getDoctorDetails(String id)async{
    emit(DoctorDetailsLoadingState());
    var data=await DetailsRepo().getDoctorDetails(id);
    if(data!=null){
      doctorDetails = data;
      emit(DoctorDetailsLoadedState());
      return data;
    }else{
      emit(DoctorDetailsErrorState());
      return null;
    }
  }

}