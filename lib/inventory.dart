import 'package:flutter/material.dart';

// Model to represent inventory items with Size support
class InventoryItem {
  final String id;
  final String name;
  final String size; // e.g. M, L, XL, 32, 34
  final String category;
  int storeQty;
  int godownQty;
  int factoryQty;

  InventoryItem({
    required this.id,
    required this.name,
    required this.size,
    required this.category,
    required this.storeQty,
    required this.godownQty,
    required this.factoryQty,
  });

  int get totalQty => storeQty + godownQty + factoryQty;
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String selectedSection = 'All'; // 'All', 'Store', 'Godown', 'Factory'
  String searchQuery = '';

  // Sample inventory database with sizes
  List<InventoryItem> inventoryList = [
    InventoryItem(
      id: '1',
      name: 'Cotton T-Shirt',
      size: 'M',
      category: 'Apparel',
      storeQty: 150,
      godownQty: 500,
      factoryQty: 1200,
    ),
    InventoryItem(
      id: '2',
      name: 'Cotton T-Shirt',
      size: 'L',
      category: 'Apparel',
      storeQty: 90,
      godownQty: 400,
      factoryQty: 950,
    ),
    InventoryItem(
      id: '3',
      name: 'Denim Jeans',
      size: '32',
      category: 'Apparel',
      storeQty: 80,
      godownQty: 300,
      factoryQty: 800,
    ),
    InventoryItem(
      id: '4',
      name: 'Sada Buta',
      size: 'Free Size',
      category: 'Apparel',
      storeQty: 20,
      godownQty: 40,
      factoryQty: 40,
    ),
  ];

