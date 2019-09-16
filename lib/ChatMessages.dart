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

  episode3List.add(ChatMessages(content: "Vishaka's chat with her bestfriend Neha", sent_by: 'Raj1', type: 'msg' ));

  episode3List.add(ChatMessages(content: 'hi babe, aayi kyu nahi aaj? ', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Mat pooch yar dimag kharab hua hua hai mera', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Raj ke saath ladaayi hui?', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Nahi yar', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Toh phir?', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Tujhe mene btaya thya na that he has shifted to a new flat', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Haa?', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Vaha koi ladki hai, bin baat ke chep ho rahi hai isse.', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Subah se toh do baar aa bhi chuki uske ghar mai', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Bahot gussa aa raha hai mujhe muh todd dungi jaake iska kamini saali', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Vishakha shaant hoja yr', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Dekh direct action lene ka koi faeda nahi hai.', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Toh phir? Bata kya karu', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Uske ghar ke paas, jaha wo rehti hai waha jaa and dekh', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Pehle pata karle ki hai kon, kya karti hai kaha rehti hai exact', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "uske baad we'll see how to treat that bitch", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Alright. Mai jaati hu waha kal and then I'll let u knw", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "yep.. abhi soja DW gn", sent_by: 'Neha', type: 'text' ));

  episode3List.add(ChatMessages(content: 'Next Day', sent_by: 'Raj1', type: 'msg' ));
  episode3List.add(ChatMessages(content: 'Kaha pe hai tu', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Just reached here. Raj ke ghar ke backside pe jaari hu', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'okay be careful', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'kya hua? bol kch', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Vishakhaaa?", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "Yaha pe koi ghar nahi hai :| ", sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "matlab???", sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: "https://www.thehindu.com/society/history-and-culture/249kc7/article26495936.ece/ALTERNATES/FREE_960/11NDMPMETROCAPITALCHECKTEMPLEMOSQUEBSZM", sent_by: 'Vishakha1', type: 'image'));
  episode3List.add(ChatMessages(content: 'whatttt???', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'yes.. Jesa Raj ne btaya tha waha to koi ghar hai hi nhi', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Ye hai wo jagah. Yha rehti hogi kya? :|', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "I'm speechless", sent_by: "Vishakha1", type: 'text' ));
  episode3List.add(ChatMessages(content: 'So am I', sent_by: 'Neha', type: 'text' ));
  episode3List.add(ChatMessages(content: 'Raj k flat k side m ek ghar h, waha jaake poochti hu', sent_by: 'Vishakha1', type: 'text' ));
  episode3List.add(ChatMessages(content: "haa.. yeh sahi rahega", sent_by: 'Neha', type: 'text' ));

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


  for (int i = 0; i < episode3List.length ; i++) {

    episode3List[i].timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseDatabase.instance
        .reference()
        .child('episodes')
        .child('The unknown girl') //title of the story
        .child('episode2') //episodeNumber
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