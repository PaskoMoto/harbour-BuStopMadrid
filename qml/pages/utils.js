function populateStopData(mylist, stop_code) {
    console.log("mylist "+ mylist)
    isUsual(stop_code);
    if (mylist){
        var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
        var raw_line_codes = ""
        var section_names = {}
        var line_colors = {}
        db.transaction(
                    function(tx){
                        var query = 'SELECT name, line_codes FROM nodes WHERE code=?'
                        var r1 = tx.executeSql(query,[stop_code])
                        subHeader.text = r1.rows.item(0).name
                        raw_line_codes = r1.rows.item(0).line_codes
                    }
                    )
        db.transaction(
                    function(tx){
                        var tmp_line_codes = raw_line_codes.replace(/:/g," ")
                        var line_codes = tmp_line_codes.trim().split(" ")
                        for (var i = 0; i < line_codes.length; i++){
                            var line = line_codes[i].split(".")[0]
                            var section = line_codes[i].split(".")[1]
                            var query = 'SELECT label, color, head_name, head_number, tail_name, tail_number FROM lines WHERE code=? AND (head_number=? OR tail_number=?)'
                            var r1 = tx.executeSql(query,[line, section, section])
                            for (var j = 0; j < r1.rows.length; j++){
                                line_colors[r1.rows.item(j).label] = r1.rows.item(j).color
                                if (r1.rows.item(j).head_number - section === 0 ){
                                    section_names[r1.rows.item(j).label] = r1.rows.item(j).head_name
                                }
                                else{
                                    section_names[r1.rows.item(j).label] = r1.rows.item(j).tail_name
                                }
                            }
                        }
                    }
                    )
        for(var i = 0; i < mylist.length; i++){
           if (mylist[i][0] === "XX"){
               section_names[String(mylist[i][0])] = "NO SERVICE"
           }
        }
        for(var i = 0; i < mylist.length; i++){
            stopDataModel.append({
                                     "line": mylist[i][0],
                                     "first_bus_time": mylist[i][1],
                                     "first_bus_distance": mylist[i][2],
                                     "second_bus_time": mylist[i][3],
                                     "second_bus_distance": mylist[i][4],
                                     "section_name": section_names[String(mylist[i][0])],
                                     "line_color": line_colors[String(mylist[i][0])]
                                 })
        }
        var now = new Date()
        lastRefresh.text = now.getHours()+":"+('0'+now.getMinutes()).slice(-2)
    }
}

function getLines(namelistModel){
    namelistModel.clear()
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var query = 'SELECT * FROM lines ORDER BY category ASC, code ASC'
                    var r1 = tx.executeSql(query)
                    var category = ''
                    for(var i = 0; i < r1.rows.length; i++){
                        switch (r1.rows.item(i).category){
                        case 'Red Diurna Convencional':
                            category = qsTr("Red Diurna");
                            break;
                        case 'Red Universitaria':
                            category = qsTr("Red Universitaria");
                            break;
                        case 'Líneas Aeropuerto':
                            category = qsTr("Aeropuerto");
                            break;
                        case 'Red Nocturna':
                            category = qsTr("Red Nocturna");
                            break;
                        default:
                            category = qsTr("Other");
                        }
                        namelistModel.append({"lineNumber": r1.rows.item(i).label,
                                                 "lineName": r1.rows.item(i).name,
                                                 "lineColor": r1.rows.item(i).color,
                                                 "lineType": category,
                                                 "code": r1.rows.item(i).code
                                             })
                    }
                }
                )
}

