(function() {
    'use strict';
//自动点击要选的选项
    var option = document.getElementsByClassName("***");
    for(var i =0;i<option.length;i+=3)  
//这边i+=3是因为我要选的均是第一个选项，而每道题有三个选项
    {
        option[i].click();
    }
//填写评语
    var text=document.getElementsByClassName("***");
    for(var x=0;x<text.length;x+=1)
    {
        text[x].value="老师教的很好，没有意见";
    }
//自动提交
    var upup=document.getElementsByClassName("***");
    for(var y=0;y<upup.length;y+=1)
    {
        upup[y].click();
    }
//确认提交
    var yes=document.getElementsByClassName("***");
     for(var h=0;h<yes.length;h+=1)
    {
        yes[h].click();
    }
})();

Ltrichor
关注
