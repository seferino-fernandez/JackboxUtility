import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/pages/patcher/packPatch.dart';

class PatchCategory {
  String id;
  String name;
  String smallDescription;
  List<UserJackboxPackPatch> packPatches;
  List<UserJackboxGamePatch> gamePatches;

  PatchCategory(
      {required this.id,
      required this.name,
      required this.smallDescription,
      required this.packPatches,
      required this.gamePatches});

  factory PatchCategory.fromJson(
      Map<String, dynamic> json, List<UserJackboxPack> packs) {
    List<String> patchsIncluded = json["patchs"];
    List<UserJackboxPackPatch> packPatches = [];
    List<UserJackboxGamePatch> gamePatches = [];
    for (String patchId in patchsIncluded) {
      for (UserJackboxPack pack in packs) {
        for (UserJackboxPackPatch packPatch in pack.patches) {
          if (packPatch.patch.id == patchId) {
            packPatches.add(packPatch);
          }
        }
        for (UserJackboxGame game in pack.games) {
          for (UserJackboxGamePatch gamePatch in game.patches) {
            if (gamePatch.patch.id == patchId) {
              gamePatches.add(gamePatch);
            }
          }
        }
      }
    }

    return PatchCategory(
        id: json['id'],
        name: json['name'],
        smallDescription: json['smallDescription'],
        packPatches: packPatches,
        gamePatches: gamePatches);
  }

  UserInstalledPatchStatus getInstalledStatus(){
    UserInstalledPatchStatus status = UserInstalledPatchStatus.INSTALLED;
    for(UserJackboxPackPatch packPatch in packPatches){
      if(packPatch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED){
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
    }
    for(UserJackboxGamePatch gamePatch in gamePatches){
      if(gamePatch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED){
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
    }
    return status;
  }

  List<PackAvailablePatchs> getAvailablePatchs(){
    List<PackAvailablePatchs> availablePatchs = [];
    for (UserJackboxPackPatch packPatch in packPatches){
      UserJackboxPack pack = packPatch.getPack();
      if (availablePatchs.where((element) => element.pack.pack.id == pack.pack.id).isEmpty){
        availablePatchs.add(PackAvailablePatchs(pack: pack, packPatchs: [], gamePatchs: []));
      }
      PackAvailablePatchs packAvailablePatchs = availablePatchs.firstWhere((element) => element.pack.pack.id == pack.pack.id);
      packAvailablePatchs.packPatchs.add(packPatch);
    }
    for (UserJackboxGamePatch gamePatch in gamePatches){
      UserJackboxPack pack = gamePatch.getPack();
      if (availablePatchs.where((element) => element.pack.pack.id == pack.pack.id).isEmpty){
        availablePatchs.add(PackAvailablePatchs(pack: pack, packPatchs: [], gamePatchs: []));
      }
      PackAvailablePatchs packAvailablePatchs = availablePatchs.firstWhere((element) => element.pack.pack.id == pack.pack.id);
      packAvailablePatchs.gamePatchs.add(gamePatch);
    }
    return availablePatchs;
  }
}

class PackAvailablePatchs {
  UserJackboxPack pack;
  List<UserJackboxPackPatch> packPatchs;
  List<UserJackboxGamePatch> gamePatchs;

  PackAvailablePatchs({required this.pack, required this.packPatchs, required this.gamePatchs});
}