  // Filter items based on active section tab & search query
  List<InventoryItem> get filteredItems {
    return inventoryList.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.size.toLowerCase().contains(searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (selectedSection == 'Store') return item.storeQty > 0;
      if (selectedSection == 'Godown') return item.godownQty > 0;
      if (selectedSection == 'Factory') return item.factoryQty > 0;
      return true; // 'All'
    }).toList();
  }

  void _addNewProduct(String name, String size, String category, int store, int godown, int factory) {
    setState(() {
      inventoryList.add(
        InventoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          size: size.isEmpty ? 'N/A' : size,
          category: category,
          storeQty: store,
          godownQty: godown,
          factoryQty: factory,
        ),
      );
    });
  }

  bool _transferStock(InventoryItem item, String from, String to, int amount) {
    if (amount <= 0) return false;

    int sourceQty = 0;
    if (from == 'Store') sourceQty = item.storeQty;
    if (from == 'Godown') sourceQty = item.godownQty;
    if (from == 'Factory') sourceQty = item.factoryQty;

    if (sourceQty < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient stock in $from! Available: $sourceQty'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    setState(() {
      // Deduct from Source
      if (from == 'Store') item.storeQty -= amount;
      if (from == 'Godown') item.godownQty -= amount;
      if (from == 'Factory') item.factoryQty -= amount;

      // Add to Destination
      if (to == 'Store') item.storeQty += amount;
      if (to == 'Godown') item.godownQty += amount;
      if (to == 'Factory') item.factoryQty += amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transferred $amount units of ${item.name} (${item.size}) to $to!'),
        backgroundColor: const Color(0xFF15966A),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF15966A);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Smaller Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: primaryColor,
        elevation: 3,
        icon: const Icon(Icons.add, color: Colors.white, size: 20),
        label: const Text(
          "Add Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH & SECTION FILTER BAR
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search name or size...",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabButton("All", primaryColor),
                      _buildTabButton("Store", primaryColor),
                      _buildTabButton("Godown", primaryColor),
                      _buildTabButton("Factory", primaryColor),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.black12),

            // DYNAMIC PRODUCT LIST WITH EXTRA BOTTOM PADDING TO AVOID BUTTON CONFLICT
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                child: Text(
                  "No items found for $selectedSection",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
                  : ListView.builder(
                // Extra bottom padding (80) ensures the last item is never hidden behind the FAB!
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _buildInventoryCard(item, primaryColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, Color primaryColor) {
    final isSelected = selectedSection == label;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? primaryColor : Colors.grey.shade100,
            foregroundColor: isSelected ? Colors.white : Colors.black87,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onPressed: () => setState(() => selectedSection = label),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Section-specific Dynamic Product Card
  Widget _buildInventoryCard(InventoryItem item, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Size Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // SIZE BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Size: ${item.size}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              // Total badge shown on 'All' tab
              if (selectedSection == 'All')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF5E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Total: ${item.totalQty}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // DYNAMIC CONTENT BASED ON SELECTED SECTION
          if (selectedSection == 'All') ...[
            Row(
              children: [
                _buildStockBadge("Store", item.storeQty, Colors.blue.shade700, Colors.blue.shade50),
                const SizedBox(width: 8),
                _buildStockBadge("Godown", item.godownQty, Colors.amber.shade900, Colors.amber.shade50),
                const SizedBox(width: 8),
                _buildStockBadge("Factory", item.factoryQty, primaryColor, const Color(0xFFDDF5E8)),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _showTransferBottomSheet(context, item, primaryColor, initialFrom: 'Factory'),
              child: Row(
                children: const [
                  Text(
                    "Tap to move stock between locations",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.swap_horiz, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ] else ...[
            // CUSTOM UI FOR SPECIFIC TABS (Store / Godown / Factory)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      selectedSection == 'Store'
                          ? Icons.store
                          : selectedSection == 'Godown'
                          ? Icons.warehouse
                          : Icons.factory,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "In $selectedSection: ",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "${selectedSection == 'Store' ? item.storeQty : selectedSection == 'Godown' ? item.godownQty : item.factoryQty} pcs",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // Compact "Move Stock" Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor.withOpacity(0.4)),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => _showTransferBottomSheet(
                    context,
                    item,
                    primaryColor,
                    initialFrom: selectedSection,
                  ),
                  icon: const Icon(Icons.swap_horiz, size: 14),
                  label: const Text(
                    "Move Stock",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockBadge(String label, int qty, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.bold),
            ),
            Text(
              "$qty",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  // Stock Transfer Modal
  void _showTransferBottomSheet(
      BuildContext context,
      InventoryItem item,
      Color primaryColor, {
        required String initialFrom,
      }) {
    String fromLocation = initialFrom;
    String toLocation = initialFrom == 'Store' ? 'Godown' : 'Store';
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transfer Stock: ${item.name}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Size: ${item.size}",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From Location", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            DropdownButton<String>(
                              value: fromLocation,
                              isExpanded: true,
                              items: ['Store', 'Godown', 'Factory'].map((loc) {
                                return DropdownMenuItem(value: loc, child: Text(loc));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => fromLocation = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.grey),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To Location", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            DropdownButton<String>(
                              value: toLocation,
                              isExpanded: true,
                              items: ['Store', 'Godown', 'Factory'].map((loc) {
                                return DropdownMenuItem(value: loc, child: Text(loc));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setModalState(() => toLocation = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Quantity to Transfer",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (fromLocation == toLocation) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Source and destination cannot be the same!')),
                          );
                          return;
                        }
                        final amount = int.tryParse(amountController.text) ?? 0;
                        if (_transferStock(item, fromLocation, toLocation, amount)) {
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text(
                        "Confirm Transfer",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Add New Product Dialog Modal
  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final sizeController = TextEditingController();
    final categoryController = TextEditingController(text: "Apparel");
    final storeController = TextEditingController(text: "0");
    final godownController = TextEditingController(text: "0");
    final factoryController = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add New Product"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name (e.g. T-Shirt)"),
                ),
                TextField(
                  controller: sizeController,
                  decoration: const InputDecoration(labelText: "Size (e.g. M, L, XL, 32)"),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),
                TextField(
                  controller: storeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Store Initial Stock"),
                ),
                TextField(
                  controller: godownController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Godown Initial Stock"),
                ),
                TextField(
                  controller: factoryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Factory Initial Stock"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15966A)),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _addNewProduct(
                    nameController.text,
                    sizeController.text,
                    categoryController.text,
                    int.tryParse(storeController.text) ?? 0,
                    int.tryParse(godownController.text) ?? 0,
                    int.tryParse(factoryController.text) ?? 0,
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}