
function getLines(namelistModel){
    namelistModel.clear()
    var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
    db.transaction(
                function(tx){
                    var query = 'SELECT * FROM lines ORDER BY category ASC, code ASC'
                    var r1 = tx.executeSql(query)
                    var category = ''
                    for(var i = 0; i < r1.rows.length; i++){
                        switch (r1.rows.item(i).category){
                        case 'Red Diurna Convencional':
                            category = qsTr("DIURNAS");
                            break;
                        case 'Red Universitaria':
                            category = qsTr("UNIVERSITARIAS");
                            break;
                        case 'Líneas Aeropuerto':
                            category = qsTr("LINEAS AEROPUERTO");
                            break;
                        case 'Red Nocturna':
                            category = qsTr("NOCTURNAS(BUHOS)");
                            break;
                        default:
                            category = qsTr("OTROS");
                        }
                        namelistModel.append({"lineName": r1.rows.item(i).name,
                                                 "lineNumber": r1.rows.item(i).label,
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
    var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
    var section_names = []
    var node_list = []
    var output = []
    db.transaction(
                function(tx){
                    var query = 'SELECT name, label, color, head_name, head_number, tail_name, tail_number FROM lines WHERE code=?'
                    var r1 = tx.executeSql(query,[line])
                    output = [r1.rows.item(0).name, r1.rows.item(0).label, r1.rows.item(0).color]
//--                    lineLabel.text = r1.rows.item(0).label;
                    lineName.text = r1.rows.item(0).name;
                    lineIcon.border.color = r1.rows.item(0).color;
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

function addUsual(code,name){
 console.log("Adding "+code+" to usual stops")
 var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
 db.transaction(
   function(tx){
       var r1 = tx.executeSql('INSERT INTO usual_nodes VALUES (NULL,?,?,NULL)',[code,"->"+name])
   }
   )
 isUsual(code);
 }
 function isUsual(code){
 var db = LocalStorage.openDatabaseSync("bustopsevillaDB","1.0","Internal data for hitmemap! app.",1000000)
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
