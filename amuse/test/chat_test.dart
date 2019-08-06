import 'package:flutter_test/flutter_test.dart';
import 'package:amuse/ChatScreen/chat.dart';

void main(){
  //test chat box is null
ChatScreenState chats = new ChatScreenState();
  test('Empty chatbox returns error string', () {
    final result = chats.textMessageSubmitted('');
    expect(result, 'Send a message');
  });

  test('Non-Empty chatbox returns null', () {
    final result = chats.textMessageSubmitted('abc');
    expect(result, null);
  });
}
