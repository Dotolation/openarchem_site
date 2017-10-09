


function AddCompoundFields() {

  var date = new Date();

  var mSec = date.getTime();

  var tr = document.createElement("tr");
  var c_td = document.createElement("td");
  var pl_td = document.createElement("td");
  var pr_td = document.createElement("td");  

  var c_res = document.createElement("div");
    c_res.setAttribute("id", "diagnostic_results" + mSec);
    c_res.setAttribute("class", "results");

  var diag_comp = document.createElement("INPUT");
    diag_comp.setAttribute("type", "text");
    diag_comp.setAttribute("id", "diagnostic_compound" + mSec);
    diag_comp.setAttribute("name", "diagnostic_compound" + mSec);
    diag_comp.setAttribute("autofocus", "autofocus");
    c_td.appendChild(diag_comp).after(c_res);
    

  var plant = document.createElement("select");
    plant.setAttribute("id", "proposed_source" + mSec);
    plant.setAttribute("name", "proposed_source" + mSec);
    pl_td.appendChild(plant);

  var prod = document.createElement("INPUT");
    prod.setAttribute("type", "text");
    prod.setAttribute("id", "probable_ingredient" + mSec);
    prod.setAttribute("name", "probable_ingredient" + mSec);
    pr_td.appendChild(prod);

    tr.appendChild(c_td);
    tr.appendChild(pl_td);
    tr.appendChild(pr_td);

    document.getElementById("comp_table").appendChild(tr);
    comps($('#' + diag_comp.id), $('#' + c_res.id));
    
};


function comps(field, result) {
    field.autocomplete({
      source: 'samples',
      appendTo: result,
      open: function (event, ui) { 
        var url = "<a href='javascript:void();' data-toggle='modal' data-target='#add_compound'>Add a new Compound</a>"; 
        $("ul.ui-autocomplete.ui-menu").append(url); 
      },
      select: function(event, ui) {
        field.val(ui.item.name);
        populate_plants(field, ui.item.oa_id); 
        return false;
      }
    })
    .autocomplete( "instance" )._renderItem = function(ul, item) {
      var markup = [
        '<span class="formula">' + item.formula + '</span>',
        '<span class="name">' + item.name + '</span>'
      ];
      return $('<li>')
        .append(markup.join(''))
        .appendTo(ul);
      }
  };

  function populate_plants(field, comp_id){
    var msec_regex = /\d+$/;
    var arr = msec_regex.exec(field[0].id);
    
    if (arr == null){
      msec_num = ""
    } else {
      msec_num = arr[0]
    };

    var select = "#proposed_source" + msec_num;

    $.get('/populate-plants', {comp_id: comp_id})
      .done(function(data) {
        if ($(select)[0].options.length > 0){
          $(select).empty();
        };
        $.each(data,function(i, plant){
          $(select).append($('<option>', { 
              value: plant.oa_id,
              text : plant.scientific_name 
          }));
        });

        $(select).append($('<option>', { 
              value: 'new_plant',
              text : 'Enter a new plant' 
          }));
      });

  };
