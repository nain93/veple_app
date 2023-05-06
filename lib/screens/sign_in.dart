import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:veple/utils/colors.dart';
import 'package:veple/utils/localization.dart';
import 'package:veple/utils/router_config.dart';
import 'package:veple/widgets/common/button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:go_router/go_router.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var t = localization(context);
    var loading = useState(false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 60, bottom: 8),
                child: Text(
                  t.appName,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 64),
                child: const Text(
                  '비디오 플레이',
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              Button(
                loading: loading.value,
                text: '카카오로 로그인하기',
                onPress: () async {
                  try {
                    loading.value = true;
                    OAuthToken token =
                        await UserApi.instance.loginWithKakaoAccount();
                    var provider = auth.OAuthProvider('oidc.kakao');
                    var credential = provider.credential(
                      idToken: token.idToken,
                      accessToken: token.accessToken,
                    );
                    auth.FirebaseAuth.instance.signInWithCredential(credential);
                    if (context.mounted) {
                      context.go(GoRoutes.home.fullPath);
                    }
                  } catch (error) {
                    print('카카오계정으로 로그인 실패 $error');
                  } finally {
                    loading.value = false;
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 56, bottom: 48),
                child: Column(
                  children: [
                    Text(localization(context).inquiry,
                        style: const TextStyle(fontSize: 12, color: grey)),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'rnrb555@gmail.com',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
