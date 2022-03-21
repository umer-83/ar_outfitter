import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ar_outfitter/utils/data.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';


class ServiceAddPage extends StatefulWidget {
  final bool initialized;
  final bool error;
  final Function addNewService;
  const ServiceAddPage(
      {Key key,
      this.initialized,
      this.error,
      this.addNewService})
      : super(key: key);

  @override
  _ServiceAddPageState createState() => _ServiceAddPageState();
}

class _ServiceAddPageState extends State<ServiceAddPage> {
  bool loading = false;
  File imageFile;
  List<File> workImageFile = [];
  final picker = ImagePicker();

  //FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController company_name = TextEditingController();
  TextEditingController services = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<void> SelectImageFromGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future SelectImageOfWork() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        workImageFile.add(File(pickedImage.path));
      });
    }
  }

  Future OnSave() async {
    setState(() {
      loading = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Saving in Progress..'),
      ),
    );
    final cover_image = await saveFileToFireBase(imageFile);

    List<String> portfolio = [];
    if (workImageFile.length > 0) {
      for (var eachFile in workImageFile) {
        String portfolioImageUrl = await saveFileToFireBase(eachFile);
        portfolio.add(portfolioImageUrl);
      }
    }

    ServiceCardData newObject = ServiceCardData(
        id: Uuid().v4(),
        services: services.text,
        phone: phone.text,
        company_name: company_name.text,
        cover_image: cover_image,
        portfolio: portfolio,
        description: description.text,
        rating: 0.0,
        address: address.text);

    widget.addNewService(newObject);
    setState(() {
      loading = false;
      imageFile = null;
      workImageFile = [];
    });
    company_name.text = '';
    services.text = '';
    address.text = '';
    description.text = '';
    phone.text = '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Successfully Saved.'),
      ),
    );
  }

  Future saveFileToFireBase(File file) async {
    if (file != null) {
      List<String> extensionLists = file.path.split(".");
      String extension = extensionLists.last;
      String fileName = const Uuid().v4();
      try {
        await FirebaseStorage.instance
            .ref('appImages/$fileName.$extension')
            .putFile(File(file.path));

        String fileUrl = await FirebaseStorage.instance
            .ref('appImages/$fileName.$extension')
            .getDownloadURL();

        return fileUrl;
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        print("errorsss => $e");
      }
      return 'null';
    }
  }

  void onChangeNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/size');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add your service',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 35,
                  margin: EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                      onPressed: OnSave,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.grey.shade400,
                          onSurface: Colors.grey.shade50,
                          shadowColor: Colors.white,
                          padding: EdgeInsets.all(5),
                          elevation: 0),
                      child: loading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ))
                          : Text('SAVE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)))),
            ],
          ))
        ],
        elevation: 4,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: SafeArea(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
              padding: EdgeInsetsDirectional.all(0),
              child: Column(
                children: [
                  if (loading)
                    LinearProgressIndicator(
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  Stack(children: [
                    Container(
                      color: Colors.grey.shade400,
                      width: double.maxFinite,
                      height: 250,
                      child: imageFile != null
                          ? Image.file(imageFile)
                          : Container(
                              color: Colors.grey,
                              height: 300,
                              child: Center(
                                  child: Text("Upload Image",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )))),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300.withOpacity(.7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: IconButton(
                                onPressed: SelectImageFromGallery,
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 34.0,
                                  color: Colors.blue,
                                )),
                          )
                        ],
                      ),
                    )
                  ]),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: company_name,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 15, 15, 3),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                hintText: 'Company Name',
                                labelText: "Company Name"),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: services,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 15, 15, 3),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                hintText: 'Services Name',
                                labelText: "Services Name"),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: phone,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 15, 15, 3),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                hintText: 'Phone Number',
                                labelText: "Phone Number"),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: address,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 15, 15, 3),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                hintText: 'Address',
                                labelText: "Address"),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: description,
                            style: TextStyle(fontSize: 14),
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 15, 15, 3),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                hintText: 'Description',
                                labelText: "Description"),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Upload your work",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GridView.count(
                                      primary: false,
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      children: [
                                        ...List.generate(
                                          workImageFile.length,
                                          (index) => Container(
                                            width: 100,
                                            height: 100,
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.file(
                                              workImageFile[index],
                                              width: double.maxFinite,
                                              fit: BoxFit.cover,
                                              height: 100,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Tooltip(
                                                message: "Add your photos",
                                                child: IconButton(
                                                    onPressed:
                                                        SelectImageOfWork,
                                                    icon: Icon(Icons.add,
                                                        size: 30)),
                                              )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Colors.grey.shade200,
                                          ),
                                        )
                                      ]),
                                ],
                              ))
                        ],
                      ))
                ],
              )),
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: onChangeNavigation,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Service Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.boy_sharp),
            label: 'Sizes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
    );
  }
}


// Widget UploadedImage(){
//   return (

//   );
// }// TODO Implement this library.