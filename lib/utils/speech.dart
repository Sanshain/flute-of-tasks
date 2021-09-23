import 'package:sanshain_tasks/widgets/popups.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

stt.SpeechToText speech = stt.SpeechToText();

void speechStatusListener(String str){
    print(str);
}
void speechErrorListener(SpeechRecognitionError error){
    print(error.toString());
}
