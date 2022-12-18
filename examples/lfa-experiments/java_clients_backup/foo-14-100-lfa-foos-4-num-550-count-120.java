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

void useFoo1(boolean a0) {
if (a0) {
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
} else {
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
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();

}

void useFoo3(boolean a0) {
if (a0) {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
} else {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

}

void useFoo4(boolean a0) {
if (a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
} else {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();

}

}

void useFoo5(boolean a0) {
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

void useFoo6(boolean a0) {
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();

}

void useFoo7(boolean a0) {
if (a0) {
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
} else {
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo0.foo8();
foo1.foo8();
foo2.foo8();
foo3.foo8();

}

}

void useFoo8(boolean a0) {
if (a0) {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
} else {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

}

void useFoo9(boolean a0) {
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();
foo0.foo10();
foo1.foo10();
foo2.foo10();
foo3.foo10();
foo0.foo11();
foo1.foo11();
foo2.foo11();
foo3.foo11();

}

void useFoo10(boolean a0) {
if (a0) {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
} else {
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();
foo0.foo7();
foo1.foo7();
foo2.foo7();
foo3.foo7();

}

}

void useFoo11(boolean a0) {
while (a0) {
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);

}
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);
useFoo8(a0);
useFoo8(a0);
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);
if (a0) {
useFoo8(a0);
useFoo10(a0);
} else {
useFoo8(a0);
useFoo10(a0);

}
if (a0) {
useFoo10(a0);
useFoo8(a0);
} else {
useFoo8(a0);
useFoo10(a0);

}
if (a0) {
useFoo8(a0);
useFoo10(a0);
} else {
useFoo8(a0);
useFoo10(a0);

}

}

void useFoo12(boolean a0) {
if (a0) {
useFoo2(a0);
useFoo7(a0);
} else {
useFoo2(a0);
useFoo7(a0);

}
while (a0) {
useFoo2(a0);
useFoo7(a0);
useFoo7(a0);
useFoo2(a0);
useFoo7(a0);

}
if (a0) {
useFoo7(a0);
useFoo2(a0);
} else {
useFoo7(a0);
useFoo2(a0);

}
while (a0) {
useFoo2(a0);
useFoo7(a0);
useFoo7(a0);
useFoo2(a0);
useFoo7(a0);

}
if (a0) {
useFoo7(a0);
useFoo2(a0);
} else {
useFoo7(a0);
useFoo2(a0);

}
useFoo7(a0);
useFoo2(a0);
useFoo2(a0);
useFoo7(a0);
useFoo7(a0);

}

void useFoo13(boolean a0) {
useFoo12(a0);
useFoo7(a0);
useFoo2(a0);
useFoo12(a0);
useFoo7(a0);
useFoo2(a0);
useFoo7(a0);
useFoo12(a0);
useFoo2(a0);
useFoo12(a0);
useFoo12(a0);
useFoo7(a0);
useFoo2(a0);
useFoo12(a0);
useFoo2(a0);
if (a0) {
useFoo7(a0);
useFoo12(a0);
} else {
useFoo12(a0);
useFoo7(a0);

}
if (a0) {
useFoo2(a0);
useFoo12(a0);
} else {
useFoo12(a0);
useFoo7(a0);

}
while (a0) {
useFoo7(a0);
useFoo2(a0);
useFoo12(a0);
useFoo12(a0);
useFoo7(a0);

}

}

void useFoo14(boolean a0) {
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();

}

void useFoo15(boolean a0) {
foo0.foo12();
foo1.foo12();
foo2.foo12();
foo3.foo12();

}

void useFoo16(boolean a0) {
while (a0) {
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();

}

}

void useFoo17(boolean a0) {
while (a0) {
useFoo8(a0);
useFoo11(a0);
useFoo10(a0);
useFoo11(a0);
useFoo10(a0);

}
useFoo10(a0);
useFoo8(a0);
useFoo11(a0);
useFoo11(a0);
useFoo8(a0);
useFoo11(a0);
useFoo8(a0);
useFoo10(a0);
useFoo8(a0);
useFoo10(a0);
useFoo11(a0);
useFoo8(a0);
useFoo10(a0);
useFoo11(a0);
useFoo10(a0);
useFoo10(a0);
useFoo11(a0);
useFoo8(a0);
useFoo8(a0);
useFoo10(a0);
useFoo10(a0);
useFoo8(a0);
useFoo11(a0);
useFoo10(a0);
useFoo11(a0);

}

void useFoo18(boolean a0) {
if (a0) {
useFoo4(a0);
useFoo14(a0);
} else {
useFoo4(a0);
useFoo14(a0);

}
useFoo14(a0);
useFoo4(a0);
useFoo14(a0);
useFoo4(a0);
useFoo4(a0);
if (a0) {
useFoo14(a0);
useFoo4(a0);
} else {
useFoo14(a0);
useFoo4(a0);

}
useFoo14(a0);
useFoo4(a0);
useFoo4(a0);
useFoo14(a0);
useFoo4(a0);
while (a0) {
useFoo4(a0);
useFoo14(a0);
useFoo4(a0);
useFoo14(a0);
useFoo14(a0);

}
useFoo4(a0);
useFoo14(a0);
useFoo4(a0);
useFoo14(a0);
useFoo14(a0);

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
