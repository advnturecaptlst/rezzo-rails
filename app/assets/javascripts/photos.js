$(document).ready(function(){
  var MapsLib = MapsLib || {}
  var MapsLib = {

    fusionTableId:      "1m4Ez9xyTGfY2CU6O-UgEcPzlS0rnzLU93e4Faa0",
    googleApiKey:       "AIzaSyA3FQFrNr5W2OEVmuENqhb2MBB2JabdaOY",
    locationColumn:     "geometry",
    defaultZoom:        11,
    map_centroid:       new google.maps.LatLng(41.8781136, -87.66677856445312),
    searchrecords:      null,

    initialize: function(){
      map = new google.maps.Map(map_canvas, MapsLib.map_options());
      MapsLib.searchrecords = null
      MapsLib.doSearch();
    },

    doSearch: function(location) {
      var whereClause = MapsLib.locationColumn + " not equal to ''";

      MapsLib.submitSearch(whereClause, map);
    },

    submitSearch: function(whereClause, map, location) {
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
MapsLib.initialize();
MapsLib.findMe();
});


// $(window).resize(function () {
//   var h = $(window).height(),
//             offsetTop = 90; // Calculate the top offset

//             $('#map_canvas').css('height', (h - offsetTop));
//           }).resize();

// $(function() {
//   MapsLib.initialize();
//   $("#search_address").geocomplete();

//   $(':checkbox').click(function(){
//     MapsLib.doSearch();
//   });

//   $(':radio').click(function(){
//     MapsLib.doSearch();
//   });

//   $('#search_radius').change(function(){
//     MapsLib.doSearch();
//   });

//   $('#search').click(function(){
//     MapsLib.doSearch();
//   });

//   $('#find_me').click(function(){
//     MapsLib.findMe(); 
//     return false;
//   });

//   $('#reset').click(function(){
//     $.address.parameter('address','');
//     MapsLib.initialize(); 
//     return false;
//   });

//   $(":text").keydown(function(e){
//     var key =  e.keyCode ? e.keyCode : e.which;
//     if(key == 13) {
//       $('#search').click();
//       return false;
//     }
//   });
// });
