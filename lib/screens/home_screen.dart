import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../database/database_helper.dart';
import 'add_product_screen.dart';
import 'product_details_screen.dart';
// TODO: Import the details screen when created

const kMainColor = Color(0xFFE17028);
const kAccentYellow = Color(0xFFFFD600);
const kWhite = Colors.white;
const kTableHeaderTextStyle = TextStyle(
  color: kWhite,
  fontWeight: FontWeight.bold,
  fontSize: 16,
  letterSpacing: 1.1,
);
const kTableCellTextStyle = TextStyle(
  color: Colors.black87,
  fontSize: 15,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Product> _products = [];
  bool _isLoading = true;
  final NumberFormat _frwFormat = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _databaseHelper.getAllProducts();
      setState(() {
        _products = products.map((map) => Product.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  void _onRowTap(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text('Mango4G Inventory'),
        backgroundColor: kMainColor,
        foregroundColor: kWhite,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products found'))
              : Center(
                  child: Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(kMainColor),
                          headingTextStyle: kTableHeaderTextStyle,
                          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return kAccentYellow.withOpacity(0.3);
                              }
                              // Alternating row colors
                              int index = states.contains(MaterialState.selected)
                                  ? 0
                                  : _products.indexOf(_products.firstWhere((p) => p == _products[_products.indexOf(p)]));
                              return index % 2 == 0 ? kWhite : kAccentYellow.withOpacity(0.12);
                            },
                          ),
                          columns: const [
                            DataColumn(label: Text('Name', style: kTableHeaderTextStyle)),
                            DataColumn(label: Text('Category', style: kTableHeaderTextStyle)),
                            DataColumn(label: Text('Quantity', style: kTableHeaderTextStyle)),
                            DataColumn(label: Text('Price (Frw)', style: kTableHeaderTextStyle)),
                            DataColumn(label: Text('Location', style: kTableHeaderTextStyle)),
                          ],
                          rows: List<DataRow>.generate(
                            _products.length,
                            (index) {
                              final product = _products[index];
                              return DataRow(
                                color: MaterialStateProperty.all(
                                  index % 2 == 0 ? kWhite : kAccentYellow.withOpacity(0.12),
                                ),
                                cells: [
                                  DataCell(Text(product.name, style: kTableCellTextStyle), onTap: () => _onRowTap(product)),
                                  DataCell(Text(product.category, style: kTableCellTextStyle), onTap: () => _onRowTap(product)),
                                  DataCell(Text(product.quantity.toString(), style: kTableCellTextStyle), onTap: () => _onRowTap(product)),
                                  DataCell(Text('${_frwFormat.format(product.price)} Frw', style: kTableCellTextStyle), onTap: () => _onRowTap(product)),
                                  DataCell(Text(product.location ?? '', style: kTableCellTextStyle), onTap: () => _onRowTap(product)),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentYellow,
        foregroundColor: kMainColor,
        onPressed: _navigateToAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
} 