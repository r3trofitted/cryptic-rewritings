# Cryptic (re)Writings

A demonstration of code refactoring, aimed at beginners.

## Step 0: initial code

[TODO]

## Step 1: adding tests

As responsable developpers, we never start a refactoring session without test coverage. Even though 
they are both useful and pleasant to use, testing frameworks such as Minitest or RSpec are not necessary: 
simple methods are enough.

The actual implementation of the tests themselves is not important yet, but feel free to take at look 
at them if you want. (`test_all` may be a bit complicated, though. Skip it if you're not familiar with 
any of the methods it uses, such as `Kernel#class_variable_get`).

However, do note how each test is divided in 2 to 4 phases : setup, exercise, verify, and teardown. 
This basic structure is key to a good unit test.

## Step 2: a bit of cleaning up

Code is easier to understand when it's well presented and organised. The definition of “clean” and “tidy”
is a bit personnal (just ask my six-year-old son), but some guidelines are close to universal:

*   Be consistent. You can use the “Seattle style” (`def initalize record`), or you can use parens in your
    method definitions (`def self.find_by_title(title)`), but you shouldn't use both in the same code base.
*   Respect your indentation rules. You can add extra indentation to private methods, or de-indent certain
    keywords such as `private` (personnaly, I don't do either), but once again, stay consistent.
*   When possible, group code blocks that are related by scope. For example, I like to put my class method
    declarations above all the instance method declarations (including `#initialize`, which I like to put
    above all other instance methods declarations).
*   This also applies to code _within_ a method: note how, in the `#initialize` method, there are two
    paragraphs of code: one for the assignement of values to the instance variables, and one for the
    addition of the new record to the global registry.
  
## Step 3: using our own accessor methods

When an accessor method is available, it is usually better to use it _inside the classe itself_ instead 
of accessing the instance variable itself directly. This way, we'll be ready if the accessor method 
ever adds some logic (such as some data conversion or validation).

(This is not to say that every instance variable should _always_ have accessor methods, though. Accessor 
methods are meant to expose an object's inner data to the outside, and just because they can be useful 
_inside_ the object is not a good enough reason to add them.)

## Step 4: using keyword arguments instead of a Hash

New instances of the `Record` class must be given some data: a title, a year, and an optionnal number 
of stars. To do so, the `Record#initialize` method accepts a Hash as its single argument. This is not 
very straightforward: one has to know what keys the hash must have, something that is not documented 
anywhere.

To make our code easier to understand, we can replace this Hash with _keyword arguments_. In Ruby, 
keyword arguments are a nice way to give a method a more expressive signature, by giving each argument 
a name. Keyword arguments were introduced in Ruby 2.0; before that, passing a Hash was a commom idiom 
among Ruby developpers. The nice thing about keyword arguments is that they work even if the method 
is passed a Hash _instead_ of actual keyword arguments, as long a the _keys of the Hash_ match the 
_names of the keyword arguments_.

So, we can change the signature of our `#initialize` method without breaking the code that creates
new Record objects in our app. Awesome!

Do note a few things in this refactoring:

*   Keyword arguments can be mandatory (`title:`) or optional (`star: 1`)
*   The three setter methods `#title=`, `#year=` and `#stars=` are set in a single line, through what 
    is called _parallel assignment_.
*   Thanks to this _parallel assignment_, the `#initialize` method itself only has two lines, each of whom expresses a single
    piece of logic: first, storing the data, then registering the record. In this situation,
    I see no need to break these two lines in separate paragraphs: their logic is clear as is.

## Step 5a: getting rid of the class variable (part 1)

Class variables in Ruby are not exactly what you'd expect if you're coming from Java, C++ or PHP. In 
Ruby, where classes are objects too, you usually use a _class instance variable_ instead. Here, we 
want this class instance variable (of the class/object `Record`) to be both readable and writable from 
the outside, so we call `attr_accessor` on the _class of the `Record` object_. To do so, we use the 
`class << self` syntax.

However, replacing the `@@records` class variable with a `@records` class instance variable (and the 
associated `Record.records` and `Record.records=` accessor methods) changes our code's API. This goes 
against the rules of a good refactoring, which should change the _inner implementation_ of the code, 
without altering its _external API_.

To mitigate the nasty side-effects of such a drastic change (code that relies on `Record.all` would 
break, for example), we'll do this in two steps: first, we'll keep the old code, but warn the developers 
who use it that it is deprecated. Later, we'll remove it completely.

(In a simple example like this one, this is a bit of an overly zealous stretch. But if our `Record` 
class was part of a gem, for example, this would be good policy, especially if we were to follow semantic 
versioning.)

Note that I've removed the test for the (deprecated) method `Record.all`. I did so because it was an 
excessively complex test which lost most of its value once the `.all` method became a simple alias for 
the `.records` accessor.

## Step 5b: getting rid of the class variable (step 2)

Now that our deprecation warnings have been sent, we can listen to them and change our tests accordingly. 
Then, we can remove the `Record.all` method altogether.

## Step 6: abstracting away the record store

The `@records` class instance variable in `Record` is publicly available to objects outside the class 
thanks to the `Record.records` and `Records.records=` accessor methods. But our code (be it in the 
`Record` class itself or in our tests) doesn't _really_ care about the instance itself: the only thing 
that the code outside the class itself does is either _registering a record_ (in `Record#add_to_records`), 
for example, or _checking if a record exists_ (as in our `test_new_adds_the_record` test).

This is the [_tell, don't ask_](http://martinfowler.com/bliki/TellDontAsk.html) principle. In OOP, an 
object should not _ask_ an other object for its data (and then manipulate it), but instead _tell_ 
it to do the manipulation itself.

To do so, we remove the accessor methods but add a new class method, `.register`, that handles the 
registering. We also have to update  our test a little bit, since they were relying on the `@records` 
class instance variable to be both available _and_ an Array-like object that responds to `#include?`. 
Now 

## Step 7: storing the records in a Hash instead of an Array

