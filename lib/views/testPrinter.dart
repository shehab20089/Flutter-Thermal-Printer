import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';

class TestPrinter extends StatefulWidget {
  TestPrinter({Key key}) : super(key: key);

  @override
  _TestPrinterState createState() => _TestPrinterState();
}

class _TestPrinterState extends State<TestPrinter> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Demo'),
      ),
      body: ListView.builder(
        itemBuilder: (context, position) => ListTile(
          onTap: () {
            printerManager.selectPrinter(_devices[position]);
            Ticket ticket = Ticket(PaperSize.mm58);
            ticket.text('ازيك ياض يا عادل');
            ticket.feed(1);
            ticket.cut();
            printerManager.printTicket(ticket).then((result) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(result.msg)));
            }).catchError((error) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
            });
          },
          title: Text(_devices[position].name),
          subtitle: Text(_devices[position].address),
        ),
        itemCount: _devices.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          printerManager.scanResults.listen((printers) async {
            setState(() {
              _devices = printers;
            });
            print(printers.toString());
          });
          printerManager.startScan(Duration(seconds: 4));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
