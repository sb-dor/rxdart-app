import 'package:flutter/material.dart';
import 'package:rxdart_app/filter_chip/bloc/filter_chip_bloc.dart';
import 'package:rxdart_app/filter_chip/models/type_of_thing.dart';

const Iterable<ThingFilterChip> things = [
  ThingFilterChip(name: "Foo", typeOfThing: TypeOfThing.person),
  ThingFilterChip(name: "Bar", typeOfThing: TypeOfThing.person),
  ThingFilterChip(name: "Baz", typeOfThing: TypeOfThing.person),
  ThingFilterChip(name: "Bunz", typeOfThing: TypeOfThing.animal),
  ThingFilterChip(name: "Flutffers", typeOfThing: TypeOfThing.animal),
  ThingFilterChip(name: "Woofz", typeOfThing: TypeOfThing.animal),
];

class FilterChipPage extends StatefulWidget {
  const FilterChipPage({super.key});

  @override
  State<FilterChipPage> createState() => _FilterChipPageState();
}

class _FilterChipPageState extends State<FilterChipPage> {
  late final FilterChipBloc _filterChipBloc;

  @override
  void initState() {
    super.initState();
    _filterChipBloc = FilterChipBloc(
      things: things,
    );
  }

  @override
  void dispose() {
    _filterChipBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter chip with RxDart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<TypeOfThing?>(
              stream: _filterChipBloc.currentTypeOfThing,
              builder: (context, snapshot) {
                final selected = snapshot.data;
                return Wrap(
                    spacing: 10,
                    children: TypeOfThing.values
                        .map(
                          (typeOfThing) => FilterChip(
                            label: Text(typeOfThing.name),
                            onSelected: (selected) {
                              final type = selected ? typeOfThing : null;
                              _filterChipBloc.typeOfThing.add(type);
                            },
                            selectedColor: Colors.blueAccent,
                            selected: selected == typeOfThing,
                          ),
                        )
                        .toList());
              },
            ),
            Expanded(
              child: StreamBuilder<Iterable<ThingFilterChip>>(
                stream: _filterChipBloc.things,
                builder: (context, snapshot) {
                  final things = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: things.length,
                    itemBuilder: (context, index) {
                      final thing = things.elementAt(index);
                      return ListTile(
                        title: Text(thing.name),
                        subtitle: Text(thing.typeOfThing.name),
                      );
                    },
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
