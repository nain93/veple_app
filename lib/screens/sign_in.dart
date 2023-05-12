import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:veple/utils/colors.dart';
import 'package:veple/utils/localization.dart';
import 'package:veple/utils/router_config.dart';
import 'package:veple/widgets/common/button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:veple/widgets/common/snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var t = localization(context);
    var kakaoLoading = useState(false);
    var googleLoading = useState(false);
    var appleLoading = useState(false);

    Future<void> handleKakaoLogin() async {
      try {
        kakaoLoading.value = true;

        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
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
        snackbar.alert(context, '로그인 실패');
      } finally {
        kakaoLoading.value = false;
      }
    }

    Future<void> handleGoogleLogin() async {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          // 'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      try {
        googleLoading.value = true;
        var googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          var googleSignInAuthentication =
              await googleSignInAccount.authentication;

          var credential = auth.GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          auth.FirebaseAuth.instance.signInWithCredential(credential);
          if (context.mounted) {
            context.go(GoRoutes.home.fullPath);
          }
        }
      } catch (error) {
        snackbar.alert(context, '로그인 실패');
      } finally {
        googleLoading.value = false;
      }
    }

    Future<void> handleNaverLogin() async {
      // todo
    }

    Future<void> handleAppleLogin() async {
      // todo
    }

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
                loading: kakaoLoading.value,
                text: '카카오로 로그인하기',
                onPress: handleKakaoLogin,
              ),
              const SizedBox(height: 10),
              Button(
                loading: googleLoading.value,
                text: '구글로 로그인하기',
                onPress: handleGoogleLogin,
              ),
              const SizedBox(height: 10),
              Button(
                loading: kakaoLoading.value,
                text: '네이버로 로그인하기',
                onPress: handleNaverLogin,
              ),
              const SizedBox(height: 10),
              Button(
                loading: appleLoading.value,
                text: '애플로 로그인하기',
                onPress: handleAppleLogin,
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
