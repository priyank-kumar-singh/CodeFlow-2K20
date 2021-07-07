import 'package:flutter/material.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/widgets/image_row.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var slideritems = [
  "Ear Test",
  "Eye Test",
  "Instant Reports",
  "Quality Tests",
  "Health Tips"
];

var sliderimages = [
  "${kSliderImages}1.jpg",
  "${kSliderImages}2.jpg",
  "${kSliderImages}3.jpg",
  "${kSliderImages}4.jpg",
  "${kSliderImages}5.jpg"
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                SliderView(),
                SizedBox(
                  height: 10.0,
                ),
                ImageRow(),
                SizedBox(
                  height: 20.0,
                ),
                Image(
                  image: AssetImage(
                    'assets/images/team.png',
                  ),
                  height: 60.0,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller = PageController(viewportFraction: 0.8, initialPage: 1);
    List<Widget> sliders = List<Widget>();

    for (int x = 0 ; x < sliderimages.length ; x++) {
      var slideview = Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  sliderimages[x],
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      slideritems[x],
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
      sliders.add(slideview);
    }

    return Container(
      width: screenWidth,
      height: screenHeight * 5 / 16,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: sliders,
      ),
    );
  }
}
