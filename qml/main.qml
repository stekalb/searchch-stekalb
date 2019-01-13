import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "UCSComponents"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5

MainView {
  id:window
  //
  // ScreenSaver {
  //   id: screenSaver
  //   screenSaverEnabled: !(Qt.application.active)
  // }

  objectName: "mainView"
  theme.name: "Ubuntu.Components.Themes.SuruDark"
  backgroundColor: "transparent"
  applicationName: "searchch.ste-kal"

  property string myTabletUrl: "https://www.search.ch"
  property string myMobileUrl: "https://www.search.ch"
  property string myTabletUA: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/67.0.3396.99 Chrome/67.0.3396.99 Safari/537.36"
  property string myMobileUA: "Mozilla/5.0 (Linux; Android 8.0.0; Pixel Build/OPR3.170623.007) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36"

  property string myUrl: (Screen.devicePixelRatio == 1.625) ? myTabletUrl : myMobileUrl
  //property string myUrl: "http://www.tagesanzeiger.ch"
  property string myUA: (Screen.devicePixelRatio == 1.625 && Screen.pixelDensity != 5.838023276011812) ? myTabletUA : myMobileUA
  //"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/67.0.3396.99 Chrome/67.0.3396.99 Safari/537.36"
  WebEngineView {
    id: webview
    anchors {
      fill: parent
    }
    //settings.localStorageEnabled: true
    //settings.allowFileAccessFromFileUrls: true
    //settings.allowUniversalAccessFromFileUrls: true
    //settings.appCacheEnabled: true
    settings.javascriptCanAccessClipboard: true
    settings.fullScreenSupportEnabled: true
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      mainview.fullScreenRequested(request.toggleOn);
      nav.visible = !nav.visible
      request.accept();
    }
          property string test: writeToLog("DEBUG","my URL:", myUrl);
      property string test2: writeToLog("DEBUG","DevicePixelRatio:", Screen.devicePixelRatio);
      property string test3: writeToLog("DEBUG","PixelDensity:", Screen.pixelDensity);
      property string test4: writeToLog("DEBUG","Screen model:", Screen.model);
      property string test5: writeToLog("DEBUG","Screen manufacturer:", Screen.manufacturer);
    function writeToLog(mylevel,mytext, mymessage){
      console.log("["+mylevel+"]  "+mytext+" "+mymessage)
      return(true);
    }

    profile:  WebEngineProfile {
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath
      dataPath: dataLocation
      httpUserAgent: myUA
    }

    anchors {
      fill:parent
      centerIn: parent.verticalCenter
    }

    url: myUrl
    userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentCreation
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]
  }

  RadialBottomEdge {
    id: nav
    visible: true
    actions: [
      RadialAction {
        id: home
        iconName: "home"
        onTriggered: {
          webview.url = myUrl
        }
        text: qsTr("Home")
      },
      RadialAction {
        id: reload
        iconName: "reload"
        onTriggered: {
          webview.reload()
        }
        text: qsTr("Reload")
      },
      RadialAction {
        id: kino
        iconName: "stock_video"
        onTriggered: {
          webview.url = "https://kino.search.ch"
        }
        text: qsTr("Cinema")
      },
      RadialAction {
        id: tv
        iconName: "stock_video"
        iconSource: Qt.resolvedUrl("icons/tv.svg")
        onTriggered: {
          webview.url = "http://tv.search.ch"
        }
        text: qsTr("TV")
      },
      RadialAction {
        id: tel
        iconName: "call-start"
        iconSource: Qt.resolvedUrl("icons/search.svg")
        onTriggered: {
          webview.url = "http://tel.search.ch"
        }
        text: qsTr("Phone")
      },
      RadialAction {
        id: meteo
        iconName: "flash-on"
        iconSource: Qt.resolvedUrl("icons/weather.svg")

        onTriggered: {
          webview.url = "http://meteo.search.ch"
        }
        text: qsTr("Meteo")
      },
      RadialAction {
        id: map
        iconName: "location"
        onTriggered: {
          webview.url = "http://map.search.ch"
        }
        text: qsTr("Map")
      },
        RadialAction {
        id: timetable
        iconSource: Qt.resolvedUrl("icons/train.svg")
        onTriggered: {
          webview.url = "http://fahrplan.search.ch/"
        }
        text: qsTr("Timetable")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Back")
      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }
  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }
  Connections {
    target: window.webview
    onIsFullScreenChanged: window.setFullscreen(window.webview.isFullScreen)
  }

  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
        //window.currentWebview.fullscreen = false
        //window.currentWebview.fullscreen = false
      }
    }
  }
}
