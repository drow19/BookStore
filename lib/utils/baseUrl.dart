
String ip = "http://192.168.1.11/bookstore/public";

class BaseUrl{

  static URL(){
    return ip + "/login";
  }

  static ListBook(){
    return ip + "/book?page=";
  }

  static SearchBook(){
    return ip + "/book/search/";
  }

  static PostData(){
    return ip + "/transaction";
  }

  static History(){
    return ip + "/transaction_list/";
  }

  static DetailTrans(){
    return ip + "/transaction_detail/";
  }

  static String baseUrl = ip;
}