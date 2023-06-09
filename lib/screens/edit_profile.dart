import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veple/utils/assets.dart';
import 'package:veple/utils/router_config.dart';
import 'package:veple/widgets/common/button.dart';
import 'package:veple/widgets/common/edit_text.dart';
import 'package:veple/widgets/common/image.dart';
import 'package:veple/widgets/model_theme.dart';

class EditProfileArguments {

  EditProfileArguments({this.title, this.person});
  final String? title;
  final String? person;
}

class EditProfile extends HookConsumerWidget {
  const EditProfile({super.key, this.title, this.person});
  final String? title;
  final String? person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = FirebaseAuth.instance.currentUser;
    var themeNotifier = ref.watch(modelProvider);

    var picker = ImagePicker();
    var nameValue = useState('');
    var descValue = useState('');
    var imageFile = useState<XFile?>(null);

    void pickPhoto(ImageSource source) async {
      var pickedFile = await picker.pickImage(source: source);
      imageFile.value = pickedFile;
    }

    return Scaffold(
      backgroundColor: themeNotifier.isDark
          ? const Color(0xFF1E1E1E)
          : const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor:
            themeNotifier.isDark ? Colors.black : const Color(0xFFEDEDED),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: themeNotifier.isDark
              ? Image(
                  width: 230,
                  height: 230,
                  image: Assets.dooboolabLogo,
                )
              : Image(
                  width: 230,
                  height: 230,
                  image: Assets.dooboolab,
                ),
        ),
        leadingWidth: 50,
        actions: [
          IconButton(
              icon: Icon(themeNotifier.isDark
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
              onPressed: () {
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              }),
          IconButton(
            color: Theme.of(context).iconTheme.color,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go(GoRoutes.signIn.fullPath);
              }
            },
            iconSize: 30,
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 36, 16, 36),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(4, 4),
                        blurRadius: 16)
                  ],
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          pickPhoto(ImageSource.gallery);
                        },
                        child: Stack(
                          children: [
                            imageFile.value == null
                                ? CircleAvatar(
                                    radius: 85,
                                    backgroundColor: themeNotifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    child: ImageOnNetwork(
                                        borderRadius: 85,
                                        width: 170,
                                        height: 170,
                                        imageURL: user?.photoURL ?? ''),
                                    // const Text(
                                    //   '사진 선택',
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w700),
                                    // ),
                                  )
                                : CircleAvatar(
                                    radius: 85,
                                    backgroundImage: FileImage(
                                      File(imageFile.value!.path),
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Container(
                                  // ignore: prefer_const_constructors
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 24, 0, 10),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )),
                    EditText(
                      onChanged: (txt) => nameValue.value = txt,
                      hintText: '${user?.displayName}',
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 24, 0, 10),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '자기소개',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )),
                    EditText(
                      onChanged: (txt) => descValue.value = txt,
                      hintText: '자기소개',
                    ),
                    Button(
                      text: 'Update',
                      onPress: () {},
                      disabled: nameValue.value == '' || descValue.value == '',
                    )
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
