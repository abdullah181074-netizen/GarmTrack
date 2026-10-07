import 'package:flutter/material.dart';

// --- DATA MODELS ---

class Worker {
  final String id;
  final String name;
  final String sector;
  final String garmentsName; // Used to filter workers under the specific admin garments

  Worker({
    required this.id,
    required this.name,
    required this.sector,
    required this.garmentsName,
  });
}

// Global or shared database/list simulating registered workers from the registration page
class WorkerDatabase {
  static final List<Worker> registeredWorkers = [
    Worker(id: 'W001', name: 'Rahim Ahmed', sector: 'Cutting Operator', garmentsName: 'ABC Fashion Ltd.'),
    Worker(id: 'W002', name: 'Sumi Akter', sector: 'Sewing Operator', garmentsName: 'ABC Fashion Ltd.'),
    Worker(id: 'W003', name: 'Md. Hasan', sector: 'Printing Operator', garmentsName: 'XYZ Apparels'),
    Worker(id: 'W004', name: 'Fatema Begum', sector: 'Finishing Operator', garmentsName: 'ABC Fashion Ltd.'),
  ];

  // Function to dynamically add a worker (called during registration)
  static void addWorker(Worker worker) {
    registeredWorkers.add(worker);
  }
}

// --- WORKERS SCREEN ---

class WorkersScreen extends StatefulWidget {
  final String adminGarmentsName; // The garments name of the logged-in admin

  const WorkersScreen({super.key,
    required this.adminGarmentsName
  });

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Automatically filter workers belonging ONLY to the admin's garments name
    List<Worker> filteredWorkers = WorkerDatabase.registeredWorkers
        .where((worker) => worker.garmentsName.toLowerCase() == widget.adminGarmentsName.toLowerCase())
        .where((worker) => worker.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        worker.sector.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Workers'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search worker...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Dynamic List of Workers matching the admin's garments
          Expanded(
            child: filteredWorkers.isEmpty
                ? const Center(
              child: Text(
                'No workers found for your garments.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                final worker = filteredWorkers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      worker.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.sector,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${worker.id}',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      // When clicked, navigate to your Product Assignment / Order screen for this worker
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignProductScreen(worker: worker),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- ASSIGN PRODUCT SCREEN (Target Page on Worker Click) ---

class AssignProductScreen extends StatelessWidget {
  final Worker worker;

  const AssignProductScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Assign Product: ${worker.name}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Worker: ${worker.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Sector: ${worker.sector} (${worker.id})',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const Divider(height: 32),
            const Text(
              'Add New Product to Complete:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            // You can integrate your previous Product/Order form controls here!
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product assigned to ${worker.name}!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Save & Assign Product', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}