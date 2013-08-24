crypto = require 'crypto'
moment = require 'moment'

exports.upload = (req,res,next) ->
	res.render 'upload'

exports.generateCORS = (req,res,next) ->
	createS3Policy req.params.slug, req.params.mime, (err,ret) ->
		if !err
			res.end ret
		else
			console.log "Error (upload): #{err}"
			res.send 403, err
	

createS3Policy = (slug, mimetype, callback) ->
	go = true
	extention = null
	name = Math.floor(Math.random()*110009).toString()
	switch mimetype
		when 'ALLOWED/MIMETYPE'
			extension = 'file'
		when 'OTHER_ALLOWED/MIMETYPE'
			extension = 'file1'
		else
			go = false
	if go
		S3_BUCKET_NAME = 'INFO_HERE'
		S3_ACCESS_KEY  = 'INFO_HERE'
		S3_SECRET_KEY  = 'INFO_HERE'

		expires = moment().add('minutes', 10).unix()

		amzHeaders = "x-amz-acl:public-read"	
		stringToSign = "PUT\n\n#{mimetype}\n#{expires}\n#{amzHeaders}\n/#{S3_BUCKET_NAME}/#{name}.#{extension}"
		sig = crypto.createHmac("sha1", S3_SECRET_KEY).update(stringToSign).digest("base64")

		signed_request = "https://s3.amazonaws.com/#{S3_BUCKET_NAME}/#{name}.#{extension}?AWSAccessKeyId=#{S3_ACCESS_KEY}&Expires=#{expires}&Signature=#{encodeURIComponent sig}"

		# ret = JSON.stringify
		# 	signed_request: 
		# 	url: encodeURIComponent(url)
			

		callback null, signed_request
	else
		callback 'Invalid mime', null


exports.confirmed = (req,res,next) ->
	res.end 'success'