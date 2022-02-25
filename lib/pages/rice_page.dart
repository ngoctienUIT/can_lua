import 'package:can_lua/class/item.dart';
import 'package:can_lua/provider/main_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RicePage extends StatefulWidget {
  const RicePage({Key? key}) : super(key: key);

  @override
  State<RicePage> createState() => _RicePageState();
}

class _RicePageState extends State<RicePage> {
  List<Item> items = [];
  int indexWeight = 0;
  late String id;

  Widget weightNumber(int number) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return indexWeight == number ? Colors.red : Colors.blue;
          },
        ),
      ),
      onPressed: () {
        setState(() {
          indexWeight = number;
        });
      },
      child: Text(items[items.length - 1].weights[number].toString()),
    );
  }

  void onClick(Item item) {
    double weight = 0;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weightNumber(0),
                    weightNumber(1),
                    weightNumber(2),
                    weightNumber(3),
                    weightNumber(4)
                  ],
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng cộng:'),
                    Text(items[items.length - 1].total().toString())
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    weight = double.parse(text.toString());
                  },
                  decoration: const InputDecoration(
                    label: Text('Cân nặng'),
                    hintText: 'Nhập sô cân nặng (Kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      item.weights[indexWeight] = weight;
                      indexWeight = (indexWeight + 1) % 5;
                      final document = FirebaseFirestore.instance
                          .collection(FirebaseAuth.instance.currentUser!.email
                              .toString())
                          .doc(id)
                          .collection('item')
                          .doc(item.id);
                      await document.update({'weight': item.weights});

                      Navigator.pop(context);
                      onClick(item);
                    });
                  },
                  child: const Text('Nhập'),
                ),
              ],
            ),
          );
        });
  }

  void onClickDetail(Item item) {
    double weight = 0;
    TextEditingController controller =
        TextEditingController(text: item.weights[indexWeight].toString());

    Widget weightNumber(int number) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return indexWeight == number ? Colors.red : Colors.blue;
            },
          ),
        ),
        onPressed: () {
          setState(() {
            indexWeight = number;
            // Navigator.pop(context);
            // onClickDetail(item);
          });
        },
        child: Text(item.weights[number].toString()),
      );
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weightNumber(0),
                    weightNumber(1),
                    weightNumber(2),
                    weightNumber(3),
                    weightNumber(4),
                  ],
                ),
                const Divider(
                  color: Colors.red,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng cộng:'),
                    Text(item.total().toString())
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Cân nặng'),
                    hintText: 'Nhập sô cân nặng (Kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() async {
                            List<dynamic> weights = item.weights;
                            weight = double.parse(controller.text);
                            weights[indexWeight] = weight;
                            indexWeight = (indexWeight + 1) % 5;
                            final document = FirebaseFirestore.instance
                                .collection(FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString())
                                .doc(id)
                                .collection('item')
                                .doc(item.id);
                            await document.update({'weight': weights});
                            Navigator.pop(context);
                            onClickDetail(item);
                          });
                        },
                        child: const Text('Nhập'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.red;
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() async {
                            final collection = FirebaseFirestore.instance
                                .collection(FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString())
                                .doc(id)
                                .collection('item');
                            await collection.doc(item.id).delete();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Xóa'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc(context.watch<MainProvider>().id)
        .collection('item')
        .snapshots();
    id = context.watch<MainProvider>().id;

    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<MainProvider>().name),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                CollectionReference user = FirebaseFirestore.instance
                    .collection(
                        FirebaseAuth.instance.currentUser!.email.toString())
                    .doc(id)
                    .collection('item');

                await user.add({
                  'weight': [0, 0, 0, 0, 0]
                });
                indexWeight = 0;
                onClick(items[items.length - 1]);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.requireData;
              final docs = data.docs;
              items = [];
              for (var doc in docs) {
                items.add(Item.fromJson(doc));
              }

              for (int i = 0; i < items.length; i++) {
                items[i].standardized();
                items[i].id = docs[i].id;
              }

              return items.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 4 / 5),
                      itemBuilder: (context, index) {
                        Item item = items[index];
                        return InkWell(
                          onTap: () {
                            indexWeight = 0;
                            onClickDetail(item);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 7,
                                      color: Colors.black38,
                                      offset: Offset(0, 3))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var weight in item.weights)
                                  Text(weight.toString()),
                                const Divider(
                                  thickness: 3,
                                  indent: 10,
                                  endIndent: 10,
                                  color: Colors.red,
                                ),
                                Text(item.total().toString()),
                              ],
                            ),
                          ),
                        );
                      })
                  : const Center(
                      child: Text('không có gì ở đây'),
                    );
            }
            return const Center(child: Text('Loading...'));
          },
        ));
  }
}
