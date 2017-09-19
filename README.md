A web service that provides quotes for digital currency trades using data from the GDAX order book.
https://www.gdax.com

In order to run this project, you need at least ruby 2.3.4 installed

```sh
gem install bundler
cd /path/to/project
bundle install
ruby server.rb
```

Example of request using curl:
```sh
curl -d '{"action":"sell", "base_currency": "BTC", "quote_currency": "USD", "amount": "2.15"}' -H "Content-Type: application/json" -X POST http://localhost:4567
```

Example of response:
```sh
{"total":"1479.6202681468646","price":"688.1954735566812","currency":"USD"}
```




