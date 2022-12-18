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
void foo15() {}
void foo16() {}
void foo17() {}
void foo18() {}
}
class Test{
Foo foo0;
Foo foo1;
Foo foo2;
Foo foo3;

void init(boolean a0){
foo0 = new Foo();
foo0.init();
foo1 = new Foo();
foo1.init();
foo2 = new Foo();
foo2.init();
foo3 = new Foo();
foo3.init();
}

void useFoo0(boolean a0) {
if (a0) {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
} else {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

}

}

void useFoo1(boolean a0) {
while (a0) {
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

}

}

void useFoo2(boolean a0) {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

}

void useFoo3(boolean a0) {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();

}

void useFoo4(boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();

}

void useFoo5(boolean a0) {
while (a0) {
foo0.foo14();
foo1.foo14();
foo2.foo14();
foo3.foo14();
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();

}

}

void useFoo6(boolean a0) {
if (a0) {
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();
} else {
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();

}

}

void useFoo7(boolean a0) {
if (a0) {
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();
} else {
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();

}

}

void useFoo8(boolean a0) {
if (a0) {
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo17();
foo1.foo17();
foo2.foo17();
foo3.foo17();
} else {
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();
foo0.foo13();
foo1.foo13();
foo2.foo13();
foo3.foo13();

}

}

void useFoo9(boolean a0) {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();

}

void useFoo10(boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();

}

void useFoo11(boolean a0) {
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();

}

void useFoo12(boolean a0) {
if (a0) {
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
} else {
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();

}

}

void useFoo13(boolean a0) {
while (a0) {
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();

}

}

void useFoo14(boolean a0) {
if (a0) {
useFoo5(a0);
useFoo0(a0);
} else {
useFoo5(a0);
useFoo0(a0);

}
useFoo0(a0);
useFoo2(a0);
useFoo1(a0);
useFoo5(a0);
useFoo0(a0);
useFoo5(a0);
useFoo2(a0);
useFoo1(a0);
useFoo0(a0);
useFoo5(a0);
useFoo5(a0);
useFoo1(a0);
useFoo0(a0);
useFoo2(a0);
useFoo1(a0);
useFoo2(a0);
useFoo0(a0);
useFoo1(a0);
useFoo5(a0);
useFoo1(a0);
useFoo0(a0);
useFoo5(a0);
useFoo2(a0);
useFoo1(a0);
useFoo1(a0);
while (a0) {
useFoo2(a0);
useFoo0(a0);
useFoo5(a0);
useFoo1(a0);
useFoo5(a0);

}
while (a0) {
useFoo5(a0);
useFoo1(a0);
useFoo2(a0);
useFoo0(a0);
useFoo1(a0);

}
if (a0) {
useFoo5(a0);
useFoo1(a0);
} else {
useFoo5(a0);
useFoo1(a0);

}
while (a0) {
useFoo2(a0);
useFoo5(a0);
useFoo1(a0);
useFoo0(a0);
useFoo2(a0);

}

}

void useFoo15(boolean a0) {
if (a0) {
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();
} else {
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();

}

}

void useFoo16(boolean a0) {
while (a0) {
useFoo3(a0);
useFoo9(a0);
useFoo9(a0);
useFoo3(a0);
useFoo9(a0);

}
if (a0) {
useFoo9(a0);
useFoo3(a0);
} else {
useFoo3(a0);
useFoo9(a0);

}
useFoo9(a0);
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);
useFoo3(a0);
while (a0) {
useFoo9(a0);
useFoo3(a0);
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);

}
useFoo9(a0);
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);
useFoo9(a0);
useFoo9(a0);
useFoo3(a0);
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);
if (a0) {
useFoo9(a0);
useFoo3(a0);
} else {
useFoo9(a0);
useFoo3(a0);

}
while (a0) {
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);
useFoo9(a0);
useFoo9(a0);

}
if (a0) {
useFoo3(a0);
useFoo9(a0);
} else {
useFoo3(a0);
useFoo9(a0);

}
while (a0) {
useFoo9(a0);
useFoo3(a0);
useFoo3(a0);
useFoo9(a0);
useFoo3(a0);

}

}

void useFoo17(boolean a0) {
while (a0) {
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);

}
while (a0) {
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);

}
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
if (a0) {
useFoo11(a0);
useFoo11(a0);
} else {
useFoo11(a0);
useFoo11(a0);

}
if (a0) {
useFoo11(a0);
useFoo11(a0);
} else {
useFoo11(a0);
useFoo11(a0);

}
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);
useFoo11(a0);

}

void useFoo18(boolean a0) {
if (a0) {
foo0.foo16();
foo1.foo16();
foo2.foo16();
foo3.foo16();
} else {
foo0.foo16();
foo1.foo16();
foo2.foo16();
foo3.foo16();

}

}

void test(boolean a0){
Foo foo0 = new Foo();
foo0.init();
Foo foo1 = new Foo();
foo1.init();
Foo foo2 = new Foo();
foo2.init();
Foo foo3 = new Foo();
foo3.init();

useFoo18(a0);

}

}
