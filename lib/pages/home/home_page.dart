import 'package:can_lua/class/item.dart';
import 'package:can_lua/class/person.dart';
import 'package:can_lua/provider/main_provider.dart';
import 'package:can_lua/pages/rice_page/rice_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final VoidCallback openDrawer;
  const HomePage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  void onClick() {
    CollectionReference user = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString());

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      label: Text('Tên'), border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() async {
                        await user.add({
                          'name': controller.text,
                          'datetime': Timestamp.fromDate(DateTime.now()),
                          'deposit': 0,
                          'paid': 0,
                        });

                        controller.text = '';
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Nhập')),
              ],
            ),
          );
        });
  }

  Widget underLine() {
    return const Divider(
      color: Colors.red,
      thickness: 3,
      indent: 50,
      endIndent: 50,
    );
  }

  Widget rowLine(String name, String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            number,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<Person> persons = [];

  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .snapshots();

  Future<double> totalWeight(String id) async {
    double total = 0;
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc(id)
        .collection('item')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        Item item = Item.fromJson(doc);
        total += item.total();
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
            stream: users,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.requireData;
                final docs = data.docs;
                persons = [];

                for (var doc in docs) {
                  persons.add(Person.fromJson(doc));
                }

                persons.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                return ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      Person person = persons[index];
                      return Container(
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 7,
                                  color: Colors.black38,
                                  offset: Offset(0, 3))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RicePage()),
                                      );
                                      context.read<MainProvider>().name =
                                          person.name;
                                      context.read<MainProvider>().id =
                                          docs[index].id;
                                    },
                                    child: const Text('Mở'),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.account_circle_outlined,
                                            color: Colors.purple,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            person.name,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.solidCalendarAlt,
                                            color: Colors.purple,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${person.dateTime.toDate().day}/${person.dateTime.toDate().month}/${person.dateTime.toDate().year}',
                                            style: const TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          return Colors.red;
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() async {
                                        final collection = FirebaseFirestore
                                            .instance
                                            .collection(FirebaseAuth
                                                .instance.currentUser!.email
                                                .toString());
                                        await collection
                                            .doc(docs[index].id)
                                            .delete();
                                      });
                                    },
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: totalWeight(docs[index].id),
                              builder: (context, snapshot) {
                                return rowLine(
                                    'Khối lượng', '${snapshot.data}');
                              },
                            ),
                            underLine(),
                            rowLine('Thành tiền:', '${person.price}'),
                            underLine(),
                            rowLine('Tiền cọc', '${person.deposit}'),
                            underLine(),
                            rowLine('Đã trả:', '${person.paid}'),
                            underLine(),
                            rowLine('Nợ lại:', '${person.price - person.paid}')
                          ],
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                widget.openDrawer();
              },
            ),
            title: const Text('Cân lúa'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  onClick();
                },
                icon: const Icon(Icons.add),
              ),
            ]),
      ),
    );
  }
}
