# typingthon

A simple typing practise app with differet layout support.

## Disable Chrome CORS check

https://pub.dev/packages/flutter_cors

`fluttercors --disable`

## Update CORS settings on Cloud Storage
Create a json file,
```
[
    {
      "origin": ["*"],
      "responseHeader": ["Content-Type"],
      "method": ["GET", "HEAD", "DELETE"],
      "maxAgeSeconds": 3600
    }
]
```

Run below command
`gsutil cors set [json filename] gs://[storage name]`

## Generate mock

`dart run build_runner build`