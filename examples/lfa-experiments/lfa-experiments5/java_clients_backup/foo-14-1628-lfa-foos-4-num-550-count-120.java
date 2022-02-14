class Foo {
      public static Foo getFoo() {
          return new Foo();
      }
  
      void init() {}
void foo0() {}
void foo1() {}
void foo2() {}
void foo3() {}
void foo4() {}
void foo5() {}
void foo6() {}
void foo7() {}
void foo8() {}
void foo9() {}
void foo10() {}
void foo11() {}
void foo12() {}
void foo13() {}
void foo14() {}
}
class Test{
Foo foo0;
Foo foo1;
Foo foo2;
Foo foo3;
Foo foo4;
Foo foo5;
Foo foo6;
Foo foo7;
Foo foo8;
Foo foo9;
Foo foo10;
Foo foo11;
Foo foo12;
Foo foo13;
Foo foo14;

void init(boolean a1, boolean a0){
foo0 = new Foo();
foo0.init();
foo1 = new Foo();
foo1.init();
foo2 = new Foo();
foo2.init();
foo3 = new Foo();
foo3.init();
}

void useFoo0(boolean a1, boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();

foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();

}

void useFoo1(boolean a1, boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();

if (a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
} else {
if (a1) {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
} else {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

}

}

void useFoo2(boolean a1, boolean a0) {

if (a0) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
} else {
if (a1) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);

}

}

if (a0) {
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
} else {
if (a1) {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
} else {
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();

}

}

if (a0) {
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
} else {
if (a1) {
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo9();
foo1.foo9();
foo2.foo9();
foo3.foo9();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();

}

}

if (a0) {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
} else {
if (a1) {
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
} else {
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

}

}

foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);

if (a0) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
if (a1) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);

}

}

if (a0) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
if (a1) {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
} else {
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);
useFoo0(a0, a1);
useFoo1(a0, a1);

}

}

}

void test(boolean a1, boolean a0){
Foo foo0 = new Foo();
foo0.init();
Foo foo1 = new Foo();
foo1.init();
Foo foo2 = new Foo();
foo2.init();
Foo foo3 = new Foo();
foo3.init();

useFoo2(a0, a1);

}

}
