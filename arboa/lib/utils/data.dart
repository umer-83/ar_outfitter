// ignore_for_file: non_constant_identifier_names

List<Map<String, dynamic>> data = [
  /*{
    "id": '1',
    "company_name": "Outfitters",
    "services": "Shirts, T-shirts, Jeans",
    "cover_image":"images/out1.jpg",
    "address": "7 College Rd, F-7 Markaz F 7 Markaz F-7, Islamabad, Islamabad Capital Territory",
    "rating": 4.5,
    "description":
        "Outfitters Stores (Pvt.) Ltd., is the parent company of Pakistan’s leading fashion brands Outfitters and Ethnic with omnichannel presence, 120+ stores across 20 cities.",
    "phone": "(051) 2653114",
    "portfolio": [
      "images/o2.jpg",
      "images/o3.jpg",
      "images/o4.jpg",
      "images/o5.jpg",
    ]
  },
  {
    "id": '2',
    "company_name": "Cougar",
    "services": "Sewing, Stitching",
    "cover_image":
        "images/c1.jpg",
    "address": "P352+327, The Centaurus Mall,Second Floor, Jinnah Avenue, F-8/4 F-8, Islamabad, Islamabad Capital Territory",
    "rating": 4.5,
    "description":
        "COUGAR Pakistan's casual wear brand is known for its trendy casual wear for a distinctly urban, outgoing, active and fun loving youth with an informal lifestyle.",
    "phone": "12345678910",
    "portfolio": [
      "images/c2.jpg",
      "images/c3.jpg",
      "images/c4.jpg",
      "images/c5.jpg",
    ]
  },
  {
    "id": '3',
    "company_name": "Domnark Sewing Center",
    "services": "Sewing, Stitching, Embroidery",
    "cover_image":
        "images/outfitters.jpg",
    "address": "Landhi, Karachi",
    "rating": 4.0,
    "description":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",
    "phone": "12345678910",
    "portfolio": [
      "images/outfitters.jpg"
    ]
  },
  {
    "id": '4',
    "company_name": "Sara's Embroidery",
    "services": "Embroidery",
    "cover_image":
        "images/outfitters.jpg",
    "address": "Gulshan-e-Iqbal, Karachi",
    "rating": 5.0,
    "phone": "12345678910",
    "description":
        "A professional tailoress working from last 3 years in this domain. I have sewed boutique clothes, Branded Shalwar, Fashionable Kameez, Kurtis with new designs of stitching on clothes.",
    "portfolio": [
      "",
    ]
  },
  {
    "id": '5',
    "company_name": "Bilquies Stitching Center",
    "services": "Sewing, Stitching",
    "cover_image":
        "images/outfitters.jpg",
    "address": "Phase IV, Clifton, Karachi",
    "rating": 3.5,
    "phone": "12345678910",
    "description":
        "I am Bilques. I can sew and stitch different types of clothes and make new designs from it.",
    "portfolio": [
      "images/outfitters.jpg"
    ]
  },
  {
    "id": '6',
    "company_name": "BB Sewing",
    "services": "Sewing",
    "cover_image":
        "images/outfitters.jpg",
    "address": "Gulshan-e-Iqbal, Block 13-B, Karachi",
    "rating": 4.5,
    "description":
        "I am working from 2 years in this domain. I can sew men clothes including shirts, pants, Kurta, Pajama, shalwars, and kameez.",
    "phone": "12345678910",
    "portfolio": [
      "images/outfitters.jpg"
    ]
  }*/
];

/*class ListOfAllData {
   late List<ServiceCardData> data;

   ListOfAllData();

   ListOfAllData.fromList(List<Map<String, Object>> data) {
     for (int i = 0; i < data.length; i++) {
       final item = ServiceCardData.fromListToCardData(data[i]);
       data.add(item);
     }
   }
 }*/

class ServiceCardData {
  String id;
  String services;
  // ignore: non_constant_identifier_names
  String company_name;
  // ignore: non_constant_identifier_names
  String cover_image;
  String phone;
  String address;
  double rating;
  String description;
  List<String> portfolio;

  ServiceCardData(
      {this.id,
      this.services,
      this.phone,
      this.company_name,
      this.cover_image,
      this.address,
      this.rating,
      this.description,
      this.portfolio});

  ServiceCardData.fromListToCardData(Map<String, dynamic> item) {
    id = item['id'];
    company_name = item['company_name'];
    cover_image = item['cover_image'];
    address = item['address'];
    rating = item['rating'].toDouble();
    description = item['description'];
    portfolio = item['portfolio'];
    services = item['services'];
    phone = item['phone'];
  }
}
