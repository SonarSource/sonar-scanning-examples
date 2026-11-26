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

function describeNumber(a) {
  if (Number.isNaN(a)) {
    console.log("a is not a number");
  } else {
    console.log("a is not NaN");
  }
}

describeNumber(Number.NaN);

var strings = ["foo", "bar"];
for (var value of strings) {
  console.log(value);
}

function describeString(str) {
  if (str == null || str.length === 0) {
    console.log("String is empty");
  }
}

describeString(null);
