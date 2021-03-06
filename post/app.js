// Generated by CoffeeScript 1.6.2
(function() {
  var S3, app, cluster, cpu, cpus, express, http, path, _i;

  cluster = require('cluster');

  if (cluster.isMaster) {
    cpus = require('os').cpus().length;
    for (cpu = _i = 0; 0 <= cpus ? _i < cpus : _i > cpus; cpu = 0 <= cpus ? ++_i : --_i) {
      cluster.fork();
    }
    cluster.on('exit', function(worker) {
      console.log("Worker " + worker.id + " died :(");
      return cluster.fork();
    });
  } else {
    express = require('express');
    http = require('http');
    path = require('path');
    S3 = require('./routes/S3');
    app = express();
    app.configure(function() {
      app.use(express.cookieParser('g8GJ3xBtIBv34LbFev09eCAEvOC3wt'));
      app.use(express["static"](path.join(__dirname, 'public')));
      app.use(express.session({
        cookie: {
          maxAge: 15552000000
        }
      }));
      app.use(express.bodyParser());
      app.set('views', "" + __dirname + "/views");
      app.set('view engine', 'jade');
      app.disable('x-powered-by');
      return app.set('port', process.env.PORT || 8000);
    });
    app.get('/', S3.upload);
    app.get("/signS3/:mime(\\w+\/\\w+)", S3.generateCORS);
    app.get("/confirmed/:id(\\d+)", S3.confirmed);
    app.listen(app.get('port'), function() {
      console.log("Express server listening on port " + app.get('port'));
      return console.log("Worker " + cluster.worker.id + " running!");
    });
  }

}).call(this);
