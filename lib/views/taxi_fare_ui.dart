import 'package:flutter/material.dart';

class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  final TextEditingController distanceController = TextEditingController();

  final TextEditingController trafficController = TextEditingController();

  final Color taxiYellow = const Color(0xFFFFC107);
  final Color pageColor = const Color(0xFFFFF7FF);

  double fare = 0.0;
  String? errorMessage;
  bool calculated = false;

  // คำนวณค่าโดยสารตามระยะทาง
  double calculateDistanceFare(double distance) {
    if (distance <= 0) {
      return 0.0;
    }

    double total = 35.0;
    double remaining = distance - 1.0;

    // กิโลเมตรที่ 2-10
    double km = remaining.clamp(0.0, 9.0);
    total += km * 6.50;
    remaining -= km;

    // กิโลเมตรที่ 11-20
    km = remaining.clamp(0.0, 10.0);
    total += km * 7.00;
    remaining -= km;

    // กิโลเมตรที่ 21-40
    km = remaining.clamp(0.0, 20.0);
    total += km * 8.00;
    remaining -= km;

    // กิโลเมตรที่ 41-60
    km = remaining.clamp(0.0, 20.0);
    total += km * 8.50;
    remaining -= km;

    // กิโลเมตรที่ 61-80
    km = remaining.clamp(0.0, 20.0);
    total += km * 9.00;
    remaining -= km;

    // ระยะทางเกิน 80 กิโลเมตร
    if (remaining > 0) {
      total += remaining * 10.50;
    }

    return total;
  }

  // ปุ่มคำนวณ
  void calculateFare() {
    FocusScope.of(context).unfocus();

    final distance = double.tryParse(distanceController.text.trim());

    final trafficMinutes = double.tryParse(trafficController.text.trim());

    if (distance == null ||
        trafficMinutes == null ||
        distance <= 0 ||
        trafficMinutes < 0) {
      setState(() {
        fare = 0.0;
        calculated = false;
        errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
      });
      return;
    }

    final distanceFare = calculateDistanceFare(distance);
    final trafficFare = trafficMinutes * 3.0;

    setState(() {
      fare = distanceFare + trafficFare;
      calculated = true;
      errorMessage = null;
    });
  }

  // ปุ่มยกเลิก
  void clearForm() {
    FocusScope.of(context).unfocus();

    setState(() {
      distanceController.clear();
      trafficController.clear();
      fare = 0.0;
      calculated = false;
      errorMessage = null;
    });
  }

  @override
  void dispose() {
    distanceController.dispose();
    trafficController.dispose();
    super.dispose();
  }

  // ช่องกรอกข้อมูล
  Widget buildInputField({
    required String label,
    required String hint,
    required String emoji,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label $emoji',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF292329),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            filled: true,
            fillColor: pageColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFB8AFB8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Color(0xFFB8AFB8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: taxiYellow,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Column(
          children: [
            // แถบหัวข้อด้านบน
            Container(
              width: double.infinity,
              height: 55,
              color: taxiYellow,
              alignment: Alignment.center,
              child: const Text(
                'Taxi Fare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // เนื้อหาหลัก
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    decoration: BoxDecoration(
                      color: pageColor,
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      20,
                      22,
                      20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // รูปแท็กซี่
                        SizedBox(
                          height: 145,
                          child: Image.asset(
                            'assets/images/taxi.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.local_taxi,
                                size: 100,
                                color: taxiYellow,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          'คำนวณค่าโดยสารแท็กซี่',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF292329),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ช่องระยะทาง
                        buildInputField(
                          label: 'ระยะทาง (กิโลเมตร)',
                          hint: 'กรุณากรอกระยะทาง',
                          emoji: '🚦',
                          controller: distanceController,
                        ),

                        const SizedBox(height: 20),

                        // ช่องเวลารถติด
                        buildInputField(
                          label: 'เวลารถติด (นาที)',
                          hint: 'กรุณากรอกเวลารถติด',
                          emoji: '⏰',
                          controller: trafficController,
                        ),

                        const SizedBox(height: 24),

                        // ปุ่มคำนวณ
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: calculateFare,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: taxiYellow,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'คำนวณค่าโดยสาร',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ปุ่มยกเลิก
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: clearForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // กล่องแสดงค่าโดยสาร
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECB3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'ค่าโดยสารแท็กซี่',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                fare.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF4436),
                                ),
                              ),
                              const Text(
                                'บาท',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // แถบแจ้งเตือนสีแดง
                        if (errorMessage != null) ...[
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            color: Colors.red,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.yellow,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // แจ้งเตือนเมื่อคำนวณสำเร็จ
                        if (calculated) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'คำนวณค่าโดยสารเรียบร้อยแล้ว',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
