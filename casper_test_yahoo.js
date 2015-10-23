var casper = require('casper').create();

/* ヤフトピの一番上のタイトルを取得
casper.start("http://www.yahoo.co.jp",function(){
    var text = this.evaluate(function(){
        return __utils__.getElementByXPath('//*[@id="topicsfb"]/div[1]/ul[1]/li[1]/a').innerHTML;
    });
    this.echo(text);
});
casper.run();
*/

var casper = require('casper').create();
casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36 ');
casper.start("http://www.yahoo.co.jp",function(){
    this.evaluate(function(searchTxt) {
        document.querySelector('#srchtxt').value = searchTxt;
        document.querySelector("#srchbtn").click();
    }, "iPhone");
});
casper.then(function(){
    var text = this.evaluate(function(){
        return __utils__.getElementByXPath('//*[@id="WS2m"]/div[1]/div[1]/h3/a').innerHTML;
    });
    this.echo(text);
});
casper.run();
