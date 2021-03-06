import 'package:flutter/material.dart';

import 'form_lembur.dart';
import 'header_card.dart';
import '../../../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                TextBannerLembur(),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                LemburForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

