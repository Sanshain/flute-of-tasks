import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanshain_tasks/models/settings.dart';
import 'package:sanshain_tasks/utils/localizations.dart';
import 'package:sanshain_tasks/widgets/popups.dart';

import '../controller.dart';


final List<String> orders = [
    "creation time",
    "importance",
    "urgency",
    "expiration time",
];


class SettingsPage extends StatelessWidget {

    const SettingsPage({Key? key, this.themeNotifier}) : super(key: key);

    final ValueNotifier<ThemeMode>? themeNotifier;

    @override Widget build(context) {

        // Instantiate your class using Get.put() to make it available for all "child" routes there.
        final Controller controller = Get.find();

        Text _buildItem(String text) {
            return Text(text,
//              style: TextStyle(fontSize: 16, color: Colors.black38),
                style: TextStyle(
                    fontSize: 16,
//                   color: (themeNotifier?.value == ThemeMode.dark) ? Theme.of(context).primaryColor : Colors.black38
                    color: (themeNotifier?.value == ThemeMode.dark) ? Colors.white54 : Colors.black38
                ),
            );
        }

        Future<void> saveOption(String name, String value) async
        {
            var option = Setting.init(name, value: value);
            var hasOption = controller.options.where((opt) => opt.name == 'order').isNotEmpty;

            if (hasOption){
                await Setting.objects?.updateItem(option);
            } else {
                await Setting.objects?.insertItem(option);
            }
        }

        return Scaffold(
            // Use Obx(()=> to update Text() whenever count is changed.
//            appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('settings'))),

            // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
//            body: Center(child: ElevatedButton(
//                child: Text("Go to Other"), onPressed: () => Get.to(Other()))
//            ),

            body: WillPopScope(
                child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                        Obx(() => ListTile(
                            title: _buildItem(AppLocalizations.of(context)!.translate('Dark theme')),
                            trailing: CupertinoSwitch(
                                value: controller.settings.containsKey('theme')
                                    ? controller.settings['theme'] == true.toString()
                                    : false,
                                activeColor: CupertinoColors.secondarySystemFill,
                                trackColor: CupertinoColors.systemTeal,
                                // trackColor: Theme.of(context).primaryColor,
                                onChanged: (val) {
//                                    popup(context, 'in process (to do)');
//                                    MediaQuery.of(context).platformBrightness == Brightness.dark;
                                    var curTheme =  MediaQuery.of(context).platformBrightness;
                                    themeNotifier?.value = val ? ThemeMode.dark : ThemeMode.light;
                                    controller.settings['theme'] = val.toString();
                                },
                            ),
                            onTap: () {},
                        )),
                        Obx(() => ListTile(
                            title: _buildItem(AppLocalizations.of(context)!.translate('Default order')),
                            trailing: DropdownButton<int>(
                                value: int.parse(controller.settings['order'] ?? '1'),
                                items:[
                                    for (var order in orders)
                                        DropdownMenuItem(
                                            // child: Text('$order (${orders.indexOf(order)})', style: const TextStyle(color: Colors.black45), ),
                                            child: Text(order, style: const TextStyle(color: Colors.black45), ),
                                            value: orders.indexOf(order),
                                        )
                                ],
                                onChanged: (int? value) async {
                                    if (value != null){
                                        controller.settings['order'] = value.toString();
                                        await saveOption('order', value.toString());
                                    }
                                    // popup(context, 'only By time of creation is available now');
                                },
                            ),
                        )),
                        Obx(() => ListTile(
                            title: _buildItem(AppLocalizations.of(context)!.translate('show the remainder')),
                            trailing: CupertinoSwitch(
                                activeColor: CupertinoColors.secondarySystemFill,
                                trackColor: CupertinoColors.systemTeal,
                                value: controller.settings.containsKey('view_time')
                                    ? controller.settings['view_time'] == true.toString()
                                    : false,
                                onChanged: (val) async {
                                    controller.settings['view_time'] = val.toString();
                                    await saveOption('view_time', val.toString());
                                },
                            ),
                            onTap: () {},
                        )),
                    ]
                ),
                onWillPop: () async {
                    return true;
                }
            )
        );
    }

}


//class Other extends StatelessWidget {
//    // You can ask Get to find a Controller that is being used by another page and redirect you to it.
//    final Controller c = Get.find();
//
//    @override
//    Widget build(context){
//        // Access the updated count variable
//        return Scaffold(body: Center(child: Text("${c.count}")));
//    }
//}