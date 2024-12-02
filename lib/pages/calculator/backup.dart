import 'package:flutter/material.dart';
// import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:percent_indicator/linear_percent_indicator.dart' ;
import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:internet_speed_test/internet_speed_test.dart';


class DownloadTimeCalculator2 extends StatefulWidget {
  const DownloadTimeCalculator2({super.key});

  @override
  State<DownloadTimeCalculator2> createState() => _DownloadTimeCalculator2State();
}

class _DownloadTimeCalculator2State extends State<DownloadTimeCalculator2> {

  double displayProgress = 0.0;
  double _downloadRate = 0.0;
  double _uploadRate = 0.0;
  double displayRate = 0.0;
  bool isServerSelectionInProgress = false;
  bool isTestingStarted = false;

  String? _ip;
  String? _isp;
  String? _asn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 223, 223),
      appBar: AppBar(
        title: const Text('Download Time Calculator'),
        backgroundColor: const Color.fromARGB(255, 21, 120, 202),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          const Text("Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

          const SizedBox(height: 10,),
          LinearPercentIndicator(
            percent: displayProgress/100.0,
            lineHeight: 18,
            progressBorderColor: Colors.orange,
            center: Text(displayProgress.toStringAsFixed(1) + "%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
            barRadius: const Radius.circular(10),
          ),
          const SizedBox(height: 35,),

           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Upload Rate",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('$_uploadRate',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Download Rate",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('$_downloadRate',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20,),
          SfRadialGauge(
            axes: [
              RadialAxis(
                radiusFactor: 0.85,
                minorTicksPerInterval: 1,
                tickOffset: 3,
                useRangeColorForAxis: true,
                interval: 5,
                minimum: 0,
                maximum: 100,
                showLastLabel: true,
                axisLabelStyle: const GaugeTextStyle(
                  color: Colors.black
                ),
                ranges: [
                  GaugeRange(
                    startValue: 0,
                    endValue: 100,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10,
                  )
                ],
                pointers: [
                  NeedlePointer(
                    value: displayRate,
                    enableAnimation: true,
                    needleColor: Colors.black,
                    tailStyle: const TailStyle(color: Colors.green, borderWidth: 0.1,borderColor: Colors.blue),
                    knobStyle: const KnobStyle(color: Colors.white),

                  )
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Container(
                      child: Text(displayRate.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
                    ),
                    angle: 90,
                    positionFactor: 0.6,

                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10,),
          Text(
            isServerSelectionInProgress?'Memilih Server...':'IP : ${_ip??'__'} | ASN : ${_asn??'__'} | ISP : ${_isp??'__'}',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 113, 191, 255)
            ),
            onPressed: () {
              null;
              // testingFunction();
            },
            child: const Text("Mulai Perhitungan", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),)
          )



        ],
      ),
    );
  }

}

//   testingFunction(){
    

//   final internetSpeedTest = InternetSpeedTest();

//   internetSpeedTest.startDownloadTesting(
    
//      onDone: (double transferRate, SpeedUnit unit) {
//         // TODO: Change UI
//      },
//      onProgress: (double percent, double transferRate, SpeedUnit unit) {
//         // TODO: Change UI
//      },
//      onError: (String errorMessage, String speedTestError) {
//         // TODO: Show toast error
//      },
//    );



//   internetSpeedTest.startUploadTesting(
//      onDone: (double transferRate, SpeedUnit unit) {
//        print('the transfer rate $transferRate');
//        setState(() {
//          // TODO: Change UI
//        });
//      },
//      onProgress: (double percent, double transferRate, SpeedUnit unit) {
//        print(
//            'the transfer rate $transferRate, the percent $percent');
//        setState(() {
//          // TODO: Change UI
//        });
//      },
//      onError: (String errorMessage, String speedTestError) {
//        // TODO: Show toast error
//      },
//   );
// }



//   testingFunctionold(){
    
//     final speedTest = FlutterInternetSpeedTest();
//     speedTest.startTesting(
//         onStarted: () {
//           setState(() {
//             isTestingStarted = true;
//           });
//         },
//         onCompleted: (TestResult download, TestResult upload) {
//           setState(() {
//             _downloadRate = download.transferRate;
//             displayProgress = 100.0;
//             displayRate = _downloadRate;
//           });
//           setState(() {
//             _uploadRate = upload.transferRate;
//             displayProgress = 100.0;
//             displayRate = _uploadRate;
//             isTestingStarted = false;
//           });
//         },
//         onProgress: (double percent, TestResult data) {
//           setState(() {
//             if(data.type == TestType.download){
//               _downloadRate = data.transferRate;
//               displayRate = _downloadRate;
//               displayProgress = percent;
//             }else{
//               _uploadRate = data.transferRate;
//               displayRate = _uploadRate;
//               displayProgress = percent;
//             }
//           });
//         },
//         onError: (String errorMessage, String speedTestError) {
//           print('error: $errorMessage, $speedTestError');
//         },
//         onDefaultServerSelectionInProgress: () {
//           setState(() {
//             isServerSelectionInProgress = true;
//           });
//         },
//         onDefaultServerSelectionDone: (Client? client) {
//           setState(() {
//             isServerSelectionInProgress = false;
//             _ip = client!.ip;
//             _asn = client.asn;
//             _isp = client.isp;
//           });
//         },
//         onDownloadComplete: (TestResult data) {
//           setState(() {
//             _downloadRate = data.transferRate;
//             displayRate = _downloadRate;
//           });
//         },
//         onUploadComplete: (TestResult data) {
//           setState(() {
//             _uploadRate = data.transferRate;
//             displayRate = _uploadRate;
//           });
//         },
//     );
//   }
// }