import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/helper.dart';

class HomeExtraSection extends StatelessWidget {
  const HomeExtraSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //=================
        //Rate and feedback
        //=================
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Have your say',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            children: [
              ListTile(
                tileColor: Colors.grey.withOpacity(.2),
                title: Text(
                  'Rate our app',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                ),
                onTap: () {
                  goToUrl(portaSaunaAppstoreLink);
                },
              ),
              ListTile(
                tileColor: Colors.grey.withOpacity(.2),
                title: Text(
                  'Feedback',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                ),
                onTap: () {
                  goToUrl('https://www.instagram.com/portasaunauk/');
                },
              ),
            ],
            onExpansionChanged: (bool expanded) {},
          ),
        ),

        //=================
        //Rate and feedback
        //=================
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Support & FAQs',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            children: [
              ListTile(
                tileColor: Colors.grey.withOpacity(.2),
                title: Text(
                  'Support & FAQ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                ),
                onTap: () {
                  goToUrl('https://portasauna.co.uk/pages/faq');
                },
              ),
              ListTile(
                tileColor: Colors.grey.withOpacity(.2),
                title: Text(
                  'Contact us',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                ),
                onTap: () {
                  goToUrl('https://www.instagram.com/portasaunauk/');
                },
              ),
            ],
          ),
        ),

        ListTile(
          title: Text(
            'Community (Coming soon)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
