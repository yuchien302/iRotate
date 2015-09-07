$(function() {
  !function(a){function f(a,b){if(!(a.originalEvent.touches.length>1)){a.preventDefault();var c=a.originalEvent.changedTouches[0],d=document.createEvent("MouseEvents");d.initMouseEvent(b,!0,!0,window,1,c.screenX,c.screenY,c.clientX,c.clientY,!1,!1,!1,!1,0,null),a.target.dispatchEvent(d)}}if(a.support.touch="ontouchend"in document,a.support.touch){var e,b=a.ui.mouse.prototype,c=b._mouseInit,d=b._mouseDestroy;b._touchStart=function(a){var b=this;!e&&b._mouseCapture(a.originalEvent.changedTouches[0])&&(e=!0,b._touchMoved=!1,f(a,"mouseover"),f(a,"mousemove"),f(a,"mousedown"))},b._touchMove=function(a){e&&(this._touchMoved=!0,f(a,"mousemove"))},b._touchEnd=function(a){e&&(f(a,"mouseup"),f(a,"mouseout"),this._touchMoved||f(a,"click"),e=!1)},b._mouseInit=function(){var b=this;b.element.bind({touchstart:a.proxy(b,"_touchStart"),touchmove:a.proxy(b,"_touchMove"),touchend:a.proxy(b,"_touchEnd")}),c.call(b)},b._mouseDestroy=function(){var b=this;b.element.unbind({touchstart:a.proxy(b,"_touchStart"),touchmove:a.proxy(b,"_touchMove"),touchend:a.proxy(b,"_touchEnd")}),d.call(b)}}}(jQuery);

  (function($) {
    var origAppend = $.fn.append;

    $.fn.append = function () {
        return origAppend.apply(this, arguments).trigger("append");
    };
  })(jQuery);

  $("#index-artifacts").hide();


  var showInfo = function(message) {
    $('div.progress').hide();
    $('strong.message').text(message);
    $('div.alert').show();
  };
  $('#myFile').on("change", function(){
    // console.log("lalala");
    $('input[type="submit"]').click();
  })
  

  $('input[type="submit"]').on('click', function(evt) {
    $("#log").show();
    $("#index-artifacts").hide();
    evt.preventDefault();
    $('div.progress').show();
    var formData = new FormData();
    var file = document.getElementById('myFile').files[0];
    formData.append('myFile', file);
    
    // $.post('/', function(responseText) {
    //     alert(responseText);
    // });
    // $.post( "test.php", $( "#testform" ).serialize() );

    $.ajax({
        url: '/',  //Server script to process data
        type: 'POST',
        xhr: function() {  // Custom XMLHttpRequest
            var myXhr = $.ajaxSettings.xhr();
            if(myXhr.upload){ // Check if upload property exists
                // myXhr.upload.addEventListener('progress',progressHandlingFunction, false); // For handling the progress of the upload
            }
            return myXhr;
        },
        //Ajax events
        // beforeSend: beforeSendHandler,
        success: function(url){
          // console.log(url)
          $('#result').attr('src', url);
          $('#rotation-before').attr('src', url);
        },
        // error: errorHandler,
        // Form data
        data: formData,
        //Options to tell jQuery not to process data or worry about content-type.
        cache: false,
        contentType: false,
        processData: false
    });

  });



  var step=0.25;
  var scrollbar = $( ".scroll-bar" ).slider({ 
    min: -30, 
    max:  30, 
    step: step, 
    slide: function(){
      var angle = $( ".scroll-bar" ).slider("value");
      // console.log(angle);
      // console.log(angle);
      // $("#log").append("<p>[rotate angle] " + angle + "</p>")
      $("#result").rotate(angle);
    } 
  });
  $("#log").bind("append", function(){
    $("#log").scrollTop($("#log")[0].scrollHeight);
  })
  
  var handleHelper = scrollbar.find( ".ui-slider-handle" )
    .mousedown(function() {
      scrollbar.width( handleHelper.width() );
    })
    .mouseup(function() {
      scrollbar.width( "100%" );
    })
    .append( "<span class='ui-icon ui-icon-grip-dotted-vertical'></span>" )
    .wrap( "<div class='ui-handle-helper-parent'></div>" ).parent();

  $("#inc-angles").click(function(){
    var angle = $( ".scroll-bar" ).slider("value");
    $( ".scroll-bar" ).slider("value", angle+step);
    // $("#result").rotate(angle+step);
  })
  $("#dec-angles").click(function(){
    var angle = $( ".scroll-bar" ).slider("value");
    $( ".scroll-bar" ).slider("value", angle-step);
    // $("#result").rotate(angle-step);
  })

  // var pressTimer

  // $("#inc-angles").mouseup(function(){
  //   clearTimeout(pressTimer)
  //   return false;
  // }).mousedown(function(){
  //   pressTimer = window.setInterval(function() { 
  //     var angle = $( ".scroll-bar" ).slider("value");
  //     $( ".scroll-bar" ).slider("value", angle+step);
  //     $("#result").rotate(angle+step);
  //   } ,100)
  //   return false; 
  // });

  // $("#dec-angles").touchend(function(){
  //   clearTimeout(pressTimer)
  //   return false;
  // }).touchstart(function(){
  //   pressTimer = window.setInterval(function() { 
  //     var angle = $( ".scroll-bar" ).slider("value");
  //     $( ".scroll-bar" ).slider("value", angle+step);
  //     $("#result").rotate(angle+step);
  //   } ,100)
  //   return false; 
  // });

  // $( ".scroll-bar" ).on("mousemove", function() {
  //   var angle = $( ".scroll-bar" ).slider("value");
  //   // console.log(angle);
  //   $("#result").rotate(angle);

  // });
  var socket = io();
  socket.on('status', function(msg){
    $("#log").append("<p>" + msg + "<p>");
    console.log('message: ' + msg);
  });
  
  socket.on('done', function(msg){
    $("#finish-adjust").show();
    $("#log").hide();
    $('#index-artifacts').show()
    $('#rotation-result').attr('src', msg);
  });


  $("#finish-adjust").click(function(){
    $("#log").show();
    $("#index-artifacts").hide();
    $("#finish-adjust").hide();
    socket.emit('params', {angle: $( ".scroll-bar" ).slider("value"), filepath: $('#result').attr('src') });  
  })
  
  

// Thumbnails panel interaction
  $(".before").on("mouseover", function(){
    $(this).siblings("img").removeClass("twinkling")
    $($(this).siblings()[1]).css('visibility', 'visible')
    $($(this).siblings()[2]).css('visibility', 'hidden')
    // console.log("hover before");
  });


  $(".after").on("mouseover", function(){
    $(this).siblings("img").removeClass("twinkling")
    $($(this).siblings()[1]).css('visibility', 'hidden')
    $($(this).siblings()[2]).css('visibility', 'visible')
    // console.log("hover after");
  });

  $(".after, .before").on("mouseleave", function(){
    $(this).siblings("img").addClass("twinkling")
    $($(this).siblings()[1]).css('visibility', 'visible')
    $($(this).siblings()[2]).css('visibility', 'visible')
    // console.log("leave");
  });

});