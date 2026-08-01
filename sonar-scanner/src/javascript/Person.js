var Person = function(first, last, middle) {
    this.first = first;
    this.middle = middle;
    this.last = last;
};

Person.prototype = {

    whoAreYou : function() {
        return this.first + (this.middle ? ' ' + this.middle: '') + ' ' + this.last;
    }

};

var a = NaN;

if (Number.isNaN(a)) {
  console.log("a is not a number");
}
if (!Number.isNaN(a)) {
  console.log("a is not NaN");
}

for (var s of strings) {
  console.log("dead code")
}

if (str == null || str.length == 0) {
  console.log("String is empty");
}
