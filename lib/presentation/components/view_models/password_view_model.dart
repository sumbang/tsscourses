import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/presentation/components/view_models/password_state.dart';

final passwordViewModelProvider = StateNotifierProvider.autoDispose<PasswordViewModel, PasswordState>(
  (ref) => PasswordViewModel());

class PasswordViewModel extends StateNotifier<PasswordState> {

    PasswordViewModel() : super(PasswordState.intial());

    void submitAnswer(bool answer) {

       if(answer == true) {
         state = state.copyWith(
            statut: true
          );
       }

       else {
         state = state.copyWith(
            statut: false
          );
       }
 
    }

    void reset() {
      state = PasswordState.intial();
    }


}