import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;

  const SearchBarWidget({
    Key? key,
    required this.destination,
    required this.onTap,
  }) : super(key: key);
  final TextEditingController destination;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: destination,
              readOnly: true,
              onTap: onTap,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Search for a destination',
                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
