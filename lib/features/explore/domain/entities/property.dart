import 'package:equatable/equatable.dart';

/// Core domain entity representing a property listing.
class Property extends Equatable {
  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.address,
    required this.price,
    required this.priceLabel,
    required this.beds,
    required this.sqft,
    required this.facing,
    required this.lat,
    required this.lng,
    required this.imageUrl,
    required this.images,
    required this.tag,
    required this.agentName,
    required this.agentRating,
    required this.agentReviews,
    required this.agentImageUrl,
    required this.amenities,
    required this.description,
    required this.connectivityScore,
    required this.isNew,
    this.isSaved = false,
    this.isRental = false,
    this.monthlyRent,
  });

  final String id;
  final String title;
  final String location;
  final String address;
  final double price;
  final String priceLabel; // e.g. "₹1.2 Cr", "₹45k"
  final int beds;
  final double sqft;
  final String facing;
  final double lat;
  final double lng;
  final String imageUrl;
  final List<String> images;
  final String tag; // e.g. "Premium Estate", "New Listing"
  final String agentName;
  final double agentRating;
  final int agentReviews;
  final String agentImageUrl;
  final List<String> amenities; // icon names
  final String description;
  final double connectivityScore;
  final bool isNew;
  final bool isSaved;
  final bool isRental;
  final double? monthlyRent;

  Property copyWith({bool? isSaved}) => Property(
        id: id,
        title: title,
        location: location,
        address: address,
        price: price,
        priceLabel: priceLabel,
        beds: beds,
        sqft: sqft,
        facing: facing,
        lat: lat,
        lng: lng,
        imageUrl: imageUrl,
        images: images,
        tag: tag,
        agentName: agentName,
        agentRating: agentRating,
        agentReviews: agentReviews,
        agentImageUrl: agentImageUrl,
        amenities: amenities,
        description: description,
        connectivityScore: connectivityScore,
        isNew: isNew,
        isSaved: isSaved ?? this.isSaved,
        isRental: isRental,
        monthlyRent: monthlyRent,
      );

  @override
  List<Object?> get props => [id, isSaved];
}
