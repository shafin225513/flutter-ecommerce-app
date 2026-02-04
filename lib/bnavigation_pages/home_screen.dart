import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add dispose method to clean up the controller when the state is removed from the tree.
  final TextEditingController _searchController = TextEditingController();
  List<String> carouselImages = [];
  int _currentIndex = 0;

  List<Map<String, dynamic>> allProducts = [];

  List<Map<String, dynamic>> topProducts = [];
  List<Map<String, dynamic>> accessories = [];
  List<Map<String, dynamic>> filteredProducts=[];
  //TextEditingController _searchController=TextEditingController();

  Future<void> fetchProducts() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('products').get();

  final fetchedProducts = snapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'name': data['name'] ?? '',
      'price': data['price'] ?? 0,
      'image': data['image'] ?? '',
      'category': data['category'] ?? '',
      'description': data['description'] ?? '',
    };
  }).toList();

  setState(() {
    allProducts = fetchedProducts;

    topProducts =
        allProducts.where((p) => p['category'] == 'top').toList();

    accessories =
        allProducts.where((p) => p['category'] == 'accessories').toList();

    filteredProducts = []; // reset search initially
  });
}







  Future<void> fetchCarouselImages() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('banners')
      .where('active', isEqualTo: true)
      .get();

  setState(() {
    carouselImages =
        snapshot.docs.map((doc) => doc['image'] as String).toList();
  });
}



void searchProducts(String query) {
  if (query.isEmpty) {
    setState(() {
      filteredProducts = [];
    });
    return;
  }

  setState(() {
    filteredProducts = allProducts.where((product) {
      final name = product['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
  });
}





Widget sectionHeader(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Spacer(),
        Text('View All',
            style: TextStyle(color: Colors.deepOrange, fontSize: 14.sp)),
            Icon(Icons.arrow_forward_ios),
            
      ],
    ),
  );
}




Widget productHorizontalList(List<Map<String, dynamic>> products) {
  return SizedBox(
  height: 250,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Container(
          width: 170,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.network(
                    product['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "৳ ${product['price']}",
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  ),
);

}




  @override
void initState() {
  super.initState();
  fetchCarouselImages();
  fetchProducts();
}



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // It's good practice to ensure ScreenUtil is initialized if you use its extensions.
    // Assuming it is initialized in main.dart or similar.
    return Scaffold(
      appBar: AppBar(
        // Use standard colors for better readability/maintainability
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'E-Commerce',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      // Use Padding widget directly instead of EdgeInsetsGeometry.only with a fixed value.
      body: SafeArea(
        child: SingleChildScrollView(
          
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
          
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: searchProducts,
                        decoration: InputDecoration(
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Search for any product',
                          hintStyle: TextStyle(fontSize: 15.sp),
                          
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        ),
                      ),
                    ),
                  ),
              
                  GestureDetector(
                    onTap: () {
                      
                      searchProducts(_searchController.text.trim());
                      //Fluttertoast.showToast(msg: 'Search tapped! Query: ${_searchController.text}');
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      color: Colors.deepOrange,
                      child: Center(
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: 20,),
              SizedBox(height: 20.h),

             if (carouselImages.isNotEmpty)
  Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 180.h,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: carouselImages.map((imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),

      SizedBox(height: 8),

      /// DOT INDICATOR
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: carouselImages.asMap().entries.map((entry) {
          return Container(
            width: _currentIndex == entry.key ? 10 : 6,
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _currentIndex == entry.key
                  ? Colors.deepOrange
                  : Colors.grey,
            ),
          );
        }).toList(),
      ),
    ],
  )
else
  CircularProgressIndicator(),


filteredProducts.isNotEmpty
    ? productHorizontalList(filteredProducts) // or horizontal list if you want
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader('Top Products'),
          productHorizontalList(topProducts),

          SizedBox(height: 20),

          sectionHeader('Accessories'),
          productHorizontalList(accessories),
        ],
      ),






              
              /*Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('products')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
  return Center(
    child: Text(
      snapshot.error.toString(),
      textAlign: TextAlign.center,
    ),
  );
}


      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      final products = snapshot.data!.docs;

      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: ListTile(
              leading: Image.network(
                product['imageURL'],
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product['name']),
              subtitle: Text(product['description']),
              trailing: Text(
                '৳ ${product['price']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),*/

              // No need for an extra Padding widget if the Row is already within a padded parent.
              
            ],
          ),
        ),
      ),
    );
  }
}
