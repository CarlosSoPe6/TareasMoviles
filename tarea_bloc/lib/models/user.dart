import 'package:equatable/equatable.dart';
import "address.dart";
import "company.dart";

class User extends Equatable  {
	final int id;
	final String name;
	final String username;
	final String email;
	final Address address;
	final String phone;
	final String website;
	final Company company;

	User({this.id, this.name, this.username, this.email, this.address, this.phone, this.website, this.company});

	factory User.fromJson(Map<String, dynamic> json) {
		return User(
			id: json['id'],
			name: json['name'],
			username: json['username'],
			email: json['email'],
			address: json['address'] != null ? new Address.fromJson(json['address']) : null,
			phone: json['phone'],
			website: json['website'],
			company: json['company'] != null ? new Company.fromJson(json['company']) : null,
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['name'] = this.name;
		data['username'] = this.username;
		data['email'] = this.email;
		if (this.address != null) {
      data['address'] = this.address.toJson();
    }
		data['phone'] = this.phone;
		data['website'] = this.website;
		if (this.company != null) {
      data['company'] = this.company.toJson();
    }
		return data;
	}

	@override
	List<Object> get props => [
		this.id,
		this.name,
		this.username,
		this.email,
		this.address,
		this.phone,
		this.website,
		this.company
	];
}
