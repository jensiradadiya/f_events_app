import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:like2day/utils/colors.dart';
import 'package:like2day/utils/images.dart';

import '../auth/services/firebase_firestore.dart';

class AddEventePage extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddEventePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List categorylist = [
    {"image": work_image, "name": "Work"},
    {"image": work_image, "name": "Personal"},
    {"image": work_image, "name": "Public"},
    {"image": work_image, "name": "Others"},
  ];
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  XFile? image;
  XFile? photo;
  bool? datevalidation = true;
  int selected = 0;
  // final FocusNode focusnode;
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';

  void getimage(ImageSource imagesource) async {
    final XFile? imagefile = await _picker.pickImage(source: imagesource);
    print("Image file ==> ${imagefile!.path}");
    if (imagefile == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child('${DateTime.now().microsecondsSinceEpoch}');

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(imagefile!.path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print("Image url $imageUrl");
    } catch (error) {
      //Some error occurred
    }
  }

  List<UploadTask> _uploadTasks = [];
  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Theme(
                          data: ThemeData(
                              accentColor: Colors.grey,
                              primarySwatch: Colors.grey),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              hintText: "Title",
                              label: Text(
                                "Title",
                                style: TextStyle(color: grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: descriptionController,

                          keyboardType: TextInputType.multiline,
                          minLines: 6, //Normal textInputField will be displayed
                          maxLines:
                              6, // when user presses enter it will adapt to it
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primary)),
                              filled: true,
                              label: Text(
                                "Details",
                                style: TextStyle(color: grey),
                              ),
                              hintText: 'Details'),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),

                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate!);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                                child: Card(
                                  elevation: 1,
                                  shadowColor: primary,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: primary.withOpacity(0.9)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 2),
                                    child: Container(
                                        height: size.height * 0.05,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            datevalidation == true
                                                ? Text(
                                                    pickedDate
                                                            .toString()
                                                            .isEmpty
                                                        ? pickedDate.toString()
                                                        : "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : Text(
                                                    "Date !",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.red),
                                                  ),
                                            Spacer(),
                                            Icon(
                                              Icons.date_range,
                                              color: primary,
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)), //this right here
                                          child: Container(
                                            height: size.height * 0.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Select a photo",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: size.height * 0.14,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                getimage(
                                                                    ImageSource
                                                                        .gallery);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                height:
                                                                    size.height,
                                                                width:
                                                                    size.width,
                                                                decoration: BoxDecoration(
                                                                    color: primary
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Icon(
                                                                  Icons.photo,
                                                                  size: 36,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                      Flexible(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                getimage(
                                                                    ImageSource
                                                                        .camera);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                height:
                                                                    size.height,
                                                                width:
                                                                    size.width,
                                                                decoration: BoxDecoration(
                                                                    color: primary
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Icon(
                                                                  Icons
                                                                      .camera_enhance,
                                                                  size: 36,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      20.0))),
                                                  height: size.height * 0.065,
                                                  width: size.width,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          20.0))),
                                                          backgroundColor:
                                                              primary),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Cancle",
                                                        style: TextStyle(
                                                            color: white),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Card(
                                  elevation: 1,
                                  shadowColor: primary,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: primary.withOpacity(0.9)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 2),
                                    child: Container(
                                        height: size.height * 0.05,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Image",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.photo,
                                              color: primary,
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: size.height * 0.065,
                          child: ListView.builder(
                            itemCount: categorylist.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selected = index;
                                  });
                                },
                                child: Card(
                                  elevation: index == selected ? 2 : 0,
                                  // shadowColor: primary,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: index == selected
                                              ? primary
                                              : primary.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      width: size.width * 0.2,
                                      height: size.height * 0.06,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                              "${categorylist[index]["name"]}"))),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (pickedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Select Date")));
                              } else {
                                await addtasktofirebase(
                                        title: titleController.text,
                                        discription: descriptionController.text,
                                        image: imageUrl,
                                        date: pickedDate,
                                        type: categorylist[selected]["name"])
                                    .then(
                                  (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Evente added Successfuly")));
                                  },
                                );
                                titleController.clear();
                                descriptionController.clear();
                                selected = 0;
                              }
                            }
                          },
                          child: Card(
                            color: primary,
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: size.height * 0.07,
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text("Add Event",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
