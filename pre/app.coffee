#Cluster info: http://rowanmanning.com/posts/node-cluster-and-express/
cluster = require 'cluster'

if cluster.isMaster
	cpus = require('os').cpus().length

	for cpu in [0...cpus]
		cluster.fork()

	cluster.on 'exit', (worker) ->
		# Replace the dead worker, we're not sentimental
	    console.log "Worker #{worker.id} died :("
	    cluster.fork()
else
	express  =  require 'express'
	http = require 'http'
	path = require 'path'
	S3  =  require './routes/S3'

	app = express()

	app.configure ->
		# sessions
		app.use express.cookieParser('g8GJ3xBtIBv34LbFev09eCAEvOC3wt')
		app.use express.static(path.join(__dirname, 'public'))
		#app.use express.favicon('./public/images/favicon.ico')
		app.use express.session({ cookie: { maxAge: 15552000000 }})
		app.use express.bodyParser()
		app.set 'views', "#{__dirname}/views"
		app.set 'view engine', 'jade'

		app.disable 'x-powered-by'

		app.set 'port', process.env.PORT || 8000

	# To set the enviroment: http://stackoverflow.com/questions/11104028/process-env-node-env-is-undefined

	app.get '/', S3.upload

	app.get "/signS3/:mime(\\w+\/\\w+)", S3.generateCORS

	app.get "/confirmed/:id(\\d+)", S3.confirmed

	app.listen app.get('port'), ->
			console.log "Express server listening on port " + app.get('port')
			console.log "Worker #{cluster.worker.id} running!"