class Crew {
Crew(
      this.Id,
      this.name,
      this.crewPositionId,
      this.contractorId,
      this.birthDate,
      this.identityDocTypeID,
      this.identityDocNumber,
      this.nationalityID,
      this.genderID);

  String Id;
  String name;
  String crewPositionId;
  String contractorId;
  DateTime birthDate;
  int identityDocTypeID;
  String identityDocNumber;
  int nationalityID;
  int genderID;
  
  bool selected = false;
  
}