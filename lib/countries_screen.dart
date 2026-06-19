import 'package:flutter/material.dart';
import 'country_detail_screen.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // descriptions and custom matching title colors
    final List<Map<String, dynamic>> countryData = [
      {
        'name': 'Sri Lanka',
        'bgImage': 'assets/images/srilanka_bg.png',
        'fgImage': 'assets/images/srilanka_fg.png',
        'titleColor': const Color(0xFF1E3F00), // Deep Forest Green
        'description': 'Sri Lanka, or “The Pearl of the Indian Ocean” is an exquisite island country full of breathtaking landscapes, historical treasures, and genuine hospitality. It sits just south of India and is a treasure trove of ancient temples, an array of wildlife, and garlanded beaches and mountains, all within a few hours of travel.\n\nTourists can enjoy the waves in Arugam Bay, visit ancient ruins in Anuradhapura, walk through the tea-laden hills in Ella, or watch elephants in Yala National Park.\n\nWith a blend of culture, Sri Lanka is an exceptional and complete travel destination that guarantees remarkable memories.'
      },
      {
        'name': 'Dubai',
        'bgImage': 'assets/images/dubai_bg.png',
        'fgImage': 'assets/images/dubai_fg.png',
        'titleColor': const Color(0xFF543E2B), // Desert Brown/Slate
        'description': 'Dubai is a dazzling city where modern marvels meet ancient traditions. From the world’s tallest building, Burj Khalifa, to the golden sands of the Arabian Desert, Dubai offers a unique blend of luxury, adventure, and culture.\n\nExplore futuristic architecture, shop in lavish malls and traditional souks, cruise through the Dubai Marina, and experience the warm hospitality of Emirati culture. Whether you’re seeking thrills, relaxation, or unforgettable views — Dubai has it all.'
      },
      {
        'name': 'Singapore',
        'bgImage': 'assets/images/singapore_bg.png',
        'fgImage': 'assets/images/singapore_fg.png',
        'titleColor': const Color(0xFF1C2D37), // Slate Modern Blue/Charcoal
        'description': 'Singapore is a global hub where nature perfectly intertwines with futuristic innovation. Known as a "City in a Garden," this vibrant island nation boasts iconic supertrees at Gardens by the Bay, the striking Marina Bay Sands architecture, and world-class retail spaces.\n\nDelve into a rich cultural melting pot across vibrant neighborhoods like Chinatown and Little India, and enjoy an unforgettable street food scene. Singapore delivers a seamless, safe, and truly cutting-edge travel experience.'
      },
      {
        'name': 'Malaysia',
        'bgImage': 'assets/images/malaysia_bg.png',
        'fgImage': 'assets/images/malaysia_fg.png',
        'titleColor': const Color(0xFF0D47A1), // Deep Ocean Blue/Teal
        'description': 'Malaysia offers a beautiful contrast of bustling modern metropolises, historic colonial towns, and some of the world’s oldest rainforests. From the iconic Petronas Twin Towers in Kuala Lumpur to the cultural streets of Penang and the serene tea plantations of the Cameron Highlands, diversity defines this land.\n\nRelax on the pristine beaches of Langkawi or dive into local traditions. Truly Asia, Malaysia welcomes you with vibrant cultures, exceptional cuisine, and beautiful scenery.'
      },
      {
        'name': 'Japan',
        'bgImage': 'assets/images/japan_bg.png',
        'fgImage': 'assets/images/japan_fg.png',
        'titleColor': const Color(0xFF9E1B1B), // Iconic Crimson/Crimson Red
        'description': 'Japan is a mesmerizing destination where thousands of years of ancient tradition meet ultra-modern, neon-lit cities. It is a country of breathtaking seasonal transitions—from the soft pink cherry blossoms of spring to the snow-capped peak of Mount Fuji.\n\nJourney from the historic temples and serene bamboo groves of Kyoto to the high-tech, fast-paced streets of Tokyo. With its unmatched hospitality, precise engineering, and world-renowned culinary arts, Japan promises an immersive escape.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: screenWidth * 0.32,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                itemCount: countryData.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final country = countryData[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: screenHeight * 0.18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                country['bgImage']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.12),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CountryDetailScreen(
                                          title: country['name']!,
                                          description: country['description']!,
                                          imagePath: country['fgImage']!,
                                          titleColor: country['titleColor']!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              country['name']!,
                                              style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF222222),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * 0.36,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: AssetImage(country['fgImage']!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}