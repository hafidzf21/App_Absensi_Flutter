import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import 'package:app_absensi/components/default_button.dart';
import 'package:app_absensi/components/form_error.dart';
import 'package:app_absensi/helper/keyboard.dart';

class IzinForm extends StatefulWidget {
  @override
  _IzinFormState createState() => _IzinFormState();
}

class _IzinFormState extends State<IzinForm> {
  final _fromKey = GlobalKey<FormState>();
  String nama;
  String tanggal;
  String keperluan;
  DateTimeRange dateRange;

  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  String getFrom() {
    if (dateRange == null) {
      return 'Hari ini';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Sampai dengan';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fromKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(45)),
          buildDateFromField(),
          SizedBox(height: getProportionateScreenHeight(45)),
          buildReasonFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(35)),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Buat Pengajuan",
              press: () {
                if (_fromKey.currentState.validate()) {
                  _fromKey.currentState.save();
                  // If login success
                  KeyboardUtil.hideKeyboard(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  // Navigator.pushReplacement(context,
                  //   MaterialPageRoute(builder: (context) => SuccessMessage()));
                }
              },
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(35)),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => nama = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNameNullError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nama",
        hintText: "Masukan nama kamu",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextEditingController datecontroller = TextEditingController();
  TextFormField buildDateFromField() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: datecontroller,
      validator: (value) {
        if (value.isEmpty) {
          return kDateNullError;
        }
        return null;
      },
      onTap: () {
        pickDateRange(context);
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      decoration: InputDecoration(
        labelText: "Tanggal Lembur",
        hintText: "Hari ini - Sampai dengan",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildReasonFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onSaved: (newValue) => keperluan = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kReasonNullError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kReasonNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Keperluan Lembur",
        hintText: "Tulis Keperluan Lembur Kamu",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // Data Range Picker
  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            accentColor: Colors.teal,
            colorScheme: ColorScheme.light(primary: Colors.teal),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (newDateRange == null) return;
    setState(
      () => {
        dateRange = newDateRange,
        datecontroller.text = "${getFrom()} - ${getUntil()}",
      },
    );
  }
}
