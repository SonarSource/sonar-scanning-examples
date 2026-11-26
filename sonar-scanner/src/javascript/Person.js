var Person = function(first, last, middle) {
    this.first = first;
    this.middle = middle;
    this.last = last;
};

Person.prototype = {

    whoAreYou() {
        return this.first + (this.middle ? ' ' + this.middle: '') + ' ' + this.last;
    }

};

var a = Number.NaN;

if (Number.isNaN(a)) {
  console.log("a is not a number");
}
if (!Number.isNaN(a)) {
  console.log("a is not NaN");
}

var strings = ["foo", "bar"];
for (var value of strings) {
  console.log("dead code")
}

var str = null;
if (str == null || str?.length === 0) {
  console.log("String is empty");
}
