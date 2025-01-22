import 'package:intl/intl.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:url_launcher/url_launcher.dart';

formatDate(v) {
  if (v == null) return v;
  var outputFormat = DateFormat('MM/dd/yyyy');
  var outputDate = outputFormat.format(v);
  return outputDate;
}

getMonthYearFromDate(v) {
  if (v == null) return v;
  var outputFormat = DateFormat('MMMM yyyy');
  var outputDate = outputFormat.format(v);
  return outputDate;
}

getMonthNameFromDate(v) {
  if (v == null) return v;
  var outputFormat = DateFormat('MMMM');
  var outputDate = outputFormat.format(v);
  return outputDate;
}

goToUrl(url) {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

getLocationImage(images) {
  if (images is List && images.isNotEmpty) {
    return images[0];
  }
  return defaultNatureImage;
}
