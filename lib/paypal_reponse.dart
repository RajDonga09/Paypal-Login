class PayPalResponse {
  String? userId;
  String? sub;
  String? name;
  Address? address;
  List<Emails>? emails;

  PayPalResponse({this.userId, this.sub, this.name, this.address, this.emails});

  PayPalResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    sub = json['sub'];
    name = json['name'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add(Emails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['sub'] = sub;
    data['name'] = name;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (emails != null) {
      data['emails'] = emails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  String? streetAddress;
  String? locality;
  String? region;
  String? postalCode;
  String? country;

  Address({this.streetAddress, this.locality, this.region, this.postalCode, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    streetAddress = json['street_address'];
    locality = json['locality'];
    region = json['region'];
    postalCode = json['postal_code'].toString();
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street_address'] = streetAddress;
    data['locality'] = locality;
    data['region'] = region;
    data['postal_code'] = postalCode;
    data['country'] = country;
    return data;
  }
}

class Emails {
  String? value;
  bool? primary;
  bool? confirmed;

  Emails({this.value, this.primary, this.confirmed});

  Emails.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    primary = json['primary'];
    confirmed = json['confirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['primary'] = primary;
    data['confirmed'] = confirmed;
    return data;
  }
}
