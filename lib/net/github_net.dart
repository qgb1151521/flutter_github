import 'package:rxdart/rxdart.dart';
import '../util/net_util.dart';
import 'package:dio/dio.dart';

/*
 * @TIME 2019-03-14 22:40
 * @DES  TODO
 */

const client_id = '1cb27874fc405af5d2e5';
const client_secret = '0e11c6aa68de8a5deef663bc815f5bf6099687f5';

class GitHubNet {

  Observable<dynamic> login() => postLoginJson('authorizations', params: {
        'client_id': client_id,
        'client_secret': client_secret,
        'scopes': ['user', 'repo', 'notifications'],
      });

  Observable<dynamic> user(String accessToken) =>
      get('user', params: {'access_token': accessToken});

  Observable<dynamic> stared(int type, String fullName) {
    return activity(type, 'user/starred/$fullName');
  }

  Observable<dynamic> watched(int type,String fullName) {
    return activity(type, 'user/subscriptions/$fullName');
  }

  Future<Response> star(String login, int page,
      {String owner, repo, int size}) async {
    Response response = await futureGet(
        'users/$login/starred${owner == null ? '' : '/$owner/$repo'}',
        params: {
          'client_id': client_id,
          'client_secret': client_secret,
          'page': page,
          'size': size ?? 15,
          'sort': 'created',
          'direction': 'desc',
        });
    return response;
  }

  Future trend(String language, since) async {
    return await getNoGitApi('https://github-trending-api.now.sh/repositories',
        params: {
          'language': language,
          'since': since,
        });
  }

  Future languages() async {
    return await getNoGitApi('https://github-trending-api.now.sh/languages');
  }

  Future search(int type, String q, {String sort, String order, String language}) async {
    return await futureGet(type == 0 ? 'search/repositories' : 'search/users', params: {
      'q':q + (language != null && language.isNotEmpty ? '+language:'+language : ''),
      'sort': sort ?? 'best match',
      'order': order ?? 'desc',
    });
  }
  
  Future repos(String fullName) async {
    return await futureGet('repos/$fullName', params: {
      'client_id': client_id,
      'client_secret': client_secret,
    });
  }

  Future url(String url, int page) async {
    return await getUrl(url, params: {
      'client_id': client_id,
      'client_secret': client_secret,
      'page': page,
      'size': 20,
    });
  }

  Future trees(String fullName, String branch) async {
    return await futureGet('repos/$fullName/git/trees/$branch', params: {
      'client_id': client_id,
      'client_secret': client_secret,
    });
  }

  Future tree(String url) async {
    return await getNoGitApi(url, params: {
      'client_id': client_id,
      'client_secret': client_secret,
    });
  }

  Future readme(String url) async {
    return await getNoGitApi(url);
  }
}
