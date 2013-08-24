# Direct Browser to S3 Upload in Node

This is an example of using the HTML5 FileAPI, XHR2, CORS and signed S3 PUT requests to upload files directly from a browser to S3. There is a sample server side signing app for Node.

You can read more details about the code [here](http://www.ioncannon.net/programming/1539/direct-browser-uploading-amazon-s3-cors-fileapi-xhr2-and-signed-puts).

## Setting up Amazon S3 CORS

Before using any of the examples you will need to set up your S3 CORS data. It is easy enough to do that using the AWS console. The following is an example CORS configuration that should work wherever you install the example:

``` XML
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>PUT</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Content-Type</AllowedHeader>
        <AllowedHeader>x-amz-acl</AllowedHeader>
        <AllowedHeader>origin</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```
