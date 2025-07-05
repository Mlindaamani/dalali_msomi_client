class Property {
  final String propertyType;
  final String houseNumber;
  final String location;
  final String insurancePolicyNumber;
  final String deedNumber;
  final List<String> brokerId;
  final double price;
  final String description;
  final String houseRules;
  final String status;
  final List<PropertyImage> propertyImages;
  final List<ContractFile> contractFiles;

  Property({
    required this.propertyType,
    required this.houseNumber,
    required this.location,
    required this.insurancePolicyNumber,
    required this.deedNumber,
    required this.brokerId,
    required this.price,
    required this.description,
    required this.houseRules,
    required this.status,
    required this.propertyImages,
    required this.contractFiles,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final images = (json['propertyImages'] as List<dynamic>)
        .map((img) => PropertyImage.fromJson(img))
        .toList();

    // Mapping the contractFiles JSON list into a list of ContractFile objects
    final contracts = (json['contractFiles'] as List<dynamic>)
        .map((c) => ContractFile.fromJson(c))
        .toList();

    return Property(
      propertyType: json['propertyType'] ?? '',
      houseNumber: json['houseNumber'] ?? '',
      location: json['location'] ?? '',
      insurancePolicyNumber: json['insurancePolicyNumber'] ?? '',
      deedNumber: json['deedNumber'] ?? '',
      brokerId: List<String>.from(json['brokerId'] ?? []),
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      houseRules: json['houseRules'] ?? '',
      status: json['status'] ?? '',
      propertyImages: images,
      contractFiles: contracts,
    );
  }
}

class ContractFile {
  final String id;
  final String introContractUrl;
  final String renewalContractUrl;
  final String terminationContractUrl;

  ContractFile({
    required this.id,
    required this.introContractUrl,
    required this.renewalContractUrl,
    required this.terminationContractUrl,
  });

  factory ContractFile.fromJson(Map<String, dynamic> json) {
    return ContractFile(
      id: json['id'] ?? '',
      introContractUrl: json['introContractUrl'] ?? '',
      renewalContractUrl: json['renewalContractUrl'] ?? '',
      terminationContractUrl: json['terminationContractUrl'] ?? '',
    );
  }
}

class PropertyImage {
  final String id;
  final String url;

  PropertyImage({required this.id, required this.url});

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(id: json['id'] ?? '', url: json['url'] ?? '');
  }
}



//JSON-TO-DART CONVERTER
// class Property {
//   String? propertyType;
//   String? houseNumber;
//   String? location;
//   String? insurancePolicyNumber;
//   String? deedNumber;
//   List<String>? brokerId;
//   int? price;
//   String? description;
//   String? houseRules;
//   String? status;
//   List<ContractFiles>? contractFiles;
//   List<PropertyImages>? propertyImages;

//   Property({
//     this.propertyType,
//     this.houseNumber,
//     this.location,
//     this.insurancePolicyNumber,
//     this.deedNumber,
//     this.brokerId,
//     this.price,
//     this.description,
//     this.houseRules,
//     this.status,
//     this.contractFiles,
//     this.propertyImages,
//   });

//   Property.fromJson(Map<String, dynamic> json) {
//     propertyType = json['propertyType'];
//     houseNumber = json['houseNumber'];
//     location = json['location'];
//     insurancePolicyNumber = json['insurancePolicyNumber'];
//     deedNumber = json['deedNumber'];
//     brokerId = json['brokerId'].cast<String>();
//     price = json['price'];
//     description = json['description'];
//     houseRules = json['houseRules'];
//     status = json['status'];
//     if (json['contractFiles'] != null) {
//       contractFiles = <ContractFiles>[];
//       json['contractFiles'].forEach((v) {
//         contractFiles!.add(new ContractFiles.fromJson(v));
//       });
//     }
//     if (json['propertyImages'] != null) {
//       propertyImages = <PropertyImages>[];
//       json['propertyImages'].forEach((v) {
//         propertyImages!.add(new PropertyImages.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['propertyType'] = this.propertyType;
//     data['houseNumber'] = this.houseNumber;
//     data['location'] = this.location;
//     data['insurancePolicyNumber'] = this.insurancePolicyNumber;
//     data['deedNumber'] = this.deedNumber;
//     data['brokerId'] = this.brokerId;
//     data['price'] = this.price;
//     data['description'] = this.description;
//     data['houseRules'] = this.houseRules;
//     data['status'] = this.status;
//     if (this.contractFiles != null) {
//       data['contractFiles'] = this.contractFiles!
//           .map((v) => v.toJson())
//           .toList();
//     }
//     if (this.propertyImages != null) {
//       data['propertyImages'] = this.propertyImages!
//           .map((v) => v.toJson())
//           .toList();
//     }
//     return data;
//   }
// }

// class ContractFiles {
//   String? id;
//   String? introContractUrl;
//   String? renewalContractUrl;
//   String? terminationContractUrl;

//   ContractFiles({
//     this.id,
//     this.introContractUrl,
//     this.renewalContractUrl,
//     this.terminationContractUrl,
//   });

//   ContractFiles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     introContractUrl = json['introContractUrl'];
//     renewalContractUrl = json['renewalContractUrl'];
//     terminationContractUrl = json['terminationContractUrl'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['introContractUrl'] = this.introContractUrl;
//     data['renewalContractUrl'] = this.renewalContractUrl;
//     data['terminationContractUrl'] = this.terminationContractUrl;
//     return data;
//   }
// }

// class PropertyImages {
//   String? id;
//   String? url;

//   PropertyImages({this.id, this.url});

//   PropertyImages.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['url'] = this.url;
//     return data;
//   }
// }

