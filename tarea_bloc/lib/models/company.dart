import 'package:equatable/equatable.dart';

class Company extends Equatable  {
	final String name;
	final String catchPhrase;
	final String bs;

	Company({this.name, this.catchPhrase, this.bs});

	factory Company.fromJson(Map<String, dynamic> json) {
		return Company(
			name: json['name'],
			catchPhrase: json['catchPhrase'],
			bs: json['bs'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['catchPhrase'] = this.catchPhrase;
		data['bs'] = this.bs;
		return data;
	}

	@override
	List<Object> get props => [
		this.name,
		this.catchPhrase,
		this.bs
	];
}
