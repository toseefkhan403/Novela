import 'package:arctic_pups/main.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessages {


  final String content,sent_by,type;
  int timestamp;

  //put 1 with the name of the person in 'sent_by' parameter to make it appear on the right
  //types are : 'text' , 'msg' , 'image' , 'call'
  // 'msg' will be general message provided to the user for the context (the stuff that doesn't appear as chat messages)

  ChatMessages({this.content,this.sent_by,this.type,this.timestamp});

}

addTheMessagesToTheDb() {

  List<ChatMessages> episode3List = List();

  //YOU HAVE TO EDIT THIS PART ONLY EVERYTHING ELSE IS AUTOMAGIC
  episode3List.add(ChatMessages(content: 'Kaha ho yar aap? Kabse wait kar rahi hu.. ', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Aapne bola tha jab msg karu tab nikalna, kabse taiyaar bethi hu mai', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'tumhare aane ki taiyaari m hi laga tha baby ;)', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Nahi ab mera mann nahi hai', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'aise nahi hota.. just come.. tumhara mann aur mood m dekh lunga', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'no, m not comin ab. M gussa hu aapse', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'tum na kch surprise rehne nahi deti ho.', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'https://firebasestorage.googleapis.com/v0/b/arctic-pups.appspot.com/o/novella_photos%2F1568227247609?alt=media&token=0d0e5341-7949-420f-b744-7eea5ab52154', sent_by: 'Raj1', type: 'image' ));
  episode3List.add(ChatMessages(content: 'Abhi bhi gussa ho?', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: ':o OMGG!!!! I’m speechless!', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'baaki ka surprise yaha aake milega ;)', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'reachin in 10 mins', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Love you baby <3', sent_by: 'Raj1', type: 'text' ));

  episode3List.add(ChatMessages(content: 'Next Day', sent_by: 'Raj1', type: 'msg' ));

  episode3List.add(ChatMessages(content: 'You made me feel so special yesterday', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'you are special, my love<3', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Abhi kya kar rahe ho?', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'ummm… ek min. I will be back', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: '??', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'someone’s at the door', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'After 20 minutes', sent_by: 'Raj1', type: 'msg' ));
  episode3List.add(ChatMessages(content: 'kon tha?', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Neighbour, ek ladki thi, Rubi.Ghar k peeche hi rehti h.She introduced herself, friendly hai', sent_by: 'Raj1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Zada friendly na ho tbhi theek hai', sent_by: 'Vishakha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'haha ok love ;*', sent_by: 'Raj1', type: 'text' ));



  for (int i = 0; i < episode3List.length ; i++) {

    episode3List[i].timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseDatabase.instance
        .reference()
        .child('episodes')
        .child('The unknown girl') //title of the story
        .child('episode1') //episodeNumber
        .child(episode3List[i].timestamp.toString())
        .set({
      'content': episode3List[i].content,
      'sent_by': episode3List[i].sent_by,
      'type': episode3List[i].type,
      'timestamp': episode3List[i].timestamp
    });

    showTopToast('Data inserted for $i');
  }

}