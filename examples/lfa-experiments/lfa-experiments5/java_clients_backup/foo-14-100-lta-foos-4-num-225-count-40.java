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
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();

foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();

}

void useFoo1(boolean a1, boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

if (a0) {
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
} else {
if (a1) {
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
} else {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();

}

}

}

void useFoo2(boolean a1, boolean a0) {
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();

if (a0) {
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
} else {
if (a1) {
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
} else {
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();

}

}

}

void useFoo3(boolean a1, boolean a0) {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

void useFoo4(boolean a1, boolean a0) {

useFoo0(a0, a1);
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();

foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();

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

useFoo4(a0, a1);

}

}
