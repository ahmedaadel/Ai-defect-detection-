import 'package:flutter/material.dart';
import 'package:gp/modules/upload_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}
bool islast = false;
class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = PageController();


    List<Widget> screens = [
      buildBoarding1(),
      buildBoarding3()
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                  onPageChanged: (int value) {
                    if (value == screens.length-1) {
                      setState(() {
                        islast = true ;
                      });
                    }
                    else {
                      setState(() {
                        islast = false;
                      });
                    }
                  },
                  controller: controller,
                  physics:const  BouncingScrollPhysics(),
                  itemBuilder: (context, index) => screens[index],
                  itemCount: screens.length,
                )),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SmoothPageIndicator(
                      controller: controller,
                      count: screens.length,
                      effect: const ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.purple,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 5),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: () {
                        if (islast==true) {
                          print('5oooooo 4');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  UploadScreen(),
                              ));
                        } else {
                          controller.nextPage(
                              duration: Duration(milliseconds: 750),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      backgroundColor: Colors.purple,
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

Widget buildBoarding1() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 20,
        ),
        Text(
          'Defecto , Welcome .. ',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        Text(
          'An Artificial Intelligence tool ',
          style:
              TextStyle(fontSize: 18, height: 2, fontWeight: FontWeight.bold),
        ),
        Text(
          'for identifying defective products ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: Image(
          image: AssetImage('assets/images/DEFECTO 1.png'),
        ))
      ],
    );

Widget buildBoarding2() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Iam ready , Upload your Image ',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        const Expanded(
            child: Image(
          image: AssetImage('assets/images/DEFECTO (2).png'),
        )),
        Center(
            child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Upload',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      EdgeInsets.only(bottom: 15, left: 30, right: 30, top: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                )))
      ],
    );

Widget buildBoarding3() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          height: 850,
          width: 800,
          child: Image(
            image: AssetImage('assets/images/defecto3.png'),
            fit: BoxFit.cover,
          ),
        )),
      ],
    );
