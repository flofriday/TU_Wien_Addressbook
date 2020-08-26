// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person()
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..gender = json['gender'] as String
    ..precedingTitles = json['preceding_titles'] as String
    ..postpositionedTitles = json['postpositioned_titles'] as String
    ..tissUri = json['card_uri'] as String
    ..pictureUri = json['picture_uri'] as String
    ..email = json['main_email'] as String
    ..otherEmails =
        (json['other_emails'] as List)?.map((e) => e as String)?.toList()
    ..phoneNumber = json['main_phone_number'] as String
    ..rawAdditionalInfos =
        (json['additional_infos'] as List)?.map((e) => e as String)?.toList()
    ..employee = (json['employee'] as List)
        ?.map((e) =>
            e == null ? null : Employee.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..student = json['student'] == null
        ? null
        : Student.fromJson(json['student'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'preceding_titles': instance.precedingTitles,
      'postpositioned_titles': instance.postpositionedTitles,
      'card_uri': instance.tissUri,
      'picture_uri': instance.pictureUri,
      'main_email': instance.email,
      'other_emails': instance.otherEmails,
      'main_phone_number': instance.phoneNumber,
      'additional_infos': instance.rawAdditionalInfos,
      'employee': instance.employee,
      'student': instance.student,
    };

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
    json['matriculation_number'] as String,
  );
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'matriculation_number': instance.matriculationNumber,
    };

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return Employee()
    ..orgRef = json['org_ref'] == null
        ? null
        : Organisation.fromJson(json['org_ref'] as Map<String, dynamic>)
    ..function = json['function'] as String
    ..room = json['room'] == null
        ? null
        : Room.fromJson(json['room'] as Map<String, dynamic>)
    ..phoneNumbers =
        (json['phone_numbers'] as List)?.map((e) => e as String)?.toList()
    ..websites = (json['websites'] as List)
        ?.map((e) =>
            e == null ? null : Website.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'org_ref': instance.orgRef,
      'function': instance.function,
      'room': instance.room,
      'phone_numbers': instance.phoneNumbers,
      'websites': instance.websites,
    };

Organisation _$OrganisationFromJson(Map<String, dynamic> json) {
  return Organisation()
    ..tissId = json['tiss_id'] as int
    ..name = json['name_de'] as String;
}

Map<String, dynamic> _$OrganisationToJson(Organisation instance) =>
    <String, dynamic>{
      'tiss_id': instance.tissId,
      'name_de': instance.name,
    };

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room()
    ..roomCode = json['room_code'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'room_code': instance.roomCode,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..street = json['street'] as String
    ..zipCode = json['zip_code'] as String
    ..city = json['city'] as String
    ..country = json['country'] as String;
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'zip_code': instance.zipCode,
      'city': instance.city,
      'country': instance.country,
    };

Website _$WebsiteFromJson(Map<String, dynamic> json) {
  return Website()
    ..uri = json['uri'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$WebsiteToJson(Website instance) => <String, dynamic>{
      'uri': instance.uri,
      'title': instance.title,
    };
