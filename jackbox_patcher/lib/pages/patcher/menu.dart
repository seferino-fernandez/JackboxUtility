import 'package:fluent_ui/fluent_ui.dart';

import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'pack.dart';

class PatcherMenuWidget extends StatefulWidget {
  PatcherMenuWidget({Key? key}) : super(key: key);

  @override
  State<PatcherMenuWidget> createState() => _PatcherMenuWidgetState();
}

class _PatcherMenuWidgetState extends State<PatcherMenuWidget> {
  
   int _selectedView = 0;
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,leading:GestureDetector(child: Icon(FluentIcons.chevron_left), onTap: () => Navigator.pop(context),), title: Text("Jackbox patcher", style: typography.title,)),
      pane: NavigationPane(
        onChanged: (int nSelected) {
          setState(() {
            _selectedView = nSelected;
          });
        },
        selected: _selectedView,
        items: _buildPaneItems(),
      ),
    );
  }

  _buildPaneItems() {
    List<NavigationPaneItem> items = [
    ];
    List<NavigationPaneItem> patchingItems = [];
    for (var userPack in UserData().packs) {
      int countPatchs = 0;
      for (var games in userPack.games) {
        for (var patch in games.patches) {
          countPatchs = 1;
          break;
        }
      }
      if (countPatchs == 1) {
        items.add(PaneItem(
            icon: Image.network(APIService().assetLink(userPack.pack.icon)),
            title: Text(userPack.pack.name),
            body: PatcherPackWidget(userPack: userPack)));
      }
    }

    return items;
  }
}