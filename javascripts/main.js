$(function(){

  navCollection = [
    {
      title: "Introduction",
      href: "#introduction",
      subnav: [
        {
          title: "Usage",
          href: "#introduction-usage"
        }
      ]
    },
    {
      title: "Line Extraction",
      href: "#line-extraction",
    },
    {
      title: "Energy Function",
      href: "#energy-function",
      subnav: [
        {
          title: "Rotation Manipulation",
          href: "#energy-rotation"
        },
        {
          title: "Line Preservation",
          href: "#energy-line"
        },
        {
          title: "Shape Preservation",
          href: "#energy-shape"
        },
        {
          title: "Boundary Preservation",
          href: "#energy-boundary"
        },
        {
          title: "Usage",
          href: "#energy-usage"
        }
      ]
    },
    {
      title: "Optimization",
      href: "#optimization",
      subnav: [
        {
          title: "Fix theta update V",
          href: "#thetaV"
        },
        {
          title: "Fix V update theta",
          href: "#Vtheta"
        }
      ]
    },
    {
      title: "Warping",
      href: "#warping",
      subnav: [
        {
          title: "Usage",
          href: "#warping-usage"
        }
      ]
    },
    {
      title: "Discussion",
      href: "#discussion",
      subnav: [
        {
          title: "grid size",
          href: "#discussion-grid"
        },
        {
          title: "rotated angle",
          href: "#discussion-rotated"
        },
        {
          title: "Overall performance",
          href: "#discussion-overall"
        }        
      ]
    },
    {
      title: "What we learn",
      href: "#what-we-learn",
      subnav: [
        {
          title: "李品萱",
          href: "#alice"
        },
        {
          title: "李柏希",
          href: "#boxi"
        },
        {
          title: "詹雨謙",
          href: "#raphael"
        }            
      ]
    },
    
    {
      title: "Gallery",
      href: "#gallery",

    }

  ]

  source   = $("#navbar-template").html()
  template = Handlebars.compile(source)

  $('#my-affix').html(template(navCollection))
  $('body').scrollspy({ target: '#my-affix' });  
  
  

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
  
  
  

  

})



  