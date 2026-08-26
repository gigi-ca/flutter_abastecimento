import 'package:flutter/material.dart';
import 'home.dart';

class Splash extends StatelessWidget {
  final bool escuro;
  final VoidCallback mudarTema;

  const Splash({
    super.key,
    required this.escuro,
    required this.mudarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(
              width: 120,
              height: 120,

              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(
                  alpha: .15,
                ),

                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: const Icon(
                Icons.local_gas_station,
                size: 65,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Abastecimentos',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 35),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Text(
                  'Tema escuro',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                Switch(
                  value: escuro,
                  onChanged: (_) {
                    mudarTema();
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: 150,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Home(),
                    ),
                  );
                },

                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}