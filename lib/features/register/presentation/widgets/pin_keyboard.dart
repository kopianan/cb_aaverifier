import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final void Function(int)? onTapNumber;
  final void Function()? onBackspace;
  final bool withBiometric;
  final void Function()? onBiometrics;

  const PinKeyboard({
    Key? key,
    this.withBiometric = false,
    this.onTapNumber,
    this.onBackspace,
    this.onBiometrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(
            4,
            (i) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (x) {
                int index = i * 3 + 1 + x;
                if (index == 10) {
                  return Expanded(
                      child:(withBiometric) ?  Container( 
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey[200]!),
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                onBiometrics!();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(25),
                                child: Icon(
                                  Icons.fingerprint,
                                  size: 30,
                                ),
                              ),
                            ),
                          )) : SizedBox());
                } else if (index == 11) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey[200]!),
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onTapNumber!(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '0',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (index == 12) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey[200]!),
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onBackspace,
                          child: const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.backspace_outlined,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey[200]!),
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onTapNumber!(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            '$index',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
