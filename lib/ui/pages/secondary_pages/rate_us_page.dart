import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/rate_use_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class RateUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseWidget<RateUsPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: RateUsPageModel(auth: Provider.of(context)),
          builder: (context, model, child) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 20,
                            )),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("WHAT DO YOU THINK ABOUT"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 20),
                            child: Text(
                              "ANGEL SCHLESSER",
                              style: TextStyle(
                                  color: Color.fromRGBO(219, 170, 68, 1)),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            itemCount: 5,
                            direction: Axis.horizontal,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Tell us your opinion",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, bottom: 20, right: 15, left: 15),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Color.fromRGBO(219, 170, 68, 1),
                              onPressed: () {},
                              child: Center(
                                child: Text("SUBMIT",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ]),
            );
          }),
    );
  }
}
