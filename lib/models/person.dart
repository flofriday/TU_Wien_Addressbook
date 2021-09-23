import 'package:json_annotation/json_annotation.dart';
import 'package:tu_wien_addressbook/models/easteregg_data.dart';
import 'package:uri/uri.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'person.g.dart';

// To build the code generateion run:
// flutter pub run build_runner build
@JsonSerializable()
class Person {
  @JsonKey(name: 'first_name')
  String firstName = "";

  @JsonKey(name: 'last_name')
  String lastName = "";

  String? gender;

  @JsonKey(name: 'preceding_titles')
  String? precedingTitles;

  @JsonKey(name: 'postpositioned_titles')
  String? postpositionedTitles;

  @JsonKey(name: 'card_uri')
  String tissUri = "";

  @JsonKey(name: 'picture_uri')
  String? pictureUri;

  @JsonKey(name: 'preview_picture_uri')
  String? previewPictureUri;

  @JsonKey(name: 'main_email')
  String? email;

  @JsonKey(name: 'other_emails')
  List<String>? otherEmails;

  @JsonKey(name: 'main_phone_number')
  String? phoneNumber;

  // This text is HTML encoded!
  // I know, its cracy but you need to use getAdditionalInfos if you want to
  // get it decoded.
  //@JsonKey(name: 'additional_infos', includeIfNull: false)
  @JsonKey(name: 'additional_infos')
  List<String>? rawAdditionalInfos;

  List<Employee>? employee;
  Student? student;

  EastereggData _eastereggData = EastereggData();

  Person();

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  String getName() {
    return "$firstName $lastName";
  }

  String getNameWithTitles() {
    String name = this.firstName + " " + this.lastName;

    if (this.precedingTitles != null) {
      name = precedingTitles! + " " + name;
    }

    if (this.postpositionedTitles != null) {
      name += " " + this.postpositionedTitles!;
    }

    return name;
  }

  String getGender() {
    if (this.gender == null) return "unknown";

    if (this.gender == 'M')
      return "male";
    else if (this.gender == 'W')
      return "female";
    else
      return this.gender!;
  }

  String getTissUrl() {
    return "https://tiss.tuwien.ac.at" + this.tissUri;
  }

  String getPictureUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.pictureUri!;
    }

    return "https://www.tuwien.at/apple-touch-icon.png";
  }

  String getPreviewPictureUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.previewPictureUri!;
    }

    return "https://www.tuwien.at/apple-touch-icon.png";
  }

  String getShortDescription() {
    String description = "";

    if (this.employee != null && this.student != null) {
      description = "Student and Employee";
    } else if (this.employee != null) {
      description = "Employee";
    } else if (this.student != null) {
      description = "Student";
      description += ", since ${this.student!.getMatriculationYear()}";
    } else {
      description = "No information";
    }

    if (this.employee != null) {
      for (Employee e in this.employee!) {
        description += ", ${e.function}";
      }
    }

    return description;
  }

  String getShareText() {
    String s = "${getNameWithTitles()}\n\n${getShortDescription()}\n\n$email";
    if (this.phoneNumber != null) s += "\n\n$phoneNumber";
    s += "\n\n${getTissUrl()}";
    return s;
  }

  String _getCustomHash() {
    String content = this.firstName + this.lastName + this.email!;
    var bytes = utf8.encode(content);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String? easterEggHeader() {
    return this._eastereggData.getHeader(_getCustomHash());
  }

  String? easterEggBody() {
    return this._eastereggData.getBody(_getCustomHash());
  }
}

@JsonSerializable()
class Student {
  @JsonKey(name: 'matriculation_number')
  String matriculationNumber;

  Student(this.matriculationNumber);

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  String getMatriculationYear() {
    String jjString = matriculationNumber[1] + matriculationNumber[2];
    int jj = int.parse(jjString);
    if (jj < 40) return "20$jjString";
    return "19$jjString";
  }
}

@JsonSerializable()
class Employee {
  @JsonKey(name: 'org_ref')
  Organisation orgRef = Organisation();

  // TODO: The problem here is that the function often is not english, but the
  // category often is. So my current trade-off is to use the category for
  // now and hope it is not to generic.
  @JsonKey(name: 'function_category')
  String function = "";

  Room? room;

  @JsonKey(name: 'phone_numbers')
  List<String>? phoneNumbers;

  List<Website>? websites;

  Employee();

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}

@JsonSerializable()
class Organisation {
  @JsonKey(name: 'tiss_id')
  int tissId = 0;

  @JsonKey(name: 'name_en')
  String name = "";

  Organisation();

  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganisationToJson(this);

  String getTissUrl() {
    return "https://tiss.tuwien.ac.at/adressbuch/adressbuch/orgeinheit/" +
        tissId.toString();
  }
}

@JsonSerializable()
class Room {
  @JsonKey(name: 'room_code')
  String roomCode = "";

  Address address = Address();

  Room();

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  // Return a link to https://tuw-maps.tuwien.ac.at which highlights the room.
  // Note to reader: it took me f***ing 30mins to figure out where I could get
  // a map to highlight the room because TISS uses an internal code to show you
  // the room which the API does not give you.
  String getMapUrl() {
    var template =
        new UriTemplate("https://tuw-maps.tuwien.ac.at/?q={room}#map");
    return template.expand({'room': this.roomCode});
  }
}

@JsonSerializable()
class Address {
  String street = "";

  @JsonKey(name: 'zip_code')
  String zipCode = "";

  String city = "";

  String country = "";

  Address();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String toString() {
    String text = "$street, $zipCode $city";
    if (country != 'AT') text += " ($country)";
    return text;
  }
}

@JsonSerializable()
class Website {
  String uri = "";

  String title = "";

  Website();

  factory Website.fromJson(Map<String, dynamic> json) =>
      _$WebsiteFromJson(json);

  Map<String, dynamic> toJson() => _$WebsiteToJson(this);
}
