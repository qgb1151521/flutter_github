import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../res/res.dart';
import '../../model/model.dart';
import '../../top_config.dart';
import 'package:dio/dio.dart';
import 'package:provide/provide.dart';
import '../../provide/provide.dart';
import '../../generated/i18n.dart';
/*
 * @Date: 2019-03-19 14:49 
 * @Description TODO
 */

class UsersDetailPage extends StatefulWidget {
  final String _url;

  UsersDetailPage(this._url);

  @override
  _UsersDetailPageState createState() => _UsersDetailPageState();
}

class _UsersDetailPageState extends State<UsersDetailPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    gitHubProvide.setTopBgHeight(0);
    _scrollController.addListener(() {
      gitHubProvide.setTopBgHeight((_scrollController.position.pixels < 0
              ? _scrollController.position.pixels
              : 1)
          .abs()
          .toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Response response = snapshot.data;
            UserEntity entity = UserEntity.fromJson(response.data);
            return Stack(
              children: <Widget>[
                Provide<GitHubProvide>(builder: (context, child, provide) {
                  return Container(
                    height: dimen200 + provide.topBgHeight,
                    color: primaryColor,
                  );
                }),
                SafeArea(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          _header(entity),
                          _child(entity),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: gitHubProvide.url(widget._url),
      ),
    );
  }

  _header(UserEntity userEntity) {
    return Container(
      padding: EdgeInsets.only(left: dimen15, top: dimen5, right: dimen15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: dimen80,
            width: dimen80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimen80),
              image: DecorationImage(
                image: NetworkImage(userEntity.avatarUrl ?? avatarUrl),
              ),
            ),
          ),
          SizedBox(
            height: dimen10,
          ),
          Text(
            userEntity.login ?? '',
            style: TextStyle(
              color: containerColor,
              fontSize: dimen14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: dimen10,
          ),
          Text(
            userEntity.name ?? '',
            style: TextStyle(
              color: containerColor,
              fontSize: dimen14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: dimen10,
          ),
          Card(
            color: containerColor,
            child: Container(
              alignment: AlignmentDirectional.center,
              height: dimen80,
              child: InkWell(
                child: Container(
                  height: dimen50,
                  child: Row(
                    children: <Widget>[
                      _countItem(userEntity.publicRepos.toString(),
                          S.of(context).repositories),
                      _countItem(userEntity.followers.toString(),
                          S.of(context).followers),
                      _countItem(userEntity.following.toString(),
                          S.of(context).following),
                    ],
                  ),
                ),
                onTap: () {
                  UserReposEntity userRepos = UserReposEntity();
                  userRepos.name = userEntity.name;
                  userRepos.login = userEntity.login;
                  userRepos.reposUrl = userEntity.reposUrl;
                  userRepos.starredUrl = userEntity.starredUrl;
                  userRepos.followersUrl = userEntity.followersUrl;
                  userRepos.followingUrl = userEntity.followingUrl;
                  userRepos.subscriptionsUrl = userEntity.subscriptionsUrl;
                  gitHubProvide.setUserReposEntity(userRepos);
                  Navigator.pushNamed(context, '/repos');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _child(UserEntity entity) {
    return Container(
      padding: EdgeInsets.only(left: dimen15, top: dimen5, right: dimen15),
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              _item(
                Icons.account_balance,
                'Company',
                entity.company,
              ),
              _item(
                Icons.location_on,
                'City',
                entity.location,
              ),
              _item(
                Icons.email,
                'Email',
                entity.email,
              ),
              InkWell(
                child: _item(
                  Icons.http,
                  'Blog',
                  entity.blog,
                ),
                onTap: () {
                  launchURL(entity.blog);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _item(IconData icon, String title, String remark) {
    return Container(
      padding: EdgeInsets.only(
          top: dimen15, left: dimen20, right: dimen20, bottom: dimen15),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: primaryColor,
            size: dimen20,
          ),
          SizedBox(
            width: dimen15,
          ),
          Text(
            title ?? "UnKnown",
            style: TextStyle(color: title == null ? Colors.grey : Colors.black),
          ),
          Expanded(
            child: Text(
              remark ?? '',
              textAlign: TextAlign.right,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _countItem(String count, title) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(count,
              style: TextStyle(
                color: primaryColor,
                fontSize: dimen15,
              )),
          SizedBox(height: dimen10,),
          Text(title,
              style: TextStyle(
                fontSize: dimen12,
              )),
        ],
      ),
      flex: 1,
    );
  }
}
