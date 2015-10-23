var casper = require('casper').create();
casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36 ');
casper.start("https://translate.google.co.jp/#en/ja/apple",function(){
    this.evaluate(function(searchTxt) {
        document.querySelector('#source').value = searchTxt;
        document.querySelector("#gt-lang-submit").click();
    }, "apple");
    // this.echo('aaa');
    // if (this.exists('div.pgt-cc-r-i')) {
    //     this.echo('翻訳結果');
    // }
    if (this.exists('#gt-appname')) {
        this.echo('翻訳結果');
    }
});
casper.then(function(){
    var text = this.evaluate(function(){
        //return __utils__.getElementByXPath('//*[@class="WS2m"]/div[1]/div[1]/h3/a').innerHTML;
        //return __utils__.getElementByXPath('//*[@class="gt-baf-table"]/div[1]').innerHTML;
        return __utils__.findOne('#gt-appname').innerText; 
    });
    if (this.exists('#gt-appname')) {
        this.echo('翻訳結果');
    }
    this.echo(text);
});
casper.run();
