
//= require jasny-bootstrap

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
    diag_comp.setAttribute("id", "compound_name" + mSec);
    diag_comp.setAttribute("name", "compound_name" + mSec);
    diag_comp.setAttribute("autofocus", "autofocus");
    c_td.appendChild(diag_comp).after(c_res);
    

  var plant = document.createElement("select");
    plant.setAttribute("id", "plant_name" + mSec);
    plant.setAttribute("name", "plant_name" + mSec);
    pl_td.appendChild(plant);

  var prod = document.createElement("select");
    prod.setAttribute("id", "product_name" + mSec);
    prod.setAttribute("name", "product_name" + mSec);
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
    
    var msec_num = num_regex(field);

    var select = "#plant_name" + msec_num;

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

        populate_ingredients($(select));
      });

  };

function populate_ingredients(field){
  var msec_num = num_regex(field);
  var ingredient_select = "#product_name" + msec_num;
  var plant_id = field[0].selectedOptions[0].value;

  $.get('/populate-ingredients', {plant_id: plant_id})
    .done(function(data) {
      if ($(ingredient_select)[0].options.length > 0){
        $(ingredient_select).empty();
      };
      $.each(data,function(i, ingredient){
        $(ingredient_select).append($('<option>', { 
            value: ingredient.oa_id,
            text : ingredient.name 
        }));
      });

      $(ingredient_select).append($('<option>', { 
            value: 'new_ingredient',
            text : 'Enter a new ingredient' 
        }));
    });

};
  

  function num_regex(field){
    var msec_regex = /\d+$/;
    var arr = msec_regex.exec(field[0].id);
    
    if (arr == null){
      msec_num = ""
    } else {
      msec_num = arr[0]
    };

    return msec_num;
  };

$(document).ready(function(){
  $('select').change(function () {
    if ($(this).val() == "new_plant") {
      $('#add_plant').modal("show");
    };
    if ($(this).val() == "new_ingredient") {
      var msec_num = num_regex($(this));
      var plant_field = "#plant_name" + msec_num;
      var plant_id = $(plant_field).val();
      $('#add_ingredient').modal("show");
      $('#product_plant_id').val(plant_id);
    };
  });
});

$('.fileinput').fileinput();


function sites(field, result) {
  field.autocomplete({
    source: 'sites',
    appendTo: result,
    select: function(event, ui) {
      field.val(ui.item.name);
      populate_region(ui.item.region); 
      return false;
    }
  })
  .autocomplete( "instance" )._renderItem = function(ul, item) {
    var markup = [
      '<span class="name">' + item.name + '</span>'
    ];
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
    }
};

function populate_region(region){
  
  $("#site_region").val(region);

};