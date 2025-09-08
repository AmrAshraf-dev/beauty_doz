import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/page_models/secondary_pages/submit_review_dialog.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SubmitReviewDialog extends StatelessWidget {
  final MyOrdersModel order;
  final Item item;
  SubmitReviewDialog({this.order, this.item});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SubmitReviewDialogModel>(
        //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
        model: SubmitReviewDialogModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            context: context,
            item: item,
            order: order),
        builder: (context, model, child) {
          final locale = AppLocalizations.of(context);
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: model.rateValue,
                          minRating: 1,
                          itemCount: 5,
                          allowHalfRating: true,
                          direction: Axis.horizontal,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            model.rateValue = rating;
                            model.setState();
                            print(model.rateValue);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        onChanged: (val) => model.setState(),
                        maxLength: 255,
                        maxLines: 4,
                        controller: model.reviewController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.accentText),
                              borderRadius: BorderRadius.circular(5)),
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: locale
                              .get("Type your review" ?? "Type your review"),
                        ),
                      ),
                    ),
                    model.busy
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: model.reviewController.text.isEmpty &&
                                      model.rateValue != null
                                  ? null
                                  : () => model.submitReview(),
                              child: Text(locale.get("Submit") ?? "Submit"),
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
