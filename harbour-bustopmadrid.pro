# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-bustopsevilla

CONFIG += sailfishapp

SOURCES += \
    src/harbour-bustopsevilla.cpp

OTHER_FILES += qml/harbour-bustopsevilla.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-bustopsevilla.spec \
    rpm/harbour-bustopsevilla.yaml \
    translations/*.ts
    db/data.db

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/harbour-bustopsevilla-es.ts

database.files = db
database.path = /usr/share/$${TARGET}

INSTALLS += database

DISTFILES += \
    qml/pages/suds/bindings/__init__.py \
    qml/pages/suds/bindings/binding.py \
    qml/pages/suds/bindings/document.py \
    qml/pages/suds/bindings/multiref.py \
    qml/pages/suds/bindings/rpc.py \
    qml/pages/suds/mx/__init__.py \
    qml/pages/suds/mx/appender.py \
    qml/pages/suds/mx/basic.py \
    qml/pages/suds/mx/core.py \
    qml/pages/suds/mx/encoded.py \
    qml/pages/suds/mx/literal.py \
    qml/pages/suds/mx/typer.py \
    qml/pages/suds/sax/__init__.py \
    qml/pages/suds/sax/attribute.py \
    qml/pages/suds/sax/date.py \
    qml/pages/suds/sax/document.py \
    qml/pages/suds/sax/element.py \
    qml/pages/suds/sax/enc.py \
    qml/pages/suds/sax/parser.py \
    qml/pages/suds/sax/text.py \
    qml/pages/suds/transport/__init__.py \
    qml/pages/suds/transport/http.py \
    qml/pages/suds/transport/https.py \
    qml/pages/suds/transport/options.py \
    qml/pages/suds/umx/__init__.py \
    qml/pages/suds/umx/attrlist.py \
    qml/pages/suds/umx/basic.py \
    qml/pages/suds/umx/core.py \
    qml/pages/suds/umx/encoded.py \
    qml/pages/suds/umx/typed.py \
    qml/pages/suds/xsd/__init__.py \
    qml/pages/suds/xsd/deplist.py \
    qml/pages/suds/xsd/doctor.py \
    qml/pages/suds/xsd/query.py \
    qml/pages/suds/xsd/schema.py \
    qml/pages/suds/xsd/sxbase.py \
    qml/pages/suds/xsd/sxbasic.py \
    qml/pages/suds/xsd/sxbuiltin.py \
    qml/pages/suds/__init__.py \
    qml/pages/suds/argparser.py \
    qml/pages/suds/builder.py \
    qml/pages/suds/cache.py \
    qml/pages/suds/client.py \
    qml/pages/suds/metrics.py \
    qml/pages/suds/options.py \
    qml/pages/suds/plugin.py \
    qml/pages/suds/properties.py \
    qml/pages/suds/reader.py \
    qml/pages/suds/resolver.py \
    qml/pages/suds/servicedefinition.py \
    qml/pages/suds/serviceproxy.py \
    qml/pages/suds/soaparray.py \
    qml/pages/suds/store.py \
    qml/pages/suds/sudsobject.py \
    qml/pages/suds/version.py \
    qml/pages/suds/wsdl.py \
    qml/pages/suds/wsse.py \
    qml/pages/LinesPage.qml \
    qml/pages/StopsPage.qml \
    qml/pages/About.qml \
    qml/pages/FrontPage.qml \
    qml/pages/TBDPage.qml \
    qml/pages/StopPage.qml \
    qml/pages/BSCodePage.qml \
    qml/api.py \
    icons/108x108/harbour-BuStopSevilla.png \
    icons/128x128/harbour-BuStopSevilla.png \
    icons/256x256/harbour-BuStopSevilla.png \
    icons/86x86/harbour-BuStopSevilla.png \
    qml/suds/bindings/__init__.py \
    qml/suds/bindings/binding.py \
    qml/suds/bindings/document.py \
    qml/suds/bindings/multiref.py \
    qml/suds/bindings/rpc.py \
    qml/suds/mx/__init__.py \
    qml/suds/mx/appender.py \
    qml/suds/mx/basic.py \
    qml/suds/mx/core.py \
    qml/suds/mx/encoded.py \
    qml/suds/mx/literal.py \
    qml/suds/mx/typer.py \
    qml/suds/sax/__init__.py \
    qml/suds/sax/attribute.py \
    qml/suds/sax/date.py \
    qml/suds/sax/document.py \
    qml/suds/sax/element.py \
    qml/suds/sax/enc.py \
    qml/suds/sax/parser.py \
    qml/suds/sax/text.py \
    qml/suds/transport/__init__.py \
    qml/suds/transport/http.py \
    qml/suds/transport/https.py \
    qml/suds/transport/options.py \
    qml/suds/umx/__init__.py \
    qml/suds/umx/attrlist.py \
    qml/suds/umx/basic.py \
    qml/suds/umx/core.py \
    qml/suds/umx/encoded.py \
    qml/suds/umx/typed.py \
    qml/suds/xsd/__init__.py \
    qml/suds/xsd/deplist.py \
    qml/suds/xsd/doctor.py \
    qml/suds/xsd/query.py \
    qml/suds/xsd/schema.py \
    qml/suds/xsd/sxbase.py \
    qml/suds/xsd/sxbasic.py \
    qml/suds/xsd/sxbuiltin.py \
    qml/suds/__init__.py \
    qml/suds/argparser.py \
    qml/suds/builder.py \
    qml/suds/cache.py \
    qml/suds/client.py \
    qml/suds/metrics.py \
    qml/suds/options.py \
    qml/suds/plugin.py \
    qml/suds/properties.py \
    qml/suds/reader.py \
    qml/suds/resolver.py \
    qml/suds/servicedefinition.py \
    qml/suds/serviceproxy.py \
    qml/suds/soaparray.py \
    qml/suds/store.py \
    qml/suds/sudsobject.py \
    qml/suds/version.py \
    qml/suds/wsdl.py \
    qml/suds/wsse.py \
    harbour-bustopsevilla.desktop \
    harbour-bustopsevilla.pro.user \
    harbour-bustopsevilla.pro.user.edb680b \
    qml/cover/CoverStopPage.qml \
    qml/utils.py \
    db/data.db \
    qml/pages/UsualStopsPage.qml \
    rpm/harbour-bustopsevilla.changes \
    qml/pages/StopsMap.qml \
    qml/pages/Settings.qml

RESOURCES += \
    resources.qrc
