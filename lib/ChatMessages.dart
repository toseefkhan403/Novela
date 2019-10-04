import 'package:arctic_pups/main.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessages {
  final String content, sent_by, type;
  int timestamp;

  //put 1 with the name of the person in 'sent_by' parameter to make it appear on the right
  //types are : 'text' , 'msg' , 'image' , 'call'
  // 'msg' will be general message provided to the user for the context (the stuff that doesn't appear as chat messages)

  ChatMessages({this.content, this.sent_by, this.type, this.timestamp});
}

addTheMessagesToTheDb() {
  List<ChatMessages> episodeList = List();

  //YOU HAVE TO EDIT THIS PART ONLY EVERYTHING ELSE IS AUTOMAGIC

  episodeList.add(ChatMessages(
      content: "Abey kaha reh gya? Teri bandi ne pakad lia kya? hahahaha",
      sent_by: 'Sagar1',
      type: 'text'));

  episodeList.add(ChatMessages(
      content: "Nhi bey. Moj ka intezam krra hu",
      sent_by: 'Arpit',
      type: 'text'));

  episodeList
      .add(ChatMessages(content: "Kya?", sent_by: 'Sagar1', type: 'text'));

  episodeList.add(ChatMessages(
      content: "https://productplacementblog.com/wp-content/uploads/2017/12/Shock-Top-Honeycrisp-Apple-Wheat-Michelob-and-Budweiser-Beer-Bottles-in-Home-Again-2.jpg", sent_by: 'Arpit', type: 'image'));

  episodeList.add(ChatMessages(
      content: "Arey shabash londe!", sent_by: 'Sagar1', type: 'text'));

  episodeList.add(
      ChatMessages(content: "*satan emoji", sent_by: 'Arpit', type: 'text'));

  episodeList.add(ChatMessages(
      content: "Chat with Arushi", sent_by: 'Sagar1', type: 'msg'));

  episodeList.add(ChatMessages(
      content: "Ap nikal gye trip k liye?", sent_by: 'Arushi1', type: 'text'));

  episodeList
      .add(ChatMessages(content: "Yes", sent_by: 'Arpit', type: 'text'));

  episodeList.add(ChatMessages(
      content:
          "Apna dhyan rakhna. Sagar ke sath zyada mat ghoomna. Mjhe pasand nhi h wo",
      sent_by: 'Arushi1',
      type: 'text'));

  episodeList.add(ChatMessages(
      content: "YAR TUM FIR SHURU HO GYI?", sent_by: 'Arpit', type: 'text'));

  episodeList.add(ChatMessages(
      content: "mai bss bol rhi hu. Please take care of yourself",
      sent_by: 'Arushi1',
      type: 'text'));

  episodeList.add(ChatMessages(
      content: "Tum na bhaad m jao. Bye", sent_by: 'Arpit', type: 'text'));

  episodeList.add(ChatMessages(
      content: "Ok. Tumhe apna gussa mere p nikaalna h toh nikaal lo",
      sent_by: 'Arushi1',
      type: 'text'));

  episodeList.add(ChatMessages(
      content: "But usse door rehna", sent_by: 'Arushi1', type: 'text'));

  episodeList.add(ChatMessages(
      content: "Warna fir kabhi mere paas mat aana",
      sent_by: 'Arushi1',
      type: 'text'));

  episodeList.add(ChatMessages(
      content: "Bye. I am getting late.", sent_by: 'Arpit', type: 'text'));

  /*episode3List.add(ChatMessages(content: 'EPISODE 3', sent_by: 'Raj1', type: 'msg' ));
/*episode3List.add(ChatMessages(content: 'EPISODE 3', sent_by: 'Raj1', type: 'msg' ));

  episode3List.add(ChatMessages(content: "Mai baat kr chuki hu unse...", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "I went to her place and bataaya ki mera friend hai Raj, jo recently side wale flat m shift hua hai ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Unka reaction bilkul b accha nahi tha", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "As in?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "weird tha yar.. As if nahi lena chahiye tha", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Mene bola ki yaha pe ek ladki hai Rubi wo kidhar rehti hai? ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Unhone kaha ki jaha aap shift hue ho wahi par", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Matlab pehle wo uss ghar m rent pe rehti thi?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Nahi", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Phir???", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "bolll", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "She committed suicide 2 years back in the same flat", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "DAMNNNNN", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Raj? Did you tell him all this?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Wahi jaa rahi hu.. ttyl ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Ok", sent_by: 'Neha', type: 'text' ));

  episode3List.add(ChatMessages(content: 'After knowing all this, Raj left that flat and shifted to an other place', sent_by: 'Raj1', type: 'msg' ));

  episode3List.add(ChatMessages(content: 'THE END', sent_by: 'Raj1', type: 'msg' ));*/
  episode3List.add(ChatMessages(content: "Mai baat kr chuki hu unse...", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "I went to her place and bataaya ki mera friend hai Raj, jo recently side wale flat m shift hua hai ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Unka reaction bilkul b accha nahi tha", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "As in?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "weird tha yar.. As if nahi lena chahiye tha", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Mene bola ki yaha pe ek ladki hai Rubi wo kidhar rehti hai? ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Unhone kaha ki jaha aap shift hue ho wahi par", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Matlab pehle wo uss ghar m rent pe rehti thi?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Nahi", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Phir???", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "bolll", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "She committed suicide 2 years back in the same flat", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "DAMNNNNN", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Raj? Did you tell him all this?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Wahi jaa rahi hu.. ttyl ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "Ok", sent_by: 'Neha', type: 'text' ));

  episode3List.add(ChatMessages(content: 'After knowing all this, Raj left that flat and shifted to an other place', sent_by: 'Raj1', type: 'msg' ));

  episode3List.add(ChatMessages(content: 'THE END', sent_by: 'Raj1', type: 'msg' ));*/

  for (int i = 0; i < episodeList.length; i++) {
    episodeList[i].timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseDatabase.instance
        .reference()
        .child('episodes')
        .child('The Trip') //title of the story
        .child('episode2') //episodeNumber
        .child(episodeList[i].timestamp.toString())
        .set({
      'content': episodeList[i].content,
      'sent_by': episodeList[i].sent_by,
      'type': episodeList[i].type,
      'timestamp': episodeList[i].timestamp
    });

    showTopToast('Data inserted for $i');
  }
}
