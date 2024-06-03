
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future<void> addUserInfo(
      {required String docId, required Map<String, dynamic> userData}) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(docId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo({required int id}) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id.toInt())
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatRoom(
      {required Map<String, dynamic> chatRoom, required String chatRoomId}) {
    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChatList() {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('chatUsersID',
            arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  addMessage(
      {required String chatRoomId,
      required Map<String, dynamic> chatMessageData}) {
    FirebaseFirestore.instance
        .collection("messages")
        .doc(chatRoomId)
        .collection(chatRoomId)
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateTimeStamp({required String groupChatId}) {
    FirebaseFirestore.instance
        .collection("messages")
        .doc(groupChatId)
        .update({'createdAt': DateTime.now().millisecondsSinceEpoch});
  }

  makeAllMessageSeen(groupChatId) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .get();
    final List<DocumentSnapshot> documents2 = result.docs;

    for (var doc in documents2) {
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(doc.id)
          .update({'isRead': true}).catchError((e) {
        print("Error not all messages are seen:::::$e");
      });
    }
  }

  changeUserStatus({required bool isUserOnline}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'userStatus': isUserOnline ? 1 : 0});
  }

  deleteGroupChat(String groupChatId) {
    FirebaseFirestore.instance.collection("messages").doc(groupChatId).delete();
  }

  getUserFirebaseToken(String id) async {
    String token = "";
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("id", isEqualTo: id)
          .get()
          .then((value) {
        token = value.docs[0].data()['pushToken'];

        //print(value.docs[0]);
      });
    } catch (x) {
      // print("Error======" + x);
    }
    return token;
  }
}
