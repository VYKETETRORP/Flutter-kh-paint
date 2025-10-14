import 'package:flutter/material.dart';
import 'package:test_form/models.dart' as models;
class OutletSelectionScreen extends StatefulWidget {
  final List<models.Outlet> outlets;
  final models.Outlet? selectedOutlet;
  final Function(models.Outlet) onOutletSelected;

  const OutletSelectionScreen({
    super.key,
    required this.outlets,
    this.selectedOutlet,
    required this.onOutletSelected,
  });

  @override
  State<OutletSelectionScreen> createState() => _OutletSelectionScreenState();
}

class _OutletSelectionScreenState extends State<OutletSelectionScreen> {
  List<models.Outlet> filteredOutlets = [];
  TextEditingController searchController = TextEditingController();

  @override

  void initState() {
    super.initState();
    filteredOutlets = widget.outlets;
  }


  void _filterOutlets(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOutlets = widget.outlets;
      } else {
        filteredOutlets = widget.outlets
            .where((outlet) =>
                outlet.name.toLowerCase().contains(query.toLowerCase()) ||
                outlet.address.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Outlet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Map view functionality
        //     },
        //     icon: Icon(Icons.map_outlined, color: Colors.white),
        //   ),
        //   IconButton(
        //     onPressed: () {
        //       // Add new outlet functionality
        //     },
        //     icon: Icon(Icons.add, color: Colors.white),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.red,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterOutlets,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.tune, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text(
                  'No filters applied',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Outlets List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredOutlets.length,
              itemBuilder: (context, index) {
                final outlet = filteredOutlets[index];
                final isSelected = widget.selectedOutlet?.id == outlet.id;

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Outlet Icon
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.store,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                            ),

                            SizedBox(width: 16),

                            // Outlet Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    outlet.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '+855135255556', // Sample phone number
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Active Status
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(16),
                                // border: Border.all(color: Colors.blue[300]!),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Outlet Info
                        Row(
                          children: [
                            Icon(Icons.business, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'ភោជនីយដ្ឋាន',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'CA2',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(Icons.place, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                outlet.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // GestureDetector(
                              // onTap: () {
                                // Open map functionality
                              // },
                              // child: Container(
                              //   padding: EdgeInsets.all(8),
                              //   decoration: BoxDecoration(
                              //     color: Colors.blue[50],
                              //     borderRadius: BorderRadius.circular(8),
                                // ),
                                // child: Icon(
                                //   Icons.map,
                                //   color: Colors.blue,
                                //   size: 20,
                                // ),
                              // ),
                            // ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Select Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onOutletSelected(outlet);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.red : Colors.grey[200],
                              foregroundColor: isSelected ? Colors.white : Colors.grey[700],
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isSelected ? 'Selected' : 'Select',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}