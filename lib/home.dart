import 'package:flutter/material.dart';
import 'armazenamento.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> registros = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await Armazenamento.carregar();

    setState(() {
      registros = dados;
    });
  }

  Future<void> salvar() async {
    await Armazenamento.salvar(registros);
  }

  void formulario({int? indice}) {
    final registro = indice == null ? null : registros[indice];

    final data = TextEditingController(
      text: registro?['data'] ?? '',
    );

    final combustivel = TextEditingController(
      text: registro?['combustivel'] ?? '',
    );

    final litros = TextEditingController(
      text: registro?['litros']?.toString() ?? '',
    );

    final valor = TextEditingController(
      text: (registro?['valor_pago'] ?? registro?['valor'])?.toString() ?? '',
    );

    final km = TextEditingController(
      text: registro?['quilometragem']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          indice == null
              ? 'Novo abastecimento'
              : 'Editar abastecimento',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: data,
                decoration: const InputDecoration(
                  labelText: 'Data',
                ),
              ),
              TextField(
                controller: combustivel,
                decoration: const InputDecoration(
                  labelText: 'Combustível',
                ),
              ),
              TextField(
                controller: litros,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Litros',
                ),
              ),
              TextField(
                controller: valor,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor pago',
                ),
              ),
              TextField(
                controller: km,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quilometragem',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final novo = {
                'data': data.text,
                'combustivel': combustivel.text,
                'litros': double.tryParse(
                      litros.text.replaceAll(',', '.'),
                    ) ??
                    0,
                'valor_pago': double.tryParse(
                      valor.text.replaceAll(',', '.'),
                    ) ??
                    0,
                'quilometragem': double.tryParse(
                      km.text.replaceAll(',', '.'),
                    ) ??
                    0,
              };

              if (data.text.isEmpty ||
                  combustivel.text.isEmpty ||
                  novo['litros'] == 0 ||
                  novo['valor_pago'] == 0 ||
                  novo['quilometragem'] == 0) {
                return;
              }

              setState(() {
                if (indice == null) {
                  registros.add(novo);
                } else {
                  registros[indice] = novo;
                }
              });

              await salvar();

              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  double get precoMedio {
    if (registros.isEmpty) {
      return 0;
    }

    double litros = 0;
    double valor = 0;

    for (final r in registros) {
      litros += (r['litros'] as num).toDouble();

      final valorRegistro =
          (r['valor_pago'] ?? r['valor'] ?? 0) as num;

      valor += valorRegistro.toDouble();
    }

    if (litros == 0) {
      return 0;
    }

    return valor / litros;
  }

  double get consumoMedio {
    if (registros.length < 2) {
      return 0;
    }

    final lista = List<Map<String, dynamic>>.from(registros);

    lista.sort((a, b) {
      final kmA = (a['quilometragem'] as num).toDouble();
      final kmB = (b['quilometragem'] as num).toDouble();

      return kmA.compareTo(kmB);
    });

    double totalKm = 0;
    double totalLitros = 0;

    for (int i = 1; i < lista.length; i++) {
      final kmAtual =
          (lista[i]['quilometragem'] as num).toDouble();

      final kmAnterior =
          (lista[i - 1]['quilometragem'] as num).toDouble();

      final litros =
          (lista[i]['litros'] as num).toDouble();

      final distancia = kmAtual - kmAnterior;

      if (distancia > 0 && litros > 0) {
        totalKm += distancia;
        totalLitros += litros;
      }
    }

    if (totalLitros == 0) {
      return 0;
    }

    return totalKm / totalLitros;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Abastecimentos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              size: 35,
            ),
            onPressed: () {
              formulario();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: registros.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (_, i) {
                final r = registros[i];

                final valorPago =
                    (r['valor_pago'] ?? r['valor'] ?? 0) as num;

                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      formulario(indice: i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  r['data'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints:
                                    const BoxConstraints(),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 23,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    registros.removeAt(i);
                                  });

                                  await salvar();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${(r['litros'] as num).toStringAsFixed(2)} L',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r['combustivel'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'R\$ ${valorPago.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${(r['quilometragem'] as num).toStringAsFixed(1)} km',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            if (registros.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text(
                        'Resumo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(
                                  alpha: .10,
                                ),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Preço médio',
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'R\$ ${precoMedio.toStringAsFixed(2)}/L',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(
                                  alpha: .10,
                                ),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Consumo médio',
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${consumoMedio.toStringAsFixed(2)} km/L',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}