import 'package:flutter/material.dart';

late double screenFullWidth;
late double screenFullHeight;

void size(BuildContext context) {
  screenFullWidth = MediaQuery.of(context).size.width;
  screenFullHeight = MediaQuery.of(context).size.height;
}

const kHeight10 = SizedBox(
  height: 10,
);
const kHeight20 = SizedBox(
  height: 20,
);
const kHeight30 = SizedBox(
  height: 30,
);
const kHeight40 = SizedBox(
  height: 40,
);
const kHeight50 = SizedBox(
  height: 50,
);
const kHeight60 = SizedBox(
  height: 60,
);
const kHeight100 = SizedBox(
  height: 100,
);
const kHeight200 = SizedBox(
  height: 200,
);

const kWidth10 = SizedBox(
  width: 10,
);
const kWIdth20 = SizedBox(
  width: 20,
);
const kWIdth30 = SizedBox(
  width: 30,
);
const kWIdth40 = SizedBox(
  width: 40,
);