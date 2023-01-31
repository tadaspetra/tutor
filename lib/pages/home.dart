import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import 'settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    ListView upcomingSessions() {
      if (currentUser.user.upcomingSessions.isEmpty) {
        return ListView(children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Center(
              child: Text(
                "No Upcoming Sessions",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]);
      }
      return ListView.builder(
        itemCount: currentUser.user.upcomingSessions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    currentUser.user.upcomingSessions[index].teacherPic,
                  ),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.user.upcomingSessions[index].teacherName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      currentUser.user.upcomingSessions[index].subject,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutoring App"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: Builder(builder: (context) {
              return GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      currentUser.user.profilePic,
                    ),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      endDrawer: Drawer(
          child: Column(
        children: [
          Image.network(
            currentUser.user.profilePic,
          ),
          ListTile(
            title: Text(
              "Hello, ${currentUser.user.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            title: const Text("Sign Out"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logout();
            },
          )
        ],
      )),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                "Upcoming Sessions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ListView.builder(
                itemCount: currentUser.user.upcomingSessions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            currentUser.user.upcomingSessions[index].teacherPic,
                          ),
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser
                                  .user.upcomingSessions[index].teacherName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              currentUser.user.upcomingSessions[index].subject,
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Schedule Session"),
      ),
    );
  }
}