
class Test {

}

main(List<String> args) {
    print("1<em>2</em>3".replaceAll(RegExp(r"(<em>|</em>)"), ""));
    var a = [1,2,3];
a.removeRange(0, 3);
  print(a);
}