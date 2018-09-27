import 'package:flutter_svg/svg.dart';
import 'package:nocker/data/model/EosNode.dart';
import 'package:nocker/ui/CommonWidget.dart';
import 'package:nocker/ui/presenter/MainPresenter.dart';
import 'package:nocker/ui/widget/DetailWidget.dart';
import 'package:nocker/util/Constants.dart';
import 'package:nocker/util/locale/DefaultLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainWidget extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<MainWidget> {
  MainPresenter presenter = MainPresenter();
  DefaultLocalizations localizations;
  List<EosNode> nodes = <EosNode>[];

  @override
  void initState() {
    super.initState();
    presenter.init();
    presenter.subject.stream.listen((list) {
      setState(() {
        nodes = list;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (localizations == null) {
      localizations = DefaultLocalizations.of(context);
    }

    return Scaffold(
      appBar: null,
      body: buildMain(),
    );
  }

  Widget buildMain() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: backgroundColor,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: statusBarHeight + headerHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: statusBarHeight),
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 128.0,
                  child: SvgPicture.asset('assets/nocker-title.svg'),
                ),
                CommonWidget.getTextContainer(
                    'Made by eosyskoreabp',
                    margin: EdgeInsets.only(top: 3.0),
                    textColor: Colors.white
                ),
              ],
            ),
          ),
          Container(
              child: ListView.builder(
                padding: EdgeInsets.only(top: statusBarHeight + headerHeight + mainWidgetMargin, bottom: mainListItemMargin),
                itemCount: nodes.length,
                itemBuilder: (context, i) => buildListTile(nodes[i]),
              )
          )
        ],
      ),
    );
  }

  Widget buildListTile(EosNode node) {
    String number = node.number > 0 ? node.number.toString() : '';
    String time = '';
    if (node != null && node.time != null) {
      time = DateFormat('yyyyMMdd HH:mm:ss').format(node.time.toLocal());
    }

    Color textColor;
    Widget image;
    if (node.isError()) {
      textColor = errorColor;
      image = SvgPicture.asset('assets/img-red.svg');
    } else if (0 < node.number && node.number < presenter.maxHeight - warningOffset) {
      textColor = warningColor;
      image = SvgPicture.asset('assets/img-yellow.svg');
    } else {
      textColor = Colors.black;
      image = SvgPicture.asset('assets/img-blue.svg');
    }

    return GestureDetector(
      onTap: () { onItemClicked(node); },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(itemBorderRadius)),
        ),
        margin: EdgeInsets.only(left: mainWidgetMargin, right: mainWidgetMargin, bottom: mainListItemMargin),
        padding: EdgeInsets.only(left: itemHorizontalPadding, top: itemVerticalPadding, right: itemHorizontalPadding, bottom: itemVerticalPadding),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CommonWidget.getTextContainer(
                    node.rank.toString(),
                    width: 28.0,
                    textColor: textColor,
                    fontSize: listItemTitleSize,
                ),
                Expanded(
                  child: CommonWidget.getTextContainer(
                    node.title,
                    margin: EdgeInsets.only(left: 8.0),
                    textAlign: TextAlign.left,
                    textColor: textColor,
                    fontSize: listItemTitleSize,
                    isBold: true,
                  ),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  child: image,
                )
              ],
            ),
            buildListItemRow(localizations.time, time),
            buildListItemRow(localizations.block, number),
          ],
        ),
      ),
    );
  }

  Widget buildListItemRow(String title, String content) {
    return Container(
      margin: EdgeInsets.only(top: mainListItemMargin),
      child: Row(
        children: <Widget>[
          CommonWidget.getTextContainer(
              title,
              isBold: true
          ),
          Expanded(
              child: CommonWidget.getText(
                  content,
                  textAlign: TextAlign.right,
                  color: grayTextColor,
              )
          ),
        ],
      ),
    );
  }

  void onItemClicked(EosNode node) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailWidget(presenter, node.title),
      )
    );
  }
}