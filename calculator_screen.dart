import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    number1.isEmpty && operand.isEmpty && number2.isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues.map((value) {
                return SizedBox(
                  width: value == Btn.n0
                      ? screenSize.width / 2
                      : screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: getBtnColor(value),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Color.fromARGB(60, 86, 118, 155)),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
    } else if (value == Btn.clr) {
      clearAll();
    } else if (value == Btn.per) {
      convertToPercentage();
    } else if (value == Btn.calculate) {
      calculate();
    } else {
      appendValue(value);
    }
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final num1 = double.parse(number1);
    final num2 = double.parse(number2);

    double result;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
        return;
    }

    setState(() {
      number1 = result.toString();
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isEmpty) return;

    if (operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    final number = double.parse(number1);
    setState(() {
      number1 = (number / 100).toString();
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  void appendValue(String value) {
    final isNumber = int.tryParse(value) != null;
    final isDot = value == Btn.dot;

    if (!isNumber && !isDot) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (operand.isEmpty) {
      if (isDot && number1.contains(Btn.dot)) return;
      number1 += value == Btn.dot && number1.isEmpty ? "0." : value;
    } else {
      if (isDot && number2.contains(Btn.dot)) return;
      number2 += value == Btn.dot && number2.isEmpty ? "0." : value;
    }

    setState(() {});
  }

  Color getBtnColor(String value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return const Color.fromARGB(255, 138, 184, 207);
    } else if ([
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)) {
      return const Color.fromARGB(255, 42, 108, 230);
    }
    return Colors.black87;
  }
}
