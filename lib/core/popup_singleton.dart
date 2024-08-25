class PopupSingleton {

    static final PopupSingleton _singleton = PopupSingleton._internal();

    int page = 0;

    get getPage => page;

    void setPage(choix1) {
      page = choix1;
    }

    factory PopupSingleton() {
      return _singleton;
    }

    PopupSingleton._internal();

}