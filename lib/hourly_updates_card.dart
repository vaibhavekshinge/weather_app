
import 'package:flutter/material.dart';

class HourlyUpdatesCard extends StatelessWidget {
  final String time;
  final String temp;
  final  IconData icon;

  const HourlyUpdatesCard({
    super.key, 
    required this.time, 
    required this.temp, 
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
                    elevation: 6,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8,),
                                        
                          Icon(
                            icon,
                            size: 32,
                          ),
                          const SizedBox(height: 8,),
                                        
                          Text(
                            "$temp K",
                          ),
                        ],
                      ),
                    ),
                  );
  }
}