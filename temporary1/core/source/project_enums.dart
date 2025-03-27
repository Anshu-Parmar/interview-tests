enum Collections {
  users("Users"),
  topics("topics"),
  unfollowed("unfollowed_default_topics"),
  followed("followed_topics"),
  bookmark("bookmarks");

  final String collectionName;

  const Collections(this.collectionName);
}

enum Providers {
  google("google.com"),
  password("password"),
  apple("apple.com"),
  currentPassword("currentIsPassword"),
  currentGoogle("currentIsGoogle"),
  currentApple("currentIsApple");

  final String name;

  const Providers(this.name);
}