$(document).ready(function(){
  var MapsLib = MapsLib || {}
  var MapsLib = {

    fusionTableId:      "1DcX8-vvDmSQINxNX9zoetVjBnZo7tGM8LrTM57E",
    googleApiKey:       "AIzaSyD_JUx-4hkNn5bqllP4OyninnBp-YtOPbg",
    locationColumn:     "Geo",
    defaultZoom:        11,
    map_centroid:       new google.maps.LatLng(8.4, 1.166667),
    searchrecords:      null,

    initialize: function(){
      map = new google.maps.Map(map_canvas, MapsLib.map_options());

      MapsLib.doSearch();
    },

    doSearch: function(location) {
      MapsLib.clearSearch();
      console.log("doSearch")
      var whereClause = MapsLib.locationColumn + " not equal to ''";
      // var type_column = "'type'";
      // var searchType = type_column + " IN (-1,";
      // if ( $("#cbType1").is(':checked')) searchType += "1,";
      // if ( $("#cbType2").is(':checked')) searchType += "2,";
      // if ( $("#cbType3").is(':checked')) searchType += "3,";
      // if ( $("#cbType4").is(':checked')) searchType += "4,";
      // whereClause += " AND " + searchType.slice(0, searchType.length - 1) + ")";
      console.log(whereClause);
      MapsLib.submitSearch(whereClause, map);
    },

    clearSearch: function(){
      console.log("clearSearch");
      // MapsLib.searchrecords.setMap(null);
    },

    submitSearch: function(whereClause, map, location) {
      console.log("setMap");
      MapsLib.searchrecords = new google.maps.FusionTablesLayer({
        query: {
          from:   MapsLib.fusionTableId,
          select: MapsLib.locationColumn,
          where:  whereClause
        },
        styleId: 2,
        templateId: 2
      });
      MapsLib.searchrecords.setMap(map);
    },

    findMe: function() {
      var foundLocation;

      if(navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          foundLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
          MapsLib.map_centroid = foundLocation;
          MapsLib.initialize();
        }, null);
      }
      else {
        alert("Sorry, we could not find your location.");
      }
    },

    map_options: function() {
      return {
        center: MapsLib.map_centroid,
        zoom: MapsLib.defaultZoom,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
    }

  };

// - application begin

$(window).resize(function () {
  var h = $(window).height(),
            offsetTop = 90; // Calculate the top offset

            $('#map_canvas').css('height', (h - offsetTop));
          }).resize();

$(function() {
  MapsLib.initialize();

  $(':checkbox').click(function(){
    MapsLib.doSearch();
  });

  $(':radio').click(function(){
    MapsLib.doSearch();
  });

  $('#search_radius').change(function(){
    MapsLib.doSearch();
  });

  $('#search').click(function(){
    MapsLib.doSearch();
  });

  $('#find_me').click(function(){
    MapsLib.findMe(); 
    return false;
  });

  $('#reset').click(function(){
    $.address.parameter('address','');
    MapsLib.initialize(); 
    return false;
  });

  $(":text").keydown(function(e){
    var key =  e.keyCode ? e.keyCode : e.which;
    if(key == 13) {
      $('#search').click();
      return false;
    }
  });
});

});

