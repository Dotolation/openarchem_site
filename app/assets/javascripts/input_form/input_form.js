
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

  var hidden = document.createElement("INPUT");
    hidden.setAttribute("type", "hidden");
    hidden.setAttribute("id", "compound_id" + mSec);
    hidden.setAttribute("name", "compound_id" + mSec);
    c_td.appendChild(hidden);

  var plant = document.createElement("select");
    plant.setAttribute("id", "plant_name" + mSec);
    plant.setAttribute("name", "plant_name" + mSec);
    plant.setAttribute("class", "compound_table" + mSec);
    pl_td.appendChild(plant);

  var prod = document.createElement("select");
    prod.setAttribute("id", "product_name" + mSec);
    prod.setAttribute("name", "product_name" + mSec);
    plant.setAttribute("class", "compound_table" + mSec);
    pr_td.appendChild(prod);

    tr.appendChild(c_td);
    tr.appendChild(pl_td);
    tr.appendChild(pr_td);

    document.getElementById("comp_table").appendChild(tr);
    comps($('#' + diag_comp.id), $('#' + c_res.id), $('#' + hidden.id));
    
};

function AddPublicationFields() {

  var date = new Date();

  var mSec = date.getTime();

  var checkboxes = [["biblio_sample", "Sample"], ["biblio_chromatogram", "Chromatogram"], ["biblio_site", "Site"],
  ["biblio_source", "Object"]];
  //add back , ["biblio_other_scientific_analysis", "Other Scientific Analysis"] at some point
  var fields = [["publication_author", "Author(s)"], ["publication_title", "Title"], 
  ["publication_journal_name", "Journal (or Containing Book) Title, Volume, and Number"], 
  ["publication_publisher", "Publisher Name and Location"], ["publication_year", "Year"], 
  ["publication_pages", "Pages"], ["publication_url", "URL"]];
  
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");

  var boxes = document.createElement("li");
  boxes.setAttribute("class", "list-group-item");
  var b_label = document.createElement("label");
  b_label.appendChild(document.createTextNode("Bibliography for:"));
  
  var linebreak = document.createElement("br");
  b_label.appendChild(linebreak);
  boxes.appendChild(b_label);

  
  checkboxes.forEach(function(element){
    var box = document.createElement("input");
      box.type = "checkbox";
      box.id = "_" + element[0] + mSec;
      box.value = 1;
      box.name = "_" + element[0] + mSec;
    var label = document.createElement("label");
      label.htmlFor = "_" + element[0] + mSec;
      label.appendChild(document.createTextNode(element[1]));

    label.appendChild(box);

    b_label.append(label);
  });

  ul.appendChild(boxes)

  fields.forEach(function(element){
    var li = document.createElement("li");
    li.setAttribute("class", "list-group-item");

    var item = document.createElement("input");
      item.id = "_" + element[0] + mSec;
      item.type = "text";
      item.name = "_" + element[0] + mSec;
    var label = document.createElement("label");
      label.htmlFor = "_" + element[0] + mSec;
      label.appendChild(document.createTextNode(element[1]));
    label.append(item);
    li.appendChild(label);
    ul.appendChild(li);
  });

  document.getElementById("collapse_bib_well").insertBefore(ul, document.getElementById("biblio_btn"));
    
};


function comps(field, result, hidden) {
    field.autocomplete({
      source: 'samples',
      appendTo: result,
      open: function (event, ui) { 
        var url = "<a href='javascript:void();' data-toggle='modal' data-target='#add_compound'>Add a new Compound</a>"; 
        $("ul.ui-autocomplete.ui-menu").append(url); 
      },
      select: function(event, ui) {
        field.val(ui.item.name);
        hidden.val(ui.item.oa_id);
        populate_plants(field[0], ui.item.oa_id); 
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

        populate_ingredients($(select)[0]);
      });

  };

function populate_ingredients(field){
  
  var msec_num = num_regex(field);
  var ingredient_select = "#product_name" + msec_num;
  var idx = field.selectedIndex;
  var plant_id = field.options[idx].value;

  $.get('/populate-ingredients', {plant_id: plant_id})
    .done(function(data) {
      if ($(ingredient_select)[0].options.length > 0){
        $(ingredient_select).empty();
      };
      $(ingredient_select).append($('<option>', {
            value: 'blank',
            text: 'Select Ingredient'
      }));

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
    var arr = msec_regex.exec(field.id);
    
    if (arr == null){
      msec_num = ""
    } else {
      msec_num = arr[0]
    };

    return msec_num;
  };


  

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

$(document).on("change", "select", function(){
  var select_name = /plant_name/;
  var arr = select_name.exec(this.name);
  if (arr != null){
    if ($(this).val() == "new_plant") {
      $('#add_plant').modal("show");
    }else{
      populate_ingredients(this);
    };   
  }else{
    if ($(this).val() == "new_ingredient") {
      var msec_num = num_regex(this);
      var plant_field = "#plant_name" + msec_num;
      var plant_id = $(plant_field).val();
      $('#product_plant_id').val(plant_id);
      $('#add_ingredient').modal("show");
      
    };
  }; 

  $('#mini_product').on('submit', function() {
    $('#mini_product').modal('hide');
  });
});

$('.fileinput').fileinput();

