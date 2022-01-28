import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimationsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ContainerTransformDemo(),
    );
  }
}

class ContainerTransformDemo extends StatefulWidget {
  const ContainerTransformDemo({
    Key? key
  }): super(key: key);

  @override
  _ContainerTransformDemoState createState() {
    return _ContainerTransformDemoState();
  }
}

class _ContainerTransformDemoState extends State < ContainerTransformDemo > {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Container transform demo'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8.0),
              children: <Widget>[
              ...List<Widget>.generate(10, (int index) {
              return OpenContainer<bool>(
                transitionType: _transitionType,
                openBuilder: (BuildContext _, VoidCallback openContainer) {
                  return _DemoDetailsPage();
                },
                closedShape: const RoundedRectangleBorder(),
                closedElevation: 0.0,
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return ListTile(
                    onTap: openContainer,
                    title: Text('Title item {index + 1}'),
                    subtitle: const Text('subtitle text'),
                  );
                },
              );
          }),
        ],
      ),
    );
  }
}

class _DemoDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo details page'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black54,
                        fontSize: 30.0,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Demo details page',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 16.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}