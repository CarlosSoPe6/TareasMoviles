import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'home_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeBloc _homeBloc;

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  void handleClick(String value) {
    print(value);
    switch (value) {
      case 'Pares':
        _homeBloc.add(FilterUsersEvent(filterEven: true));
        break;
      case 'Impares':
        _homeBloc.add(FilterUsersEvent(filterEven: false));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _homeBloc =  HomeBloc()..add(GetAllUsersEvent());
        return _homeBloc;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Users list"), actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Pares', 'Impares'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ]),
        body: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              // para mostrar dialogos o snackbars
              if (state is ErrorState) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text("Error: ${state.error}")),
                  );
              }
            },
            builder: (context, state) {
              if (state is ShowUsersState) {
                return RefreshIndicator(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: state.usersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new HomeListItem(user: state.usersList[index]);
                    },
                  ),
                  onRefresh: () async {
                    BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                  },
                );
              } else if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(
                child: MaterialButton(
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                  },
                  child: Text("Cargar de nuevo"),
                ),
              );
            },
          ),
        ),
      );
  }
}
