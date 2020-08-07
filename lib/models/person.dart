import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(nullable: true)
class Person {
  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  String gender;

  @JsonKey(name: 'preceding_titles')
  String precedingTitles;

  @JsonKey(name: 'postpositioned_titles')
  String postpositionedTitles;

  @JsonKey(name: 'card_uri')
  String tissUri;

  @JsonKey(name: 'picture_uri')
  String pictureUri;

  @JsonKey(name: 'main_email')
  String email;

  @JsonKey(name: 'other_emails')
  List<String> otherEmails;

  @JsonKey(name: 'main_phone_number')
  String phoneNumber;

  List<Employee> employee;
  Student student;

  Person();

  Person.example() {
    firstName = "Max";
    lastName = "Mustermann";
    email = "max.mustermann@example.com";
  }

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  String getNameWithTitles() {
    String name = this.firstName + " " + this.lastName;

    if (this.precedingTitles != null) {
      name = precedingTitles + " " + name;
    }

    if (this.postpositionedTitles != null) {
      name += " " + this.postpositionedTitles;
    }

    return name;
  }

  String getTissUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.tissUri;
    }

    return null;
  }

  String getPictureUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.pictureUri;
    }

    return "https://www.tuwien.at/apple-touch-icon.png";
  }

  String getShortDescription() {
    if (this.employee != null && this.student != null) {
      return "Student and Employee";
    } else if (this.employee != null) {
      return "Employee";
    } else if (this.student != null) {
      return "Student";
    } else {
      return "unknown";
    }
  }

  CircleAvatar getCircleAvatar(double radius) {
    if (this.pictureUri != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(this.getPictureUrl()),
      );
    }

    return CircleAvatar(
      radius: radius,
      child: Text(
        this.firstName[0] + this.lastName[0],
        style: TextStyle(fontSize: radius * 0.6),
      ),
    );
  }
}

@JsonSerializable(nullable: true)
class Student {
  @JsonKey(name: 'matriculation_number')
  String matriculationNumber;

  Student(this.matriculationNumber);

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}

@JsonSerializable(nullable: true)
class Employee {
  @JsonKey(name: 'org_ref')
  Organisation orgRef;

  String function;

  Room room;

  List<Website> websites;

  Employee();

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
}

@JsonSerializable(nullable: true)
class Organisation {
  @JsonKey(name: 'name_de')
  String name;

  Organisation();

  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);
}

@JsonSerializable(nullable: true)
class Room {
  @JsonKey(name: 'room_code')
  String roomCode;

  Address address;

  Room();

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

@JsonSerializable(nullable: true)
class Address {
  String street;

  @JsonKey(name: 'zip_code')
  String zipCode;

  String city;

  String country;

  Address();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@JsonSerializable(nullable: true)
class Website {
  String uri;

  String title;

  Website();

  factory Website.fromJson(Map<String, dynamic> json) =>
      _$WebsiteFromJson(json);
}
