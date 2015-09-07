var express = require('express')
  , http = require('http')
  , path = require('path')
  , spawn = require('child_process').spawn
  , fs = require('fs');


var app = express();
// var Canvas = require('canvas');

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser({ 
    keepExtensions: true, 
    uploadDir: __dirname + '/public/uploaded',
    limit: '10mb'
  }));
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// Start the app

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

var io = require('socket.io').listen(server);

io.on('connection', function(socket){
    console.log('a user connected');
    socket.join('vroom');
    

    socket.on("params", function(msg){
      console.log(msg.angle);
      console.log(msg.filepath);
      console.log("cd ..; main("+ msg.angle +", './iRotate/public/" + msg.filepath + "', false); exit();");
      var m = spawn('matlab', ['-nojvm', '-nosplash', '-nodisplay','-r', "cd ..; main("+ msg.angle +", './iRotate/public/" + msg.filepath + "', false); exit();"]);
      socket.emit("status", "[matlab] main begin ...");
      
      m.stdout.on('data', function(d){
          console.log(d.toString('utf-8'))
          socket.emit("status", d.toString('utf-8'));
          // res.write('<div>' + d + '</div>', 'utf-8')

      });
      
      m.on('close', function(){
        console.log('Done.');
        socket.emit("status", "[matlab] done.");
        socket.emit("done", msg.filepath+'.result.jpg');

      });
    })
});
// Routes


app.get('/', function(req, res) {
  res.render('index');
});

app.get('/artifacts', function(req, res) {
  res.render('artifacts');
});

app.post('/', function(req, res) {

  deleteAfterUpload(req.files.myFile.path);
  var imurl = req.files.myFile.path.replace((__dirname+'/public/'),"").toString();
  var impath = req.files.myFile.path;
  res.send(200, imurl);
  res.end();
  console.log(req.files.myFile.path);
  // m = spawn('ls', ['-al']);
  // m.stdout.on('data', function(d){
  //   console.log(d.toString());
  // })
  
  io.sockets.in('vroom').emit("status", "[upload] done @ "+req.files.myFile.path);
    
    

    var m = spawn('matlab', ['-nojvm', '-nosplash', '-nodisplay','-r', "cd ..; img2pgm('"+ impath +"'); exit();"]);
    io.sockets.in('vroom').emit("status", "[matlab] processing img2pgm ...");
    
    m.stdout.on('data', function(d){
        console.log(d.toString('utf-8'))
        io.sockets.in('vroom').emit("status", d.toString('utf-8'));
        // res.write('<div>' + d + '</div>', 'utf-8')

    });
    
    m.on('close', function(){
      console.log('img2pgm done.');
      io.sockets.in('vroom').emit("status", "[matlab] done.");
      var lsd = spawn('../lsd_1.6/lsd', [impath+'.pgm', impath+'.txt']);
      io.sockets.in('vroom').emit("status", "[lsd] processing line detection ...");
      lsd.on('close', function(){
        console.log('lsd done.');
        io.sockets.in('vroom').emit("status", "[lsd] done.");
        
      });
    });

  
  
});




// Private functions

var fs = require('fs');

var deleteAfterUpload = function(path) {
  // setTimeout( function(){
    // fs.unlink(path, function(err) {
      // if (err) console.log(err);
      // console.log('file successfully deleted');
    // });
  // }, 1000 * 60 * 10);
};

