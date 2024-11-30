// Friend Model
class FriendModel {
  String userId;
  String friendId;

  FriendModel({required this.userId, required this.friendId});

  Map<String, String> toMap() {
    return {
      'userId': userId,
      'friendId': friendId,
    };
  }
}