function getStopsData(line, stopsListModel){
    stopsListModel.clear()
    console.log("Asking stops for line "+line)
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    var section_names = []
    var node_list = []
    var output = []
    db.transaction(
                function(tx){
                    var query = 'SELECT name, label, color, head_name,head_number, tail_name, tail_number FROM lines WHERE code=?'
                    var r1 = tx.executeSql(query,[line])
                    output = [r1.rows.item(0).name, r1.rows.item(0).label, r1.rows.item(0).color]
//                    lineName.text = r1.rows.item(0).name;
//                    lineLabel.text = r1.rows.item(0).label;
//                    lineIcon.border.color = r1.rows.item(0).color;
                    section_names[0] = [r1.rows.item(0).head_number,r1.rows.item(0).head_name];
                    section_names[1] = [r1.rows.item(0).tail_number,r1.rows.item(0).tail_name];
                }
                )
    db.transaction(
                function(tx){
                    var query = 'SELECT section, nodes FROM line_nodes WHERE line_code=? ORDER BY section'
                    var r1 = tx.executeSql(query,[line])
                    for(var i = 0; i < r1.rows.length; i++){
                        var nodes = r1.rows.item(i).nodes.replace(/:/g," ")
                        node_list[i] = [r1.rows.item(i).section, nodes.trim().split(" ")]
                    }
                }
                )
    db.transaction(
                function(tx){
                    for (var j = 0; j < node_list.length; j++){
                        var nodes = node_list[j][1]
                        var section = node_list[j][0]
                        var section_name = ''
                        for (var n = 0; n < section_names.length; n++){
                            if (section_names[n][0] === section){
                                section_name = section_names[n][1]
                            }
                        }

                        for (var m = 0; m < nodes.length; m++){
                            var r1 = tx.executeSql("SELECT * FROM nodes WHERE code=?", [nodes[m]])
                            stopsListModel.append({"stopNumber": nodes[m],
                                                      "stopName": r1.rows.item(0).name,
                                                      "stopSection": section_name,
                                                      "latitude": r1.rows.item(0).latitude,
                                                      "longitude": r1.rows.item(0).longitude
                                                  })
                        }
                    }
                }
                )
    return output
}

function pushAskButton(code){
    pythonMain.ask(code);
    pageStack.replace("StopPage.qml", {current_stop: code})
}

function isUsual(code){
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
      function(tx){
          var r1 = tx.executeSql('SELECT id FROM usual_nodes WHERE code=?',[code])
          if (r1.rows.length > 0){
              favIcon.visible = true
              console.log("Stop "+code+" is a usual stops")
          }
          else{
              favIcon.visible = false
              console.log("Stop "+code+" is not a usual stops")
          }
      }
      )
}

function addUsual(code,name){
    console.log("Adding "+code+" to usual stops")
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
      function(tx){
          var r1 = tx.executeSql('INSERT INTO usual_nodes VALUES (NULL,?,?,NULL)',[code,"->"+name])
      }
      )
    isUsual(code);
}

function removeUsual(id){
    console.log("Removing "+id+" from usual stops")
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var r1 = tx.executeSql('DELETE FROM usual_nodes WHERE id=?',[id])
                }
                )
    getUsualStopsData();
}

function removeUsualStop(code){
    console.log("Removing "+code+" from usual stops")
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var r1 = tx.executeSql('DELETE FROM usual_nodes WHERE code=?',[code])
                }
                )
    isUsual(code);
}

function getUsualStopsData(){
    stopDataModel.clear();
    console.log("Asking usual stops")
    var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var r1 = tx.executeSql('SELECT code FROM usual_nodes')
                    for(var i = 0; i < r1.rows.length; i++){
                        var code = r1.rows.item(i).code
                        var query = 'SELECT usual_nodes.custom_label, usual_nodes.id, nodes.name FROM usual_nodes, nodes WHERE usual_nodes.code=? and nodes.code=?'
                        var r2 = tx.executeSql(query,[code,code])
                        console.log("Adding id: "+r2.rows.item(0).id)
                        stopDataModel.append({
                                                 "code": String(code),
                                                 "name": r2.rows.item(0).name,
                                                 "custom_label": r2.rows.item(0).custom_label,
                                                 "entry_id": r2.rows.item(0).id
//                                                     "number_of_links": links.length,
//                                                     "links": links
                                             })
                        console.log("Names: "+r2.rows.item(0).name)
                        console.log("Custom label: "+r2.rows.item(0).custom_label)
                    }
                }
                )
}
