import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../product_detail/product_detail_page.dart';

class ProductListSearchResult extends StatefulWidget {
  String searchKeyword;
  ProductListSearchResult({super.key, required this.searchKeyword});

  @override
  State<ProductListSearchResult> createState() => _ProductListSearchResultState();
}

class _ProductListSearchResultState extends State<ProductListSearchResult> {
  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1519420573924-65fcd45245f8?auto=format&fit=crop&q=80&w=1935&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591184510259-b6f1be3d7aff?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1472141521881-95d0e87e2e39?auto=format&fit=crop&q=80&w=2072&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1611945007935-925b09ddcf1b?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591184510259-b6f1be3d7aff?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591254460606-fab865bf82b8?auto=format&fit=crop&q=80&w=1932&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];
  List<String> textSuggestion = [];
  List<String> dummyTextDatabase = ["sambal","Kecap","saos","coca-cola", "meses", "shampo", "sabun"];
  int productIndex = 0;

  @override
  void initState() {
    super.initState();
    searchTextFieldFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextFieldFocusNode.removeListener(_onFocusChange);
    searchTextFieldFocusNode.dispose();
  }

  void _onFocusChange() {
    setState(() {
      debugPrint("Focus: ${searchTextFieldFocusNode.hasFocus.toString()}");
    });

  }


  @override
  Widget build(BuildContext context) {

    Widget searchBar(){
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            searchTextFieldFocusNode.hasFocus ? const SizedBox() :
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                ),
              ),
            ),
            Flexible(
              child: TextFormField(
                onChanged: (value){
                  setState(() {
                    print("search object: ${searchTextFieldController.text}");
                    textSuggestion.clear();
                    textSuggestion = dummyTextDatabase.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
                    print("isi listnya adalah $textSuggestion");

                  });
                },
                textInputAction: TextInputAction.search,
                controller: searchTextFieldController,
                cursorColor: backgroundColor1,
                focusNode: searchTextFieldFocusNode,
                onFieldSubmitted: (_){
                  print("object yang dicari adalah ${searchTextFieldController.text}");
                  if (searchTextFieldController.text.isNotEmpty){
                    Navigator.pushReplacement(context, PageTransition(child: ProductListSearchResult(searchKeyword: searchTextFieldController.text), type: PageTransitionType.fade));
                    setState(() {
                      searchTextFieldController.text = "";
                      searchTextFieldFocusNode.canRequestFocus = false;
                    });
                  }

                },
                decoration: InputDecoration(
                  hintText: "Cari Barang",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchTextFieldFocusNode.hasFocus ? backgroundColor1 : Colors.grey,
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundColor1, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget searchSuggestion({required List<String> text}){

      print("panjang text nya adalah: ${text.length}");
      return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(
          top: 20,
        ),
        child: searchTextFieldController.text == "" ? const SizedBox() : ListView(
          children: [
            for(var index=0; index<text.length; index++)
              InkWell(
                onTap: (){
                  print("clicked on ${text[index]}");
                  if (searchTextFieldController.text.isNotEmpty){
                    Navigator.pushReplacement(context, PageTransition(child: ProductListSearchResult(searchKeyword: text[index]), type: PageTransitionType.fade));
                    setState(() {
                      searchTextFieldController.text = "";
                      searchTextFieldFocusNode.canRequestFocus = false;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: backgroundColor1,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            text[index],
                            style: poppins.copyWith(
                              color: backgroundColor1,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.call_made,
                            color: backgroundColor1,
                          ),

                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: backgroundColor1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget horizontalListItem({bool isOnDiscountContent = false}){
      List<String> listImageData = [];
      for (var i = 0; i<20; i++){
        // var imageData = (imgList..shuffle()).first;
        // listImageData.add(imageData);
        productIndex = (productIndex + 1);
        if (productIndex == imgList.length - 1){
          productIndex = 0;
          listImageData.add(imgList[productIndex]);
        }else{
          listImageData.add(imgList[productIndex]);
        }
      }

      return SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          spacing: 10,
          children: [
            for (var i = 0; i<20; i++)
              InkWell(
                onTap: (){
                  print("ditekan untuk object foto: $i");
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductDetailPage(
                        imageURL: listImageData[i],
                        productLoct: "Cabang Malang Kota",
                        productName: "Lorem Ipsum dolor sit amet",
                        productPrice: "Rp 18.000,00",
                        productStar: "4.5",
                        beforeDiscountPrice: isOnDiscountContent ? "Rp 180.000,00" : null,
                        discountPercentage: isOnDiscountContent ? "50%" : null,
                        isDiscount: isOnDiscountContent,
                      ),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.sizeOf(context).width - 50)/2,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 4,
                        offset:  const Offset(0, 8), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          (listImageData[i]),
                          width: (MediaQuery.sizeOf(context).width - 50)/2,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Lorem Ipsum dolor sit amet",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: poppins.copyWith(
                                  color: backgroundColor1,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Rp 18.000,00",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: poppins.copyWith(
                                  color: backgroundColor1,
                                  fontWeight: medium,
                                ),
                              ),
                            ),

                            if(isOnDiscountContent == true)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Rp 180.000,00",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: poppins.copyWith(
                                            decoration: TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontSize: 10
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "50%",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: poppins.copyWith(
                                          color: Colors.red,
                                          fontSize: 10,
                                          fontWeight: bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: backgroundColor2,
                                ),
                                Text(
                                  "4.5",
                                  style: poppins.copyWith(
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: backgroundColor2,
                                ),
                                Expanded(
                                  child: Text(
                                    "Cab. Malang Kota",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: poppins.copyWith(
                                      color: backgroundColor2,
                                      fontWeight: medium,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchBar(),
              searchTextFieldFocusNode.hasFocus ? SizedBox() : Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Hasil Pencarian : ',
                    style: poppins.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.searchKeyword,
                        style: poppins.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                          color: backgroundColor3,
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: searchTextFieldFocusNode.hasFocus ? searchSuggestion(text: textSuggestion) : horizontalListItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
