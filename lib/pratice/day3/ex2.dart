import 'package:flutter/material.dart';

// TODO: Build a Product Card widget that looks like this:
//
// ┌─────────────────────────────────┐
// │  ┌─────────────────────────┐    │
// │  │                         │ N  │ <- "NEW" badge if isNew
// │  │       [Product         │ E  │
// │  │        Image]          │ W  │
// │  │                         │    │
// │  └─────────────────────────┘    │
// │  Product Name                   │
// │  ★★★★☆ (4.0)                    │ <- Star rating
// │  $99.99  $129.99                │ <- Price, old price struck through
// │  [Add to Cart]                  │ <- Button
// └─────────────────────────────────┘

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double rating;
  final bool isNew;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    this.isNew = false,
    this.onAddToCart,
  });

 
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + NEW BADGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isNew)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PRODUCT NAME
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // RATING
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString()),
                  ],
                ),

                const SizedBox(height: 6),

                // PRICE
                Row(
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (originalPrice != null)
                      Text(
                        '\$${originalPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

// TODO: Build a Dashboard Layout with:
// - Header with title and user avatar
// - Stats row (3 stat cards in a row)
// - Recent activity list
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CircleAvatar(child: Icon(Icons.person)),
          ],
        ),

        const SizedBox(height: 16),

        // STATS ROW
        Row(
          children: const [
            StatCard(
              title: 'Orders',
              value: '120',
              icon: Icons.shopping_cart,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            StatCard(
              title: 'Revenue',
              value: '\$5k',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            StatCard(
              title: 'Users',
              value: '320',
              icon: Icons.people,
              color: Colors.orange,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // RECENT ACTIVITY
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Recent Activity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Order completed'),
              subtitle: Text('Just now'),
            );
          },
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Exercise 3.2')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Product grid
            const Text('Products', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
              children: [
                ProductCard(
                  name: 'Wireless Headphones',
                  imageUrl: 'https://picsum.photos/200',
                  price: 99.99,
                  originalPrice: 129.99,
                  rating: 4.5,
                  isNew: true,
                  onAddToCart: () => print('Added to cart'),
                ),
                ProductCard(
                  name: 'Smart Watch',
                  imageUrl: 'https://picsum.photos/201',
                  price: 299.99,
                  rating: 4.0,
                ),
                ProductCard(
                  name: 'Laptop Stand',
                  imageUrl: 'https://picsum.photos/202',
                  price: 49.99,
                  originalPrice: 79.99,
                  rating: 4.8,
                ),
                ProductCard(
                  name: 'USB-C Hub',
                  imageUrl: 'https://picsum.photos/203',
                  price: 39.99,
                  rating: 3.5,
                  isNew: true,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Dashboard
            const Text('Dashboard', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const DashboardScreen(),
          ],
        ),
      ),
    ),
  );
}
