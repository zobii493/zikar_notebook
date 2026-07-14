import 'package:flutter/material.dart';
import 'package:naqashbandi_shazli/PdfView/fayzunnoor_pdf.dart';

import '../../../core/app_colors.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String pdfPath;
  final String pdfTitle;
  final String backgroundImage; // add background image path

  const BookCard({
    Key? key,
    required this.title,
    required this.pdfPath,
    required this.pdfTitle,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Fayzunoorpdf(path: pdfPath, title: pdfTitle),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(backgroundImage), // background image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(
              0.3,
            ), // dark overlay for readability
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'FEATURED READING',
                style: const TextStyle(
                  color: AppColors.antiqueGoldColor,
                  fontSize: 14,
                  fontFamily: "PlusJakartaSans",
                ),
              ),
              Align(
                alignment: .centerRight,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Amiri',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.antiqueGoldColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Fayzunoorpdf(path: pdfPath, title: pdfTitle),
                    ),
                  );
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: AppColors.emeraldDeepColor,
                    fontSize: 16,
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
