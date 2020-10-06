import 'package:equatable/equatable.dart';
import "geo.dart";

class Address extends Equatable  {
	final String street;
	final String suite;
	final String city;
	final String zipcode;
	final Geo geo;

	Address({this.street, this.suite, this.city, this.zipcode, this.geo});

	factory Address.fromJson(Map<String, dynamic> json) {
		return Address(
			street: json['street'],
			suite: json['suite'],
			city: json['city'],
			zipcode: json['zipcode'],
			geo: json['geo'] != null ? new Geo.fromJson(json['geo']) : null,
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['street'] = this.street;
		data['suite'] = this.suite;
		data['city'] = this.city;
		data['zipcode'] = this.zipcode;
		if (this.geo != null) {
      data['geo'] = this.geo.toJson();
    }
		return data;
	}

	@override
	List<Object> get props => [
		this.street,
		this.suite,
		this.city,
		this.zipcode,
		this.geo
	];
}
