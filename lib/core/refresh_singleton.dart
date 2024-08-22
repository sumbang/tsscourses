class RefreshSingleton {

    static final RefreshSingleton _singleton = RefreshSingleton._internal();

    bool _refresh = false;

    get getRefresh => _refresh;

    void setRefresh(choix) {
      _refresh = choix;
    }

    factory RefreshSingleton() {
      return _singleton;
    }

    RefreshSingleton._internal();

}