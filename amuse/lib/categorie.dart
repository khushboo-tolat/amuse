import 'dart:collection';

class Category
{
  Category(String s,List<String> list){
    this.mainCat=s;
    subCat = list;
  }
  String mainCat;
  List<String> subCat;
}
class ListCategories
{
  ListCategories()
  {
    list = new HashMap<String,Category>();
  }
  HashMap<String,Category> list;

//  addCategorie(String str)
//  {
//    list.add(new Categorie(str));
//  }
//  int getCategorieIndex(String str)
//  {
//    for(Categorie c in list)
//    {
//      if(c.mainCat== str)
//        return list.indexOf(c);
//    }
//  }

}
