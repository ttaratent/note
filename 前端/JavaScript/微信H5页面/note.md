在微信页面中，可能会出现在进行输入时，页面被手机的输入法上顶，导致留白

似乎需要分别处理
安卓
document.body.scrollTop = 0 好像不用，
至于输入框被软键盘覆盖后页面在输入时上移暂未找到办法

IOS
window.scrollTo(0, document.documentElement.clientHeight)
