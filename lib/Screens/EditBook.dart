import 'package:flutter/material.dart';
import 'package:login_with_signup/Comm/comHelper.dart';
import 'package:login_with_signup/Comm/genTextFormField.dart';
import 'package:login_with_signup/DatabaseHandler/DbHelper.dart';
import 'package:login_with_signup/Model/UserModel.dart';
import 'package:login_with_signup/Model/BookModel.dart';
import 'package:login_with_signup/Screens/LoginForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditBook extends StatefulWidget {
  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  DbHelper dbHelper;
  final _conBookId = TextEditingController();
  final _conBookName = TextEditingController();
  final _conDelBookId = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBookData();

    dbHelper = DbHelper();
  }

  Future<void> getBookData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _conBookId.text = sp.getString("book_id");
      _conDelBookId.text = sp.getString("book_id");
      _conBookName.text = sp.getString("book_name");
    });
  }

  delete() async {
    String delBookID = _conDelBookId.text;

    await dbHelper.deleteBook(delBookID).then((value) {
      if (value == 1) {
        alertDialog(context, "Successfully Deleted");

        updateSP(null, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginForm()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  Future updateSP(BookModel book, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("book_name", book.book_name);
    } else {
      sp.remove('book_id');
      sp.remove('book_name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Update
                  getTextFormField(
                      controller: _conBookId,
                      isEnable: false,
                      icon: Icons.book_outlined,
                      hintName: 'Book ID'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conBookName,
                      icon: Icons.book,
                      inputType: TextInputType.name,
                      hintName: 'Book Name'),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),

                  //Delete

                  getTextFormField(
                      controller: _conDelBookId,
                      isEnable: false,
                      icon: Icons.person,
                      hintName: 'User ID'),
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: delete,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
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
