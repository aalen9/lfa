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

void init(boolean a0){
foo0 = new Foo();
foo0.init();
foo1 = new Foo();
foo1.init();
foo2 = new Foo();
foo2.init();
foo3 = new Foo();
foo3.init();
foo4 = new Foo();
foo4.init();
foo5 = new Foo();
foo5.init();
foo6 = new Foo();
foo6.init();
foo7 = new Foo();
foo7.init();
foo8 = new Foo();
foo8.init();
foo9 = new Foo();
foo9.init();
}

void useFoo0(boolean a0) {
while (a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo4.foo4();
foo5.foo4();
foo6.foo4();
foo7.foo4();
foo8.foo4();
foo9.foo4();
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo4.foo5();
foo5.foo5();
foo6.foo5();
foo7.foo5();
foo8.foo5();
foo9.foo5();

}

}

void useFoo1(boolean a0) {
while (a0) {
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo4.foo3();
foo5.foo3();
foo6.foo3();
foo7.foo3();
foo8.foo3();
foo9.foo3();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo4.foo1();
foo5.foo1();
foo6.foo1();
foo7.foo1();
foo8.foo1();
foo9.foo1();
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo4.foo3();
foo5.foo3();
foo6.foo3();
foo7.foo3();
foo8.foo3();
foo9.foo3();

}

}

void useFoo2(boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();
foo0.foo1();
foo1.foo1();
foo2.foo1();
foo3.foo1();
foo4.foo1();
foo5.foo1();
foo6.foo1();
foo7.foo1();
foo8.foo1();
foo9.foo1();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo4.foo4();
foo5.foo4();
foo6.foo4();
foo7.foo4();
foo8.foo4();
foo9.foo4();

}

void useFoo3(boolean a0) {
if (a0) {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo4.foo5();
foo5.foo5();
foo6.foo5();
foo7.foo5();
foo8.foo5();
foo9.foo5();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo4.foo4();
foo5.foo4();
foo6.foo4();
foo7.foo4();
foo8.foo4();
foo9.foo4();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();
} else {
foo0.foo5();
foo1.foo5();
foo2.foo5();
foo3.foo5();
foo4.foo5();
foo5.foo5();
foo6.foo5();
foo7.foo5();
foo8.foo5();
foo9.foo5();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo4.foo4();
foo5.foo4();
foo6.foo4();
foo7.foo4();
foo8.foo4();
foo9.foo4();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();

}

}

void useFoo4(boolean a0) {
while (a0) {
foo0.foo3();
foo1.foo3();
foo2.foo3();
foo3.foo3();
foo4.foo3();
foo5.foo3();
foo6.foo3();
foo7.foo3();
foo8.foo3();
foo9.foo3();
foo0.foo2();
foo1.foo2();
foo2.foo2();
foo3.foo2();
foo4.foo2();
foo5.foo2();
foo6.foo2();
foo7.foo2();
foo8.foo2();
foo9.foo2();
foo0.foo6();
foo1.foo6();
foo2.foo6();
foo3.foo6();
foo4.foo6();
foo5.foo6();
foo6.foo6();
foo7.foo6();
foo8.foo6();
foo9.foo6();

}

}

void useFoo5(boolean a0) {
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();
foo0.foo4();
foo1.foo4();
foo2.foo4();
foo3.foo4();
foo4.foo4();
foo5.foo4();
foo6.foo4();
foo7.foo4();
foo8.foo4();
foo9.foo4();
foo0.foo0();
foo1.foo0();
foo2.foo0();
foo3.foo0();
foo4.foo0();
foo5.foo0();
foo6.foo0();
foo7.foo0();
foo8.foo0();
foo9.foo0();

}

void useFoo6(boolean a0) {
useFoo2(a0);
useFoo1(a0);
useFoo3(a0);
useFoo0(a0);
useFoo2(a0);
if (a0) {
useFoo4(a0);
useFoo3(a0);
} else {
useFoo0(a0);
useFoo3(a0);

}
if (a0) {
useFoo3(a0);
useFoo5(a0);
} else {
useFoo0(a0);
useFoo5(a0);

}
if (a0) {
useFoo0(a0);
useFoo3(a0);
} else {
useFoo3(a0);
useFoo0(a0);

}
useFoo3(a0);
useFoo5(a0);
useFoo2(a0);
useFoo0(a0);
useFoo1(a0);

}

void useFoo7(boolean a0) {
useFoo6(a0);
useFoo3(a0);
useFoo5(a0);
useFoo2(a0);
useFoo4(a0);
while (a0) {
useFoo5(a0);
useFoo2(a0);
useFoo0(a0);
useFoo6(a0);
useFoo3(a0);

}
while (a0) {
useFoo2(a0);
useFoo5(a0);
useFoo6(a0);
useFoo3(a0);
useFoo0(a0);

}
useFoo2(a0);
useFoo0(a0);
useFoo3(a0);
useFoo5(a0);
useFoo6(a0);
useFoo3(a0);
useFoo0(a0);
useFoo2(a0);
useFoo5(a0);
useFoo1(a0);

}

void useFoo8(boolean a0) {
useFoo4(a0);
useFoo3(a0);
useFoo2(a0);
useFoo6(a0);
useFoo3(a0);
useFoo3(a0);
useFoo6(a0);
useFoo3(a0);
useFoo2(a0);
useFoo5(a0);
while (a0) {
useFoo5(a0);
useFoo1(a0);
useFoo3(a0);
useFoo0(a0);
useFoo5(a0);

}
if (a0) {
useFoo3(a0);
useFoo7(a0);
} else {
useFoo6(a0);
useFoo3(a0);

}
if (a0) {
useFoo3(a0);
useFoo6(a0);
} else {
useFoo3(a0);
useFoo2(a0);

}

}

void useFoo9(boolean a0) {
if (a0) {
useFoo8(a0);
useFoo3(a0);
} else {
useFoo1(a0);

}

}

void useFoo10(boolean a0) {
while (a0) {
useFoo6(a0);
useFoo3(a0);
useFoo0(a0);
useFoo0(a0);
useFoo5(a0);

}
if (a0) {
useFoo6(a0);
useFoo3(a0);
} else {
useFoo2(a0);
useFoo8(a0);

}
if (a0) {
useFoo3(a0);
useFoo2(a0);
} else {
useFoo3(a0);
useFoo6(a0);

}
while (a0) {
useFoo3(a0);
useFoo0(a0);
useFoo5(a0);
useFoo2(a0);
useFoo6(a0);

}
if (a0) {
useFoo3(a0);
useFoo0(a0);
} else {
useFoo3(a0);
useFoo0(a0);

}

}

void useFoo11(boolean a0) {
useFoo3(a0);
useFoo0(a0);
useFoo10(a0);
useFoo2(a0);
useFoo8(a0);
useFoo3(a0);
useFoo0(a0);
useFoo5(a0);
useFoo7(a0);
useFoo3(a0);
useFoo7(a0);
useFoo3(a0);
useFoo5(a0);
useFoo10(a0);
useFoo0(a0);
useFoo7(a0);
useFoo3(a0);
useFoo0(a0);
useFoo6(a0);
useFoo3(a0);
while (a0) {
useFoo10(a0);
useFoo5(a0);
useFoo3(a0);
useFoo7(a0);
useFoo3(a0);

}

}

void useFoo12(boolean a0) {
useFoo11(a0);
useFoo0(a0);
useFoo3(a0);
useFoo10(a0);
useFoo0(a0);
useFoo2(a0);
useFoo6(a0);
useFoo3(a0);
useFoo11(a0);
useFoo5(a0);
useFoo5(a0);
useFoo7(a0);
useFoo3(a0);
useFoo6(a0);
useFoo11(a0);
if (a0) {
useFoo0(a0);
useFoo3(a0);
} else {
useFoo5(a0);
useFoo7(a0);

}
useFoo11(a0);
useFoo6(a0);
useFoo3(a0);
useFoo0(a0);
useFoo6(a0);

}

void useFoo13(boolean a0) {
useFoo3(a0);
useFoo0(a0);
useFoo11(a0);
useFoo12(a0);
useFoo12(a0);
while (a0) {
useFoo12(a0);
useFoo3(a0);
useFoo11(a0);
useFoo7(a0);
useFoo11(a0);

}
while (a0) {
useFoo3(a0);
useFoo5(a0);
useFoo2(a0);
useFoo6(a0);
useFoo12(a0);

}
useFoo3(a0);
useFoo10(a0);
useFoo2(a0);
useFoo5(a0);
useFoo1(a0);
useFoo3(a0);
useFoo0(a0);
useFoo2(a0);
useFoo9(a0);
useFoo12(a0);

}

void useFoo14(boolean a0) {
useFoo12(a0);
useFoo3(a0);
useFoo13(a0);
useFoo11(a0);
useFoo7(a0);
if (a0) {
useFoo12(a0);
useFoo3(a0);
} else {
useFoo13(a0);
useFoo12(a0);

}
useFoo13(a0);
useFoo11(a0);
useFoo7(a0);
useFoo3(a0);
useFoo10(a0);
useFoo0(a0);
useFoo6(a0);
useFoo13(a0);
useFoo3(a0);
useFoo10(a0);
while (a0) {
useFoo12(a0);
useFoo13(a0);
useFoo11(a0);
useFoo7(a0);
useFoo3(a0);

}

}

void useFoo15(boolean a0) {
useFoo0(a0);
useFoo10(a0);
useFoo12(a0);
useFoo3(a0);
useFoo2(a0);
useFoo10(a0);
useFoo11(a0);
useFoo7(a0);
useFoo13(a0);
useFoo12(a0);
while (a0) {
useFoo12(a0);
useFoo13(a0);
useFoo14(a0);
useFoo0(a0);
useFoo11(a0);

}
useFoo6(a0);
useFoo11(a0);
useFoo12(a0);
useFoo14(a0);
useFoo3(a0);
if (a0) {
useFoo10(a0);
useFoo3(a0);
} else {
useFoo0(a0);
useFoo5(a0);

}

}

void useFoo16(boolean a0) {
while (a0) {
useFoo15(a0);
useFoo13(a0);
useFoo14(a0);
useFoo7(a0);
useFoo3(a0);

}
useFoo3(a0);
useFoo10(a0);
useFoo0(a0);
useFoo11(a0);
useFoo14(a0);
useFoo12(a0);
useFoo3(a0);
useFoo7(a0);
useFoo13(a0);
useFoo14(a0);
useFoo13(a0);
useFoo14(a0);
useFoo5(a0);
useFoo2(a0);
useFoo15(a0);
if (a0) {
useFoo5(a0);
useFoo0(a0);
} else {
useFoo7(a0);
useFoo14(a0);

}

}

void useFoo17(boolean a0) {
useFoo9(a0);

}

void useFoo18(boolean a0) {
useFoo12(a0);
useFoo3(a0);
useFoo11(a0);
useFoo6(a0);
useFoo14(a0);
if (a0) {
useFoo12(a0);
useFoo14(a0);
} else {
useFoo2(a0);
useFoo3(a0);

}
useFoo6(a0);
useFoo14(a0);
useFoo7(a0);
useFoo13(a0);
useFoo3(a0);
while (a0) {
useFoo12(a0);
useFoo3(a0);
useFoo14(a0);
useFoo7(a0);
useFoo11(a0);

}
if (a0) {
useFoo7(a0);
useFoo13(a0);
} else {
useFoo12(a0);
useFoo13(a0);

}

}

void useFoo19(boolean a0) {
useFoo15(a0);
useFoo13(a0);
useFoo18(a0);
useFoo11(a0);
useFoo0(a0);
useFoo13(a0);
useFoo14(a0);
useFoo12(a0);
useFoo18(a0);
useFoo11(a0);
useFoo12(a0);
useFoo13(a0);
useFoo14(a0);
useFoo3(a0);
useFoo0(a0);
if (a0) {
useFoo6(a0);
useFoo18(a0);
} else {
useFoo3(a0);
useFoo5(a0);

}
useFoo18(a0);
useFoo3(a0);
useFoo2(a0);
useFoo12(a0);
useFoo11(a0);

}

void useFoo20(boolean a0) {
useFoo1(a0);

}

void useFoo21(boolean a0) {
if (a0) {
useFoo17(a0);
} else {
useFoo17(a0);

}
while (a0) {

}

}

void useFoo22(boolean a0) {
while (a0) {
useFoo20(a0);

}

}

void useFoo23(boolean a0) {
useFoo5(a0);
useFoo16(a0);
useFoo7(a0);
useFoo18(a0);
useFoo3(a0);
useFoo5(a0);
useFoo12(a0);
useFoo14(a0);
useFoo19(a0);
useFoo18(a0);
useFoo12(a0);
useFoo18(a0);
useFoo3(a0);
useFoo13(a0);
useFoo11(a0);
useFoo3(a0);
useFoo18(a0);
useFoo12(a0);
useFoo13(a0);
useFoo11(a0);
while (a0) {
useFoo2(a0);
useFoo18(a0);
useFoo12(a0);
useFoo14(a0);
useFoo7(a0);

}

}

void useFoo24(boolean a0) {
useFoo14(a0);
useFoo0(a0);
useFoo10(a0);
useFoo19(a0);
useFoo3(a0);
while (a0) {
useFoo11(a0);
useFoo18(a0);
useFoo14(a0);
useFoo2(a0);
useFoo20(a0);

}
if (a0) {
useFoo13(a0);
useFoo18(a0);
} else {
useFoo11(a0);
useFoo14(a0);

}
useFoo3(a0);
useFoo6(a0);
useFoo13(a0);
useFoo11(a0);
useFoo7(a0);
while (a0) {
useFoo12(a0);
useFoo18(a0);
useFoo11(a0);
useFoo13(a0);
useFoo3(a0);

}

}

void useFoo25(boolean a0) {
while (a0) {
useFoo16(a0);
useFoo6(a0);
useFoo11(a0);
useFoo7(a0);
useFoo24(a0);

}
useFoo23(a0);
useFoo11(a0);
useFoo0(a0);
useFoo10(a0);
useFoo7(a0);
if (a0) {
useFoo12(a0);
useFoo18(a0);
} else {
useFoo18(a0);
useFoo3(a0);

}
useFoo13(a0);
useFoo11(a0);
useFoo15(a0);
useFoo10(a0);
useFoo5(a0);
useFoo24(a0);
useFoo7(a0);
useFoo3(a0);
useFoo14(a0);
useFoo19(a0);

}

void useFoo26(boolean a0) {
if (a0) {
useFoo23(a0);
useFoo12(a0);
} else {
useFoo5(a0);
useFoo19(a0);

}
useFoo14(a0);
useFoo13(a0);
useFoo18(a0);
useFoo3(a0);
useFoo6(a0);
while (a0) {
useFoo12(a0);
useFoo24(a0);
useFoo13(a0);
useFoo14(a0);
useFoo2(a0);

}
useFoo18(a0);
useFoo13(a0);
useFoo11(a0);
useFoo6(a0);
useFoo3(a0);
useFoo15(a0);
useFoo7(a0);
useFoo18(a0);
useFoo3(a0);
useFoo11(a0);

}

void useFoo27(boolean a0) {
while (a0) {
useFoo23(a0);
useFoo11(a0);
useFoo24(a0);
useFoo5(a0);
useFoo15(a0);

}
if (a0) {
useFoo2(a0);
useFoo3(a0);
} else {
useFoo11(a0);
useFoo19(a0);

}
useFoo14(a0);
useFoo24(a0);
useFoo26(a0);
useFoo10(a0);
useFoo5(a0);
useFoo16(a0);
useFoo5(a0);
useFoo23(a0);
useFoo3(a0);
useFoo10(a0);
useFoo23(a0);
useFoo3(a0);
useFoo13(a0);
useFoo11(a0);
useFoo15(a0);

}

void useFoo28(boolean a0) {
if (a0) {
useFoo27(a0);
useFoo25(a0);
} else {
useFoo19(a0);
useFoo11(a0);

}
useFoo11(a0);
useFoo13(a0);
useFoo18(a0);
useFoo14(a0);
useFoo16(a0);
useFoo0(a0);
useFoo7(a0);
useFoo18(a0);
useFoo14(a0);
useFoo15(a0);
while (a0) {
useFoo12(a0);
useFoo13(a0);
useFoo24(a0);
useFoo10(a0);
useFoo5(a0);

}
useFoo7(a0);
useFoo12(a0);
useFoo18(a0);
useFoo14(a0);
useFoo25(a0);

}

void useFoo29(boolean a0) {
useFoo20(a0);

}

void useFoo30(boolean a0) {
useFoo3(a0);
useFoo14(a0);
useFoo12(a0);
useFoo18(a0);
useFoo13(a0);
if (a0) {
useFoo12(a0);
useFoo11(a0);
} else {
useFoo24(a0);
useFoo15(a0);

}
if (a0) {
useFoo27(a0);
useFoo2(a0);
} else {
useFoo19(a0);
useFoo25(a0);

}
useFoo5(a0);
useFoo28(a0);
useFoo16(a0);
useFoo10(a0);
useFoo6(a0);
useFoo11(a0);
useFoo28(a0);
useFoo5(a0);
useFoo23(a0);
useFoo14(a0);

}

void useFoo31(boolean a0) {
while (a0) {
useFoo12(a0);
useFoo13(a0);
useFoo11(a0);
useFoo30(a0);
useFoo28(a0);

}
useFoo25(a0);
useFoo19(a0);
useFoo11(a0);
useFoo23(a0);
useFoo14(a0);
while (a0) {
useFoo16(a0);
useFoo27(a0);
useFoo0(a0);
useFoo18(a0);
useFoo3(a0);

}
useFoo26(a0);
useFoo24(a0);
useFoo6(a0);
useFoo12(a0);
useFoo18(a0);
while (a0) {
useFoo11(a0);
useFoo14(a0);
useFoo25(a0);
useFoo2(a0);
useFoo19(a0);

}

}

void useFoo32(boolean a0) {
useFoo16(a0);
useFoo31(a0);
useFoo3(a0);
useFoo12(a0);
useFoo11(a0);
useFoo12(a0);
useFoo11(a0);
useFoo10(a0);
useFoo30(a0);
useFoo26(a0);
if (a0) {
useFoo25(a0);
useFoo27(a0);
} else {
useFoo31(a0);
useFoo6(a0);

}
while (a0) {
useFoo3(a0);
useFoo6(a0);
useFoo11(a0);
useFoo5(a0);
useFoo26(a0);

}
useFoo25(a0);
useFoo0(a0);
useFoo5(a0);
useFoo11(a0);
useFoo24(a0);

}

void useFoo33(boolean a0) {
useFoo21(a0);

}

void useFoo34(boolean a0) {
useFoo8(a0);
useFoo18(a0);
useFoo12(a0);
useFoo31(a0);
useFoo16(a0);
while (a0) {
useFoo7(a0);
useFoo11(a0);
useFoo2(a0);
useFoo23(a0);
useFoo14(a0);

}
if (a0) {
useFoo28(a0);
useFoo7(a0);
} else {
useFoo2(a0);
useFoo28(a0);

}
while (a0) {
useFoo3(a0);
useFoo24(a0);
useFoo30(a0);
useFoo12(a0);
useFoo31(a0);

}
while (a0) {
useFoo14(a0);
useFoo0(a0);
useFoo19(a0);
useFoo23(a0);
useFoo12(a0);

}

}

void useFoo35(boolean a0) {
useFoo15(a0);
useFoo10(a0);
useFoo18(a0);
useFoo14(a0);
useFoo19(a0);
useFoo27(a0);
useFoo5(a0);
useFoo6(a0);
useFoo18(a0);
useFoo3(a0);
useFoo30(a0);
useFoo23(a0);
useFoo12(a0);
useFoo13(a0);
useFoo11(a0);
while (a0) {
useFoo30(a0);
useFoo31(a0);
useFoo18(a0);
useFoo13(a0);
useFoo3(a0);

}
if (a0) {
useFoo31(a0);
useFoo5(a0);
} else {
useFoo3(a0);
useFoo11(a0);

}

}

void useFoo36(boolean a0) {
while (a0) {
useFoo0(a0);
useFoo32(a0);
useFoo7(a0);
useFoo12(a0);
useFoo30(a0);

}
useFoo6(a0);
useFoo31(a0);
useFoo19(a0);
useFoo15(a0);
useFoo7(a0);
while (a0) {
useFoo3(a0);
useFoo6(a0);
useFoo13(a0);
useFoo12(a0);
useFoo11(a0);

}
useFoo2(a0);
useFoo17(a0);
useFoo31(a0);
useFoo26(a0);
useFoo6(a0);
useFoo18(a0);
useFoo30(a0);
useFoo16(a0);
useFoo3(a0);
useFoo31(a0);

}

void useFoo37(boolean a0) {
while (a0) {
useFoo29(a0);

}
if (a0) {
} else {

}

}

void useFoo38(boolean a0) {
useFoo20(a0);
if (a0) {
} else {

}

}

void useFoo39(boolean a0) {
useFoo25(a0);
useFoo3(a0);
useFoo2(a0);
useFoo15(a0);
useFoo26(a0);
useFoo36(a0);
useFoo3(a0);
useFoo28(a0);
useFoo2(a0);
useFoo13(a0);
while (a0) {
useFoo12(a0);
useFoo13(a0);
useFoo3(a0);
useFoo14(a0);
useFoo11(a0);

}
if (a0) {
useFoo7(a0);
useFoo24(a0);
} else {
useFoo6(a0);
useFoo12(a0);

}
if (a0) {
useFoo12(a0);
useFoo14(a0);
} else {
useFoo31(a0);
useFoo36(a0);

}

}

void useFoo40(boolean a0) {
while (a0) {
useFoo0(a0);
useFoo15(a0);
useFoo26(a0);
useFoo39(a0);
useFoo27(a0);

}
useFoo18(a0);
useFoo3(a0);
useFoo32(a0);
useFoo11(a0);
useFoo35(a0);
useFoo11(a0);
useFoo13(a0);
useFoo31(a0);
useFoo10(a0);
useFoo3(a0);
while (a0) {
useFoo26(a0);
useFoo23(a0);
useFoo14(a0);
useFoo7(a0);
useFoo31(a0);

}
useFoo30(a0);
useFoo24(a0);
useFoo3(a0);
useFoo7(a0);
useFoo14(a0);

}

void useFoo41(boolean a0) {
useFoo14(a0);
useFoo16(a0);
useFoo35(a0);
useFoo25(a0);
useFoo0(a0);
while (a0) {
useFoo40(a0);
useFoo2(a0);
useFoo9(a0);
useFoo14(a0);
useFoo5(a0);

}
useFoo18(a0);
useFoo24(a0);
useFoo36(a0);
useFoo7(a0);
useFoo30(a0);
if (a0) {
useFoo23(a0);
useFoo11(a0);
} else {
useFoo30(a0);
useFoo0(a0);

}
useFoo0(a0);
useFoo14(a0);
useFoo3(a0);
useFoo24(a0);
useFoo10(a0);

}

void useFoo42(boolean a0) {
useFoo20(a0);
if (a0) {
} else {

}

}

void useFoo43(boolean a0) {
while (a0) {
useFoo35(a0);
useFoo39(a0);
useFoo13(a0);
useFoo31(a0);
useFoo24(a0);

}
if (a0) {
useFoo30(a0);
useFoo16(a0);
} else {
useFoo10(a0);
useFoo6(a0);

}
if (a0) {
useFoo41(a0);
useFoo11(a0);
} else {
useFoo13(a0);
useFoo24(a0);

}
while (a0) {
useFoo13(a0);
useFoo30(a0);
useFoo26(a0);
useFoo6(a0);
useFoo18(a0);

}
useFoo13(a0);
useFoo12(a0);
useFoo30(a0);
useFoo28(a0);
useFoo18(a0);

}

void useFoo44(boolean a0) {
if (a0) {
useFoo18(a0);
useFoo3(a0);
} else {
useFoo31(a0);
useFoo13(a0);

}
useFoo13(a0);
useFoo3(a0);
useFoo18(a0);
useFoo30(a0);
useFoo12(a0);
useFoo14(a0);
useFoo23(a0);
useFoo12(a0);
useFoo18(a0);
useFoo31(a0);
while (a0) {
useFoo27(a0);
useFoo32(a0);
useFoo11(a0);
useFoo10(a0);
useFoo35(a0);

}
if (a0) {
useFoo13(a0);
useFoo14(a0);
} else {
useFoo13(a0);
useFoo11(a0);

}

}

void useFoo45(boolean a0) {
while (a0) {
useFoo38(a0);

}

}

void useFoo46(boolean a0) {
useFoo17(a0);

}

void useFoo47(boolean a0) {
while (a0) {
useFoo38(a0);

}

}

void useFoo48(boolean a0) {
if (a0) {
useFoo29(a0);
} else {
useFoo29(a0);

}

}

void useFoo49(boolean a0) {
while (a0) {
useFoo28(a0);
useFoo23(a0);
useFoo3(a0);
useFoo13(a0);
useFoo30(a0);

}
if (a0) {
useFoo25(a0);
useFoo10(a0);
} else {
useFoo30(a0);
useFoo32(a0);

}
useFoo0(a0);
useFoo6(a0);
useFoo14(a0);
useFoo15(a0);
useFoo12(a0);
useFoo13(a0);
useFoo24(a0);
useFoo19(a0);
useFoo41(a0);
useFoo36(a0);
if (a0) {
useFoo25(a0);
useFoo26(a0);
} else {
useFoo44(a0);
useFoo30(a0);

}

}

void useFoo50(boolean a0) {
useFoo15(a0);
useFoo16(a0);
useFoo12(a0);
useFoo44(a0);
useFoo14(a0);
useFoo19(a0);
useFoo26(a0);
useFoo32(a0);
useFoo41(a0);
useFoo25(a0);
while (a0) {
useFoo44(a0);
useFoo43(a0);
useFoo3(a0);
useFoo24(a0);
useFoo16(a0);

}
while (a0) {
useFoo11(a0);
useFoo36(a0);
useFoo5(a0);
useFoo7(a0);
useFoo30(a0);

}
useFoo18(a0);
useFoo30(a0);
useFoo26(a0);
useFoo49(a0);
useFoo2(a0);

}

void useFoo51(boolean a0) {
useFoo44(a0);
useFoo24(a0);
useFoo13(a0);
useFoo30(a0);
useFoo28(a0);
useFoo50(a0);
useFoo40(a0);
useFoo15(a0);
useFoo2(a0);
useFoo31(a0);
while (a0) {
useFoo35(a0);
useFoo18(a0);
useFoo44(a0);
useFoo13(a0);
useFoo30(a0);

}
useFoo3(a0);
useFoo7(a0);
useFoo12(a0);
useFoo14(a0);
useFoo18(a0);
useFoo14(a0);
useFoo27(a0);
useFoo13(a0);
useFoo24(a0);
useFoo41(a0);

}

void useFoo52(boolean a0) {
useFoo48(a0);

}

void useFoo53(boolean a0) {
if (a0) {
useFoo6(a0);
useFoo41(a0);
} else {
useFoo2(a0);
useFoo19(a0);

}
while (a0) {
useFoo13(a0);
useFoo51(a0);
useFoo12(a0);
useFoo41(a0);
useFoo32(a0);

}
useFoo49(a0);
useFoo50(a0);
useFoo14(a0);
useFoo35(a0);
useFoo32(a0);
useFoo2(a0);
useFoo12(a0);
useFoo18(a0);
useFoo14(a0);
useFoo13(a0);
useFoo24(a0);
useFoo10(a0);
useFoo7(a0);
useFoo14(a0);
useFoo2(a0);

}

void useFoo54(boolean a0) {
useFoo31(a0);
useFoo25(a0);
useFoo15(a0);
useFoo10(a0);
useFoo43(a0);
useFoo51(a0);
useFoo5(a0);
useFoo25(a0);
useFoo36(a0);
useFoo50(a0);
useFoo21(a0);
useFoo41(a0);
useFoo31(a0);
useFoo24(a0);
useFoo13(a0);
if (a0) {
useFoo18(a0);
useFoo12(a0);
} else {
useFoo44(a0);
useFoo7(a0);

}
while (a0) {
useFoo18(a0);
useFoo24(a0);
useFoo27(a0);
useFoo13(a0);
useFoo11(a0);

}

}

void useFoo55(boolean a0) {
useFoo15(a0);
useFoo16(a0);
useFoo50(a0);
useFoo37(a0);
useFoo41(a0);
while (a0) {
useFoo15(a0);
useFoo53(a0);
useFoo48(a0);
useFoo12(a0);
useFoo30(a0);

}
while (a0) {
useFoo50(a0);
useFoo27(a0);
useFoo23(a0);
useFoo24(a0);
useFoo7(a0);

}
useFoo54(a0);
useFoo53(a0);
useFoo20(a0);
useFoo3(a0);
useFoo25(a0);
useFoo5(a0);
useFoo28(a0);
useFoo2(a0);
useFoo50(a0);
useFoo9(a0);

}

void useFoo56(boolean a0) {
while (a0) {
useFoo20(a0);

}

}

void useFoo57(boolean a0) {
if (a0) {
useFoo33(a0);
} else {
useFoo22(a0);

}

}

void useFoo58(boolean a0) {
useFoo39(a0);
useFoo7(a0);
useFoo31(a0);
useFoo44(a0);
useFoo54(a0);
if (a0) {
useFoo15(a0);
useFoo5(a0);
} else {
useFoo10(a0);
useFoo35(a0);

}
while (a0) {
useFoo11(a0);
useFoo30(a0);
useFoo12(a0);
useFoo3(a0);
useFoo54(a0);

}
useFoo23(a0);
useFoo51(a0);
useFoo35(a0);
useFoo13(a0);
useFoo30(a0);
while (a0) {
useFoo13(a0);
useFoo24(a0);
useFoo43(a0);
useFoo51(a0);
useFoo11(a0);

}

}

void useFoo59(boolean a0) {
useFoo13(a0);
useFoo41(a0);
useFoo18(a0);
useFoo51(a0);
useFoo40(a0);
while (a0) {
useFoo24(a0);
useFoo28(a0);
useFoo0(a0);
useFoo54(a0);
useFoo16(a0);

}
while (a0) {
useFoo7(a0);
useFoo18(a0);
useFoo54(a0);
useFoo44(a0);
useFoo24(a0);

}
useFoo25(a0);
useFoo55(a0);
useFoo44(a0);
useFoo35(a0);
useFoo3(a0);
useFoo40(a0);
useFoo35(a0);
useFoo27(a0);
useFoo13(a0);
useFoo51(a0);

}

void useFoo60(boolean a0) {
useFoo30(a0);
useFoo58(a0);
useFoo11(a0);
useFoo26(a0);
useFoo36(a0);
useFoo5(a0);
useFoo59(a0);
useFoo58(a0);
useFoo28(a0);
useFoo14(a0);
useFoo11(a0);
useFoo59(a0);
useFoo35(a0);
useFoo54(a0);
useFoo24(a0);
useFoo44(a0);
useFoo41(a0);
useFoo55(a0);
useFoo18(a0);
useFoo13(a0);
useFoo18(a0);
useFoo3(a0);
useFoo27(a0);
useFoo36(a0);
useFoo23(a0);

}

void useFoo61(boolean a0) {
useFoo6(a0);
useFoo54(a0);
useFoo14(a0);
useFoo24(a0);
useFoo40(a0);
useFoo11(a0);
useFoo7(a0);
useFoo30(a0);
useFoo19(a0);
useFoo60(a0);
useFoo24(a0);
useFoo18(a0);
useFoo14(a0);
useFoo5(a0);
useFoo7(a0);
while (a0) {
useFoo54(a0);
useFoo27(a0);
useFoo32(a0);
useFoo55(a0);
useFoo13(a0);

}
if (a0) {
useFoo18(a0);
useFoo41(a0);
} else {
useFoo54(a0);
useFoo13(a0);

}

}

void useFoo62(boolean a0) {
if (a0) {
useFoo57(a0);
} else {
useFoo52(a0);

}

}

void useFoo63(boolean a0) {
useFoo17(a0);
while (a0) {

}

}

void useFoo64(boolean a0) {
if (a0) {
useFoo60(a0);
useFoo13(a0);
} else {
useFoo13(a0);
useFoo18(a0);

}
useFoo59(a0);
useFoo25(a0);
useFoo2(a0);
useFoo45(a0);
useFoo30(a0);
while (a0) {
useFoo53(a0);
useFoo58(a0);
useFoo3(a0);
useFoo5(a0);
useFoo19(a0);

}
useFoo26(a0);
useFoo51(a0);
useFoo40(a0);
useFoo19(a0);
useFoo49(a0);
useFoo61(a0);
useFoo18(a0);
useFoo60(a0);
useFoo30(a0);
useFoo32(a0);

}

void useFoo65(boolean a0) {
if (a0) {
useFoo51(a0);
useFoo10(a0);
} else {
useFoo11(a0);
useFoo41(a0);

}
while (a0) {
useFoo55(a0);
useFoo60(a0);
useFoo41(a0);
useFoo30(a0);
useFoo61(a0);

}
useFoo14(a0);
useFoo23(a0);
useFoo24(a0);
useFoo6(a0);
useFoo30(a0);
while (a0) {
useFoo58(a0);
useFoo3(a0);
useFoo25(a0);
useFoo51(a0);
useFoo2(a0);

}
useFoo10(a0);
useFoo32(a0);
useFoo12(a0);
useFoo3(a0);
useFoo26(a0);

}

void useFoo66(boolean a0) {
while (a0) {
useFoo50(a0);
useFoo36(a0);
useFoo35(a0);
useFoo40(a0);
useFoo53(a0);

}
if (a0) {
useFoo1(a0);
useFoo18(a0);
} else {
useFoo2(a0);
useFoo37(a0);

}
if (a0) {
useFoo11(a0);
useFoo58(a0);
} else {
useFoo51(a0);
useFoo40(a0);

}
if (a0) {
useFoo13(a0);
useFoo64(a0);
} else {
useFoo65(a0);
useFoo3(a0);

}
if (a0) {
useFoo25(a0);
useFoo59(a0);
} else {
useFoo0(a0);
useFoo28(a0);

}

}

void useFoo67(boolean a0) {
while (a0) {
useFoo58(a0);
useFoo54(a0);
useFoo7(a0);
useFoo65(a0);
useFoo6(a0);

}
useFoo64(a0);
useFoo27(a0);
useFoo43(a0);
useFoo31(a0);
useFoo44(a0);
useFoo10(a0);
useFoo61(a0);
useFoo51(a0);
useFoo54(a0);
useFoo60(a0);
useFoo44(a0);
useFoo49(a0);
useFoo24(a0);
useFoo0(a0);
useFoo13(a0);
useFoo64(a0);
useFoo36(a0);
useFoo7(a0);
useFoo24(a0);
useFoo44(a0);

}

void useFoo68(boolean a0) {
useFoo55(a0);
useFoo11(a0);
useFoo24(a0);
useFoo54(a0);
useFoo59(a0);
useFoo25(a0);
useFoo15(a0);
useFoo58(a0);
useFoo5(a0);
useFoo0(a0);
useFoo6(a0);
useFoo44(a0);
useFoo58(a0);
useFoo10(a0);
useFoo66(a0);
useFoo64(a0);
useFoo44(a0);
useFoo11(a0);
useFoo14(a0);
useFoo13(a0);
useFoo65(a0);
useFoo3(a0);
useFoo64(a0);
useFoo53(a0);
useFoo66(a0);

}

void useFoo69(boolean a0) {
useFoo30(a0);
useFoo36(a0);
useFoo19(a0);
useFoo7(a0);
useFoo64(a0);
while (a0) {
useFoo0(a0);
useFoo60(a0);
useFoo65(a0);
useFoo6(a0);
useFoo11(a0);

}
useFoo43(a0);
useFoo44(a0);
useFoo14(a0);
useFoo53(a0);
useFoo29(a0);
if (a0) {
useFoo24(a0);
useFoo7(a0);
} else {
useFoo65(a0);
useFoo25(a0);

}
useFoo30(a0);
useFoo28(a0);
useFoo31(a0);
useFoo53(a0);
useFoo46(a0);

}

void useFoo70(boolean a0) {
if (a0) {
useFoo19(a0);
useFoo5(a0);
} else {
useFoo67(a0);
useFoo27(a0);

}
useFoo5(a0);
useFoo40(a0);
useFoo43(a0);
useFoo64(a0);
useFoo19(a0);
useFoo35(a0);
useFoo5(a0);
useFoo59(a0);
useFoo30(a0);
useFoo53(a0);
useFoo30(a0);
useFoo13(a0);
useFoo54(a0);
useFoo44(a0);
useFoo50(a0);
useFoo11(a0);
useFoo32(a0);
useFoo40(a0);
useFoo49(a0);
useFoo24(a0);

}

void useFoo71(boolean a0) {
useFoo69(a0);
useFoo18(a0);
useFoo13(a0);
useFoo30(a0);
useFoo3(a0);
useFoo68(a0);
useFoo36(a0);
useFoo18(a0);
useFoo54(a0);
useFoo7(a0);
while (a0) {
useFoo30(a0);
useFoo50(a0);
useFoo24(a0);
useFoo0(a0);
useFoo40(a0);

}
if (a0) {
useFoo39(a0);
useFoo18(a0);
} else {
useFoo68(a0);
useFoo67(a0);

}
useFoo51(a0);
useFoo14(a0);
useFoo67(a0);
useFoo49(a0);
useFoo35(a0);

}

void useFoo72(boolean a0) {
useFoo69(a0);
useFoo30(a0);
useFoo18(a0);
useFoo11(a0);
useFoo23(a0);
if (a0) {
useFoo24(a0);
useFoo54(a0);
} else {
useFoo14(a0);
useFoo64(a0);

}
useFoo49(a0);
useFoo51(a0);
useFoo23(a0);
useFoo54(a0);
useFoo18(a0);
useFoo11(a0);
useFoo51(a0);
useFoo13(a0);
useFoo30(a0);
useFoo15(a0);
useFoo66(a0);
useFoo18(a0);
useFoo11(a0);
useFoo3(a0);
useFoo55(a0);

}

void useFoo73(boolean a0) {
useFoo27(a0);
useFoo30(a0);
useFoo18(a0);
useFoo72(a0);
useFoo12(a0);
while (a0) {
useFoo11(a0);
useFoo61(a0);
useFoo72(a0);
useFoo12(a0);
useFoo71(a0);

}
while (a0) {
useFoo44(a0);
useFoo64(a0);
useFoo15(a0);
useFoo35(a0);
useFoo65(a0);

}
if (a0) {
useFoo28(a0);
useFoo65(a0);
} else {
useFoo12(a0);
useFoo71(a0);

}
useFoo30(a0);
useFoo58(a0);
useFoo18(a0);
useFoo65(a0);
useFoo69(a0);

}

void useFoo74(boolean a0) {
while (a0) {
useFoo25(a0);
useFoo55(a0);
useFoo12(a0);
useFoo18(a0);
useFoo30(a0);

}
while (a0) {
useFoo68(a0);
useFoo14(a0);
useFoo72(a0);
useFoo44(a0);
useFoo67(a0);

}
if (a0) {
useFoo51(a0);
useFoo16(a0);
} else {
useFoo10(a0);
useFoo58(a0);

}
useFoo39(a0);
useFoo65(a0);
useFoo2(a0);
useFoo43(a0);
useFoo14(a0);
useFoo13(a0);
useFoo60(a0);
useFoo54(a0);
useFoo30(a0);
useFoo7(a0);

}

void useFoo75(boolean a0) {
useFoo20(a0);

}

void useFoo76(boolean a0) {
if (a0) {
useFoo39(a0);
useFoo54(a0);
} else {
useFoo67(a0);
useFoo72(a0);

}
while (a0) {
useFoo64(a0);
useFoo0(a0);
useFoo35(a0);
useFoo69(a0);
useFoo72(a0);

}
useFoo60(a0);
useFoo54(a0);
useFoo74(a0);
useFoo65(a0);
useFoo16(a0);
useFoo26(a0);
useFoo70(a0);
useFoo36(a0);
useFoo19(a0);
useFoo35(a0);
useFoo44(a0);
useFoo18(a0);
useFoo51(a0);
useFoo19(a0);
useFoo53(a0);

}

void useFoo77(boolean a0) {
if (a0) {
useFoo17(a0);
} else {
useFoo48(a0);

}

}

void useFoo78(boolean a0) {
while (a0) {
useFoo42(a0);

}
while (a0) {

}

}

void useFoo79(boolean a0) {
while (a0) {
useFoo26(a0);
useFoo72(a0);
useFoo65(a0);
useFoo3(a0);
useFoo76(a0);

}
if (a0) {
useFoo72(a0);
useFoo51(a0);
} else {
useFoo66(a0);
useFoo26(a0);

}
if (a0) {
useFoo44(a0);
useFoo24(a0);
} else {
useFoo32(a0);
useFoo24(a0);

}
useFoo67(a0);
useFoo40(a0);
useFoo23(a0);
useFoo12(a0);
useFoo60(a0);
if (a0) {
useFoo12(a0);
useFoo30(a0);
} else {
useFoo30(a0);
useFoo12(a0);

}

}

void useFoo80(boolean a0) {
if (a0) {
useFoo67(a0);
useFoo5(a0);
} else {
useFoo19(a0);
useFoo43(a0);

}
while (a0) {
useFoo44(a0);
useFoo24(a0);
useFoo65(a0);
useFoo25(a0);
useFoo7(a0);

}
while (a0) {
useFoo72(a0);
useFoo71(a0);
useFoo23(a0);
useFoo11(a0);
useFoo31(a0);

}
while (a0) {
useFoo25(a0);
useFoo16(a0);
useFoo0(a0);
useFoo67(a0);
useFoo53(a0);

}
useFoo20(a0);
useFoo14(a0);
useFoo32(a0);
useFoo67(a0);
useFoo19(a0);

}

void useFoo81(boolean a0) {
useFoo67(a0);
useFoo70(a0);
useFoo64(a0);
useFoo76(a0);
useFoo55(a0);
if (a0) {
useFoo30(a0);
useFoo70(a0);
} else {
useFoo30(a0);
useFoo80(a0);

}
useFoo76(a0);
useFoo68(a0);
useFoo10(a0);
useFoo35(a0);
useFoo0(a0);
while (a0) {
useFoo40(a0);
useFoo44(a0);
useFoo26(a0);
useFoo30(a0);
useFoo72(a0);

}
useFoo11(a0);
useFoo24(a0);
useFoo64(a0);
useFoo39(a0);
useFoo5(a0);

}

void useFoo82(boolean a0) {
if (a0) {
useFoo0(a0);
useFoo79(a0);
} else {
useFoo16(a0);
useFoo66(a0);

}
while (a0) {
useFoo18(a0);
useFoo12(a0);
useFoo30(a0);
useFoo72(a0);
useFoo54(a0);

}
while (a0) {
useFoo40(a0);
useFoo23(a0);
useFoo69(a0);
useFoo14(a0);
useFoo66(a0);

}
useFoo26(a0);
useFoo43(a0);
useFoo69(a0);
useFoo18(a0);
useFoo59(a0);
useFoo0(a0);
useFoo58(a0);
useFoo2(a0);
useFoo54(a0);
useFoo73(a0);

}

void useFoo83(boolean a0) {
useFoo64(a0);
useFoo26(a0);
useFoo61(a0);
useFoo41(a0);
useFoo10(a0);
if (a0) {
useFoo73(a0);
useFoo41(a0);
} else {
useFoo25(a0);
useFoo19(a0);

}
useFoo71(a0);
useFoo41(a0);
useFoo51(a0);
useFoo28(a0);
useFoo36(a0);
useFoo53(a0);
useFoo63(a0);
useFoo14(a0);
useFoo23(a0);
useFoo65(a0);
useFoo43(a0);
useFoo18(a0);
useFoo41(a0);
useFoo70(a0);
useFoo27(a0);

}

void useFoo84(boolean a0) {
useFoo15(a0);
useFoo28(a0);
useFoo35(a0);
useFoo26(a0);
useFoo72(a0);
useFoo72(a0);
useFoo54(a0);
useFoo60(a0);
useFoo44(a0);
useFoo35(a0);
useFoo76(a0);
useFoo12(a0);
useFoo30(a0);
useFoo64(a0);
useFoo72(a0);
useFoo60(a0);
useFoo72(a0);
useFoo69(a0);
useFoo59(a0);
useFoo14(a0);
if (a0) {
useFoo55(a0);
useFoo44(a0);
} else {
useFoo19(a0);
useFoo35(a0);

}

}

void useFoo85(boolean a0) {
if (a0) {
useFoo61(a0);
useFoo59(a0);
} else {
useFoo19(a0);
useFoo28(a0);

}
useFoo82(a0);
useFoo60(a0);
useFoo44(a0);
useFoo49(a0);
useFoo73(a0);
if (a0) {
useFoo12(a0);
useFoo44(a0);
} else {
useFoo44(a0);
useFoo74(a0);

}
if (a0) {
useFoo65(a0);
useFoo68(a0);
} else {
useFoo18(a0);
useFoo31(a0);

}
useFoo69(a0);
useFoo30(a0);
useFoo81(a0);
useFoo59(a0);
useFoo44(a0);

}

void useFoo86(boolean a0) {
useFoo5(a0);
useFoo84(a0);
useFoo28(a0);
useFoo80(a0);
useFoo79(a0);
useFoo3(a0);
useFoo65(a0);
useFoo23(a0);
useFoo12(a0);
useFoo72(a0);
if (a0) {
useFoo51(a0);
useFoo26(a0);
} else {
useFoo41(a0);
useFoo25(a0);

}
useFoo79(a0);
useFoo59(a0);
useFoo27(a0);
useFoo16(a0);
useFoo72(a0);
useFoo13(a0);
useFoo44(a0);
useFoo49(a0);
useFoo60(a0);
useFoo3(a0);

}

void useFoo87(boolean a0) {
if (a0) {
useFoo1(a0);
} else {
useFoo52(a0);

}

}

void useFoo88(boolean a0) {
useFoo73(a0);
useFoo30(a0);
useFoo24(a0);
useFoo66(a0);
useFoo12(a0);
if (a0) {
useFoo41(a0);
useFoo72(a0);
} else {
useFoo11(a0);
useFoo32(a0);

}
useFoo44(a0);
useFoo3(a0);
useFoo18(a0);
useFoo83(a0);
useFoo32(a0);
while (a0) {
useFoo2(a0);
useFoo82(a0);
useFoo44(a0);
useFoo49(a0);
useFoo11(a0);

}
useFoo27(a0);
useFoo61(a0);
useFoo60(a0);
useFoo59(a0);
useFoo65(a0);

}

void useFoo89(boolean a0) {
useFoo75(a0);
while (a0) {

}

}

void useFoo90(boolean a0) {
useFoo13(a0);
useFoo64(a0);
useFoo54(a0);
useFoo0(a0);
useFoo30(a0);
while (a0) {
useFoo60(a0);
useFoo11(a0);
useFoo83(a0);
useFoo39(a0);
useFoo81(a0);

}
while (a0) {
useFoo43(a0);
useFoo18(a0);
useFoo65(a0);
useFoo30(a0);
useFoo67(a0);

}
while (a0) {
useFoo84(a0);
useFoo64(a0);
useFoo16(a0);
useFoo30(a0);
useFoo7(a0);

}
useFoo3(a0);
useFoo5(a0);
useFoo54(a0);
useFoo85(a0);
useFoo53(a0);

}

void useFoo91(boolean a0) {
useFoo5(a0);
useFoo39(a0);
useFoo72(a0);
useFoo60(a0);
useFoo51(a0);
if (a0) {
useFoo61(a0);
useFoo14(a0);
} else {
useFoo31(a0);
useFoo44(a0);

}
useFoo58(a0);
useFoo67(a0);
useFoo24(a0);
useFoo88(a0);
useFoo68(a0);
while (a0) {
useFoo64(a0);
useFoo76(a0);
useFoo63(a0);
useFoo69(a0);
useFoo59(a0);

}
useFoo79(a0);
useFoo13(a0);
useFoo31(a0);
useFoo73(a0);
useFoo41(a0);

}

void useFoo92(boolean a0) {
while (a0) {
useFoo72(a0);
useFoo59(a0);
useFoo43(a0);
useFoo3(a0);
useFoo67(a0);

}
while (a0) {
useFoo44(a0);
useFoo70(a0);
useFoo14(a0);
useFoo3(a0);
useFoo36(a0);

}
useFoo76(a0);
useFoo73(a0);
useFoo18(a0);
useFoo71(a0);
useFoo59(a0);
useFoo67(a0);
useFoo60(a0);
useFoo41(a0);
useFoo7(a0);
useFoo44(a0);
if (a0) {
useFoo60(a0);
useFoo69(a0);
} else {
useFoo67(a0);
useFoo81(a0);

}

}

void useFoo93(boolean a0) {
if (a0) {
useFoo1(a0);
} else {
useFoo17(a0);

}
if (a0) {
} else {

}

}

void useFoo94(boolean a0) {
while (a0) {
useFoo42(a0);

}
while (a0) {

}

}

void useFoo95(boolean a0) {
useFoo52(a0);
while (a0) {

}

}

void useFoo96(boolean a0) {
useFoo95(a0);
while (a0) {

}

}

void useFoo97(boolean a0) {
useFoo38(a0);
if (a0) {
} else {

}

}

void useFoo98(boolean a0) {
while (a0) {
useFoo41(a0);
useFoo88(a0);
useFoo55(a0);
useFoo59(a0);
useFoo69(a0);

}
useFoo65(a0);
useFoo0(a0);
useFoo91(a0);
useFoo90(a0);
useFoo97(a0);
useFoo51(a0);
useFoo12(a0);
useFoo72(a0);
useFoo64(a0);
useFoo81(a0);
useFoo54(a0);
useFoo43(a0);
useFoo11(a0);
useFoo7(a0);
useFoo64(a0);
while (a0) {
useFoo85(a0);
useFoo23(a0);
useFoo31(a0);
useFoo35(a0);
useFoo84(a0);

}

}

void useFoo99(boolean a0) {
useFoo89(a0);

}

void useFoo100(boolean a0) {
useFoo65(a0);
useFoo10(a0);
useFoo92(a0);
useFoo51(a0);
useFoo25(a0);
if (a0) {
useFoo83(a0);
useFoo91(a0);
} else {
useFoo86(a0);
useFoo64(a0);

}
useFoo14(a0);
useFoo80(a0);
useFoo53(a0);
useFoo11(a0);
useFoo13(a0);
useFoo90(a0);
useFoo19(a0);
useFoo84(a0);
useFoo74(a0);
useFoo14(a0);
if (a0) {
useFoo14(a0);
useFoo67(a0);
} else {
useFoo0(a0);
useFoo88(a0);

}

}

void useFoo101(boolean a0) {
if (a0) {
useFoo95(a0);
} else {
useFoo56(a0);

}

}

void useFoo102(boolean a0) {
useFoo85(a0);
useFoo55(a0);
useFoo64(a0);
useFoo24(a0);
useFoo35(a0);
if (a0) {
useFoo70(a0);
useFoo10(a0);
} else {
useFoo28(a0);
useFoo14(a0);

}
useFoo14(a0);
useFoo54(a0);
useFoo86(a0);
useFoo71(a0);
useFoo31(a0);
while (a0) {
useFoo71(a0);
useFoo98(a0);
useFoo43(a0);
useFoo14(a0);
useFoo67(a0);

}
useFoo25(a0);
useFoo28(a0);
useFoo58(a0);
useFoo5(a0);
useFoo83(a0);

}

void useFoo103(boolean a0) {
useFoo66(a0);
useFoo40(a0);
useFoo81(a0);
useFoo55(a0);
useFoo69(a0);
useFoo72(a0);
useFoo83(a0);
useFoo51(a0);
useFoo25(a0);
useFoo15(a0);
useFoo16(a0);
useFoo23(a0);
useFoo64(a0);
useFoo65(a0);
useFoo91(a0);
useFoo3(a0);
useFoo13(a0);
useFoo44(a0);
useFoo10(a0);
useFoo60(a0);
while (a0) {
useFoo31(a0);
useFoo2(a0);
useFoo1(a0);
useFoo100(a0);
useFoo12(a0);

}

}

void useFoo104(boolean a0) {
useFoo8(a0);
useFoo41(a0);
useFoo32(a0);
useFoo65(a0);
useFoo64(a0);
useFoo40(a0);
useFoo19(a0);
useFoo84(a0);
useFoo53(a0);
useFoo32(a0);
while (a0) {
useFoo53(a0);
useFoo20(a0);
useFoo90(a0);
useFoo52(a0);
useFoo24(a0);

}
while (a0) {
useFoo26(a0);
useFoo79(a0);
useFoo3(a0);
useFoo25(a0);
useFoo90(a0);

}
useFoo0(a0);
useFoo4(a0);
useFoo32(a0);
useFoo49(a0);
useFoo14(a0);

}

void useFoo105(boolean a0) {
useFoo72(a0);
useFoo92(a0);
useFoo65(a0);
useFoo12(a0);
useFoo13(a0);
useFoo11(a0);
useFoo3(a0);
useFoo76(a0);
useFoo52(a0);
useFoo69(a0);
useFoo54(a0);
useFoo32(a0);
useFoo44(a0);
useFoo51(a0);
useFoo24(a0);
useFoo25(a0);
useFoo53(a0);
useFoo98(a0);
useFoo2(a0);
useFoo54(a0);
while (a0) {
useFoo61(a0);
useFoo98(a0);
useFoo74(a0);
useFoo59(a0);
useFoo88(a0);

}

}

void useFoo106(boolean a0) {
if (a0) {
useFoo45(a0);
} else {
useFoo96(a0);

}

}

void useFoo107(boolean a0) {
while (a0) {
useFoo15(a0);
useFoo98(a0);
useFoo53(a0);
useFoo42(a0);
useFoo90(a0);

}
useFoo47(a0);
useFoo71(a0);
useFoo15(a0);
useFoo11(a0);
useFoo79(a0);
useFoo64(a0);
useFoo10(a0);
useFoo80(a0);
useFoo28(a0);
useFoo65(a0);
useFoo76(a0);
useFoo20(a0);
useFoo51(a0);
useFoo16(a0);
useFoo65(a0);
useFoo88(a0);
useFoo7(a0);
useFoo18(a0);
useFoo41(a0);
useFoo30(a0);

}

void useFoo108(boolean a0) {
useFoo47(a0);

}

void useFoo109(boolean a0) {
useFoo52(a0);

}

void useFoo110(boolean a0) {
useFoo27(a0);
useFoo73(a0);
useFoo13(a0);
useFoo69(a0);
useFoo41(a0);
if (a0) {
useFoo65(a0);
useFoo98(a0);
} else {
useFoo81(a0);
useFoo18(a0);

}
while (a0) {
useFoo98(a0);
useFoo92(a0);
useFoo69(a0);
useFoo105(a0);
useFoo18(a0);

}
useFoo64(a0);
useFoo85(a0);
useFoo73(a0);
useFoo83(a0);
useFoo81(a0);
if (a0) {
useFoo2(a0);
useFoo76(a0);
} else {
useFoo32(a0);
useFoo90(a0);

}

}

void useFoo111(boolean a0) {
if (a0) {
useFoo75(a0);
} else {
useFoo8(a0);
useFoo11(a0);

}

}

void useFoo112(boolean a0) {
useFoo33(a0);
while (a0) {

}

}

void useFoo113(boolean a0) {
if (a0) {
useFoo92(a0);
useFoo30(a0);
} else {
useFoo83(a0);
useFoo10(a0);

}
useFoo65(a0);
useFoo73(a0);
useFoo3(a0);
useFoo36(a0);
useFoo7(a0);
useFoo31(a0);
useFoo65(a0);
useFoo44(a0);
useFoo58(a0);
useFoo61(a0);
useFoo51(a0);
useFoo86(a0);
useFoo83(a0);
useFoo79(a0);
useFoo69(a0);
useFoo54(a0);
useFoo23(a0);
useFoo69(a0);
useFoo3(a0);
useFoo67(a0);

}

void useFoo114(boolean a0) {
useFoo30(a0);
useFoo23(a0);
useFoo83(a0);
useFoo18(a0);
useFoo59(a0);
while (a0) {
useFoo88(a0);
useFoo74(a0);
useFoo71(a0);
useFoo16(a0);
useFoo113(a0);

}
useFoo91(a0);
useFoo66(a0);
useFoo107(a0);
useFoo18(a0);
useFoo83(a0);
while (a0) {
useFoo25(a0);
useFoo81(a0);
useFoo90(a0);
useFoo35(a0);
useFoo65(a0);

}
useFoo19(a0);
useFoo76(a0);
useFoo27(a0);
useFoo12(a0);
useFoo54(a0);

}

void useFoo115(boolean a0) {
useFoo112(a0);

}

void useFoo116(boolean a0) {
useFoo14(a0);
useFoo28(a0);
useFoo113(a0);
useFoo80(a0);
useFoo74(a0);
while (a0) {
useFoo51(a0);
useFoo102(a0);
useFoo5(a0);
useFoo6(a0);
useFoo90(a0);

}
while (a0) {
useFoo32(a0);
useFoo110(a0);
useFoo37(a0);
useFoo113(a0);
useFoo102(a0);

}
while (a0) {
useFoo16(a0);
useFoo13(a0);
useFoo3(a0);
useFoo85(a0);
useFoo90(a0);

}
useFoo80(a0);
useFoo67(a0);
useFoo12(a0);
useFoo31(a0);
useFoo10(a0);

}

void useFoo117(boolean a0) {
if (a0) {
useFoo44(a0);
useFoo11(a0);
} else {
useFoo30(a0);
useFoo53(a0);

}
useFoo88(a0);
useFoo50(a0);
useFoo108(a0);
useFoo65(a0);
useFoo68(a0);
if (a0) {
useFoo60(a0);
useFoo100(a0);
} else {
useFoo0(a0);
useFoo49(a0);

}
if (a0) {
useFoo66(a0);
useFoo85(a0);
} else {
useFoo105(a0);
useFoo11(a0);

}
if (a0) {
useFoo110(a0);
useFoo100(a0);
} else {
useFoo66(a0);
useFoo11(a0);

}

}

void useFoo118(boolean a0) {
useFoo71(a0);
useFoo64(a0);
useFoo27(a0);
useFoo79(a0);
useFoo31(a0);
if (a0) {
useFoo41(a0);
useFoo12(a0);
} else {
useFoo100(a0);
useFoo28(a0);

}
useFoo60(a0);
useFoo105(a0);
useFoo0(a0);
useFoo43(a0);
useFoo69(a0);
while (a0) {
useFoo51(a0);
useFoo110(a0);
useFoo29(a0);
useFoo69(a0);
useFoo12(a0);

}
if (a0) {
useFoo14(a0);
useFoo105(a0);
} else {
useFoo59(a0);
useFoo35(a0);

}

}

void useFoo119(boolean a0) {
useFoo86(a0);
useFoo73(a0);
useFoo51(a0);
useFoo0(a0);
useFoo117(a0);
useFoo36(a0);
useFoo91(a0);
useFoo110(a0);
useFoo65(a0);
useFoo19(a0);
if (a0) {
useFoo14(a0);
useFoo23(a0);
} else {
useFoo66(a0);
useFoo14(a0);

}
useFoo44(a0);
useFoo100(a0);
useFoo70(a0);
useFoo107(a0);
useFoo51(a0);
useFoo116(a0);
useFoo51(a0);
useFoo114(a0);
useFoo24(a0);
useFoo27(a0);

}

void useFoo120(boolean a0) {
useFoo70(a0);
useFoo103(a0);
useFoo44(a0);
useFoo68(a0);
useFoo86(a0);
while (a0) {
useFoo30(a0);
useFoo110(a0);
useFoo116(a0);
useFoo3(a0);
useFoo35(a0);

}
useFoo67(a0);
useFoo36(a0);
useFoo76(a0);
useFoo86(a0);
useFoo79(a0);
useFoo18(a0);
useFoo71(a0);
useFoo119(a0);
useFoo15(a0);
useFoo43(a0);
while (a0) {
useFoo51(a0);
useFoo10(a0);
useFoo67(a0);
useFoo30(a0);
useFoo53(a0);

}

}

void useFoo121(boolean a0) {
if (a0) {
useFoo119(a0);
useFoo30(a0);
} else {
useFoo82(a0);
useFoo116(a0);

}
useFoo74(a0);
useFoo92(a0);
useFoo98(a0);
useFoo19(a0);
useFoo35(a0);
useFoo0(a0);
useFoo114(a0);
useFoo31(a0);
useFoo65(a0);
useFoo102(a0);
useFoo105(a0);
useFoo19(a0);
useFoo72(a0);
useFoo3(a0);
useFoo0(a0);
useFoo65(a0);
useFoo58(a0);
useFoo6(a0);
useFoo105(a0);
useFoo19(a0);

}

void useFoo122(boolean a0) {
useFoo46(a0);
if (a0) {
} else {

}

}

void useFoo123(boolean a0) {
useFoo8(a0);
useFoo59(a0);
useFoo27(a0);
useFoo65(a0);
useFoo12(a0);
useFoo11(a0);
useFoo50(a0);
useFoo65(a0);
useFoo14(a0);
useFoo81(a0);
if (a0) {
useFoo11(a0);
useFoo54(a0);
} else {
useFoo73(a0);
useFoo90(a0);

}
useFoo68(a0);
useFoo114(a0);
useFoo30(a0);
useFoo83(a0);
useFoo31(a0);
if (a0) {
useFoo88(a0);
useFoo18(a0);
} else {
useFoo15(a0);
useFoo80(a0);

}

}

void useFoo124(boolean a0) {
useFoo59(a0);
useFoo54(a0);
useFoo16(a0);
useFoo67(a0);
useFoo105(a0);
useFoo44(a0);
useFoo85(a0);
useFoo3(a0);
useFoo98(a0);
useFoo61(a0);
useFoo83(a0);
useFoo69(a0);
useFoo30(a0);
useFoo74(a0);
useFoo116(a0);
if (a0) {
useFoo64(a0);
useFoo88(a0);
} else {
useFoo11(a0);
useFoo32(a0);

}
useFoo68(a0);
useFoo26(a0);
useFoo2(a0);
useFoo97(a0);
useFoo51(a0);

}

void useFoo125(boolean a0) {
useFoo105(a0);
useFoo0(a0);
useFoo2(a0);
useFoo3(a0);
useFoo88(a0);
useFoo92(a0);
useFoo14(a0);
useFoo23(a0);
useFoo113(a0);
useFoo84(a0);
if (a0) {
useFoo53(a0);
useFoo82(a0);
} else {
useFoo71(a0);
useFoo100(a0);

}
if (a0) {
useFoo13(a0);
useFoo116(a0);
} else {
useFoo65(a0);
useFoo27(a0);

}
if (a0) {
useFoo105(a0);
useFoo18(a0);
} else {
useFoo41(a0);
useFoo114(a0);

}

}

void useFoo126(boolean a0) {
useFoo109(a0);
while (a0) {

}

}

void useFoo127(boolean a0) {
useFoo100(a0);
useFoo124(a0);
useFoo74(a0);
useFoo51(a0);
useFoo32(a0);
useFoo90(a0);
useFoo39(a0);
useFoo28(a0);
useFoo11(a0);
useFoo15(a0);
useFoo26(a0);
useFoo59(a0);
useFoo70(a0);
useFoo116(a0);
useFoo36(a0);
useFoo102(a0);
useFoo15(a0);
useFoo18(a0);
useFoo41(a0);
useFoo125(a0);
useFoo113(a0);
useFoo81(a0);
useFoo68(a0);
useFoo15(a0);
useFoo26(a0);

}

void useFoo128(boolean a0) {
useFoo31(a0);
useFoo43(a0);
useFoo51(a0);
useFoo54(a0);
useFoo76(a0);
useFoo14(a0);
useFoo124(a0);
useFoo11(a0);
useFoo86(a0);
useFoo80(a0);
useFoo114(a0);
useFoo50(a0);
useFoo113(a0);
useFoo67(a0);
useFoo61(a0);
useFoo98(a0);
useFoo102(a0);
useFoo80(a0);
useFoo13(a0);
useFoo113(a0);
if (a0) {
useFoo79(a0);
useFoo125(a0);
} else {
useFoo31(a0);
useFoo26(a0);

}

}

void useFoo129(boolean a0) {
if (a0) {
useFoo57(a0);
} else {
useFoo62(a0);

}

}

void useFoo130(boolean a0) {
useFoo95(a0);
if (a0) {
} else {

}

}

void useFoo131(boolean a0) {
useFoo33(a0);

}

void useFoo132(boolean a0) {
useFoo14(a0);
useFoo110(a0);
useFoo53(a0);
useFoo35(a0);
useFoo50(a0);
if (a0) {
useFoo63(a0);
useFoo59(a0);
} else {
useFoo19(a0);
useFoo66(a0);

}
useFoo71(a0);
useFoo124(a0);
useFoo31(a0);
useFoo25(a0);
useFoo2(a0);
useFoo113(a0);
useFoo66(a0);
useFoo116(a0);
useFoo72(a0);
useFoo24(a0);
useFoo28(a0);
useFoo92(a0);
useFoo71(a0);
useFoo103(a0);
useFoo100(a0);

}

void useFoo133(boolean a0) {
while (a0) {
useFoo52(a0);

}

}

void useFoo134(boolean a0) {
useFoo119(a0);
useFoo60(a0);
useFoo127(a0);
useFoo72(a0);
useFoo13(a0);
while (a0) {
useFoo12(a0);
useFoo128(a0);
useFoo51(a0);
useFoo26(a0);
useFoo110(a0);

}
useFoo83(a0);
useFoo114(a0);
useFoo61(a0);
useFoo60(a0);
useFoo59(a0);
while (a0) {
useFoo69(a0);
useFoo60(a0);
useFoo128(a0);
useFoo100(a0);
useFoo116(a0);

}
if (a0) {
useFoo32(a0);
useFoo6(a0);
} else {
useFoo119(a0);
useFoo73(a0);

}

}

void useFoo135(boolean a0) {
useFoo124(a0);
useFoo71(a0);
useFoo51(a0);
useFoo53(a0);
useFoo34(a0);
useFoo127(a0);
useFoo19(a0);
useFoo113(a0);
useFoo79(a0);
useFoo60(a0);
useFoo117(a0);
useFoo114(a0);
useFoo83(a0);
useFoo81(a0);
useFoo11(a0);
useFoo69(a0);
useFoo124(a0);
useFoo31(a0);
useFoo100(a0);
useFoo10(a0);
useFoo76(a0);
useFoo59(a0);
useFoo118(a0);
useFoo14(a0);
useFoo31(a0);

}

void useFoo136(boolean a0) {
useFoo2(a0);
useFoo130(a0);
useFoo31(a0);
useFoo65(a0);
useFoo39(a0);
useFoo91(a0);
useFoo79(a0);
useFoo13(a0);
useFoo100(a0);
useFoo53(a0);
useFoo115(a0);
useFoo60(a0);
useFoo11(a0);
useFoo90(a0);
useFoo61(a0);
while (a0) {
useFoo12(a0);
useFoo60(a0);
useFoo13(a0);
useFoo59(a0);
useFoo25(a0);

}
if (a0) {
useFoo26(a0);
useFoo91(a0);
} else {
useFoo55(a0);
useFoo3(a0);

}

}

void useFoo137(boolean a0) {
while (a0) {
useFoo31(a0);
useFoo132(a0);
useFoo79(a0);
useFoo12(a0);
useFoo90(a0);

}
useFoo8(a0);
useFoo113(a0);
useFoo18(a0);
useFoo30(a0);
useFoo114(a0);
useFoo11(a0);
useFoo100(a0);
useFoo82(a0);
useFoo105(a0);
useFoo54(a0);
useFoo67(a0);
useFoo121(a0);
useFoo117(a0);
useFoo0(a0);
useFoo92(a0);
while (a0) {
useFoo125(a0);
useFoo69(a0);
useFoo72(a0);
useFoo117(a0);
useFoo65(a0);

}

}

void useFoo138(boolean a0) {
useFoo81(a0);
useFoo72(a0);
useFoo125(a0);
useFoo24(a0);
useFoo86(a0);
useFoo105(a0);
useFoo76(a0);
useFoo6(a0);
useFoo128(a0);
useFoo13(a0);
if (a0) {
useFoo113(a0);
useFoo102(a0);
} else {
useFoo13(a0);
useFoo3(a0);

}
useFoo76(a0);
useFoo53(a0);
useFoo71(a0);
useFoo6(a0);
useFoo116(a0);
useFoo53(a0);
useFoo29(a0);
useFoo69(a0);
useFoo118(a0);
useFoo83(a0);

}

void useFoo139(boolean a0) {
useFoo68(a0);
useFoo113(a0);
useFoo58(a0);
useFoo100(a0);
useFoo14(a0);
useFoo103(a0);
useFoo118(a0);
useFoo125(a0);
useFoo59(a0);
useFoo35(a0);
useFoo61(a0);
useFoo30(a0);
useFoo79(a0);
useFoo72(a0);
useFoo54(a0);
if (a0) {
useFoo35(a0);
useFoo14(a0);
} else {
useFoo83(a0);
useFoo59(a0);

}
while (a0) {
useFoo31(a0);
useFoo32(a0);
useFoo91(a0);
useFoo127(a0);
useFoo71(a0);

}

}

void useFoo140(boolean a0) {
useFoo67(a0);
useFoo84(a0);
useFoo60(a0);
useFoo98(a0);
useFoo76(a0);
useFoo85(a0);
useFoo74(a0);
useFoo71(a0);
useFoo2(a0);
useFoo102(a0);
useFoo27(a0);
useFoo49(a0);
useFoo44(a0);
useFoo65(a0);
useFoo85(a0);
useFoo68(a0);
useFoo90(a0);
useFoo110(a0);
useFoo55(a0);
useFoo118(a0);
useFoo138(a0);
useFoo135(a0);
useFoo120(a0);
useFoo23(a0);
useFoo137(a0);

}

void useFoo141(boolean a0) {
useFoo14(a0);
useFoo35(a0);
useFoo118(a0);
useFoo138(a0);
useFoo16(a0);
useFoo53(a0);
useFoo130(a0);
useFoo59(a0);
useFoo132(a0);
useFoo66(a0);
useFoo81(a0);
useFoo80(a0);
useFoo102(a0);
useFoo53(a0);
useFoo90(a0);
useFoo66(a0);
useFoo83(a0);
useFoo121(a0);
useFoo100(a0);
useFoo84(a0);
useFoo110(a0);
useFoo122(a0);
useFoo44(a0);
useFoo12(a0);
useFoo14(a0);

}

void useFoo142(boolean a0) {
useFoo35(a0);
useFoo43(a0);
useFoo113(a0);
useFoo138(a0);
useFoo81(a0);
useFoo110(a0);
useFoo31(a0);
useFoo81(a0);
useFoo100(a0);
useFoo15(a0);
useFoo2(a0);
useFoo84(a0);
useFoo13(a0);
useFoo3(a0);
useFoo117(a0);
useFoo137(a0);
useFoo2(a0);
useFoo87(a0);
useFoo60(a0);
useFoo90(a0);
if (a0) {
useFoo128(a0);
useFoo71(a0);
} else {
useFoo15(a0);
useFoo51(a0);

}

}

void useFoo143(boolean a0) {
useFoo117(a0);
useFoo16(a0);
useFoo36(a0);
useFoo140(a0);
useFoo24(a0);
if (a0) {
useFoo82(a0);
useFoo71(a0);
} else {
useFoo71(a0);
useFoo105(a0);

}
while (a0) {
useFoo68(a0);
useFoo113(a0);
useFoo80(a0);
useFoo125(a0);
useFoo64(a0);

}
if (a0) {
useFoo49(a0);
useFoo66(a0);
} else {
useFoo26(a0);
useFoo66(a0);

}
while (a0) {
useFoo70(a0);
useFoo120(a0);
useFoo113(a0);
useFoo139(a0);
useFoo105(a0);

}

}

void useFoo144(boolean a0) {
while (a0) {
useFoo1(a0);

}
if (a0) {
} else {

}

}

void useFoo145(boolean a0) {
useFoo25(a0);
useFoo134(a0);
useFoo124(a0);
useFoo120(a0);
useFoo40(a0);
useFoo121(a0);
useFoo43(a0);
useFoo72(a0);
useFoo64(a0);
useFoo84(a0);
useFoo139(a0);
useFoo44(a0);
useFoo88(a0);
useFoo6(a0);
useFoo114(a0);
useFoo10(a0);
useFoo82(a0);
useFoo41(a0);
useFoo110(a0);
useFoo15(a0);
useFoo68(a0);
useFoo141(a0);
useFoo134(a0);
useFoo41(a0);
useFoo132(a0);

}

void useFoo146(boolean a0) {
useFoo13(a0);
useFoo90(a0);
useFoo53(a0);
useFoo59(a0);
useFoo76(a0);
useFoo123(a0);
useFoo105(a0);
useFoo12(a0);
useFoo44(a0);
useFoo28(a0);
useFoo2(a0);
useFoo89(a0);
useFoo72(a0);
useFoo83(a0);
useFoo32(a0);
useFoo117(a0);
useFoo136(a0);
useFoo14(a0);
useFoo0(a0);
useFoo12(a0);
useFoo69(a0);
useFoo141(a0);
useFoo80(a0);
useFoo10(a0);
useFoo113(a0);

}

void useFoo147(boolean a0) {
useFoo22(a0);
while (a0) {

}

}

void useFoo148(boolean a0) {
while (a0) {
useFoo3(a0);
useFoo36(a0);
useFoo35(a0);
useFoo84(a0);
useFoo143(a0);

}
if (a0) {
useFoo73(a0);
useFoo116(a0);
} else {
useFoo82(a0);
useFoo51(a0);

}
while (a0) {
useFoo132(a0);
useFoo116(a0);
useFoo65(a0);
useFoo19(a0);
useFoo113(a0);

}
useFoo119(a0);
useFoo127(a0);
useFoo83(a0);
useFoo132(a0);
useFoo116(a0);
useFoo40(a0);
useFoo14(a0);
useFoo70(a0);
useFoo25(a0);
useFoo58(a0);

}

void useFoo149(boolean a0) {
useFoo69(a0);
useFoo141(a0);
useFoo117(a0);
useFoo91(a0);
useFoo31(a0);
while (a0) {
useFoo2(a0);
useFoo87(a0);
useFoo54(a0);
useFoo116(a0);
useFoo98(a0);

}
useFoo125(a0);
useFoo117(a0);
useFoo44(a0);
useFoo35(a0);
useFoo148(a0);
useFoo50(a0);
useFoo75(a0);
useFoo41(a0);
useFoo148(a0);
useFoo32(a0);
useFoo121(a0);
useFoo139(a0);
useFoo27(a0);
useFoo76(a0);
useFoo3(a0);

}

void useFoo150(boolean a0) {
while (a0) {
useFoo28(a0);
useFoo139(a0);
useFoo6(a0);
useFoo44(a0);
useFoo24(a0);

}
while (a0) {
useFoo128(a0);
useFoo44(a0);
useFoo102(a0);
useFoo12(a0);
useFoo31(a0);

}
if (a0) {
useFoo40(a0);
useFoo36(a0);
} else {
useFoo14(a0);
useFoo116(a0);

}
useFoo141(a0);
useFoo98(a0);
useFoo88(a0);
useFoo68(a0);
useFoo58(a0);
useFoo5(a0);
useFoo142(a0);
useFoo125(a0);
useFoo127(a0);
useFoo146(a0);

}

void useFoo151(boolean a0) {
if (a0) {
useFoo99(a0);
} else {
useFoo95(a0);

}

}

void useFoo152(boolean a0) {
if (a0) {
useFoo3(a0);
useFoo121(a0);
} else {
useFoo148(a0);
useFoo116(a0);

}
if (a0) {
useFoo0(a0);
useFoo15(a0);
} else {
useFoo73(a0);
useFoo143(a0);

}
useFoo27(a0);
useFoo150(a0);
useFoo36(a0);
useFoo65(a0);
useFoo118(a0);
useFoo145(a0);
useFoo74(a0);
useFoo41(a0);
useFoo50(a0);
useFoo82(a0);
useFoo100(a0);
useFoo27(a0);
useFoo120(a0);
useFoo29(a0);
useFoo118(a0);

}

void useFoo153(boolean a0) {
useFoo120(a0);
useFoo56(a0);
useFoo141(a0);
useFoo84(a0);
useFoo92(a0);
if (a0) {
useFoo83(a0);
useFoo66(a0);
} else {
useFoo69(a0);
useFoo116(a0);

}
while (a0) {
useFoo132(a0);
useFoo66(a0);
useFoo64(a0);
useFoo50(a0);
useFoo70(a0);

}
if (a0) {
useFoo6(a0);
useFoo31(a0);
} else {
useFoo98(a0);
useFoo119(a0);

}
if (a0) {
useFoo54(a0);
useFoo64(a0);
} else {
useFoo79(a0);
useFoo18(a0);

}

}

void useFoo154(boolean a0) {
useFoo18(a0);
useFoo64(a0);
useFoo69(a0);
useFoo135(a0);
useFoo65(a0);
useFoo105(a0);
useFoo59(a0);
useFoo5(a0);
useFoo16(a0);
useFoo114(a0);
while (a0) {
useFoo82(a0);
useFoo116(a0);
useFoo92(a0);
useFoo149(a0);
useFoo93(a0);

}
useFoo124(a0);
useFoo49(a0);
useFoo3(a0);
useFoo100(a0);
useFoo18(a0);
useFoo31(a0);
useFoo7(a0);
useFoo18(a0);
useFoo148(a0);
useFoo79(a0);

}

void useFoo155(boolean a0) {
useFoo60(a0);
useFoo124(a0);
useFoo136(a0);
useFoo137(a0);
useFoo149(a0);
useFoo21(a0);
useFoo117(a0);
useFoo72(a0);
useFoo65(a0);
useFoo118(a0);
useFoo67(a0);
useFoo125(a0);
useFoo124(a0);
useFoo25(a0);
useFoo58(a0);
useFoo150(a0);
useFoo102(a0);
useFoo142(a0);
useFoo6(a0);
useFoo124(a0);
useFoo50(a0);
useFoo127(a0);
useFoo140(a0);
useFoo84(a0);
useFoo81(a0);

}

void useFoo156(boolean a0) {
useFoo143(a0);
useFoo24(a0);
useFoo66(a0);
useFoo120(a0);
useFoo16(a0);
if (a0) {
useFoo145(a0);
useFoo120(a0);
} else {
useFoo100(a0);
useFoo61(a0);

}
useFoo118(a0);
useFoo5(a0);
useFoo121(a0);
useFoo135(a0);
useFoo80(a0);
if (a0) {
useFoo82(a0);
useFoo100(a0);
} else {
useFoo50(a0);
useFoo113(a0);

}
while (a0) {
useFoo35(a0);
useFoo155(a0);
useFoo41(a0);
useFoo10(a0);
useFoo2(a0);

}

}

void useFoo157(boolean a0) {
if (a0) {
useFoo110(a0);
useFoo90(a0);
} else {
useFoo84(a0);
useFoo61(a0);

}
useFoo11(a0);
useFoo148(a0);
useFoo41(a0);
useFoo36(a0);
useFoo118(a0);
useFoo128(a0);
useFoo60(a0);
useFoo156(a0);
useFoo79(a0);
useFoo135(a0);
useFoo23(a0);
useFoo105(a0);
useFoo39(a0);
useFoo36(a0);
useFoo71(a0);
useFoo98(a0);
useFoo53(a0);
useFoo104(a0);
useFoo125(a0);
useFoo146(a0);

}

void useFoo158(boolean a0) {
while (a0) {
useFoo64(a0);
useFoo44(a0);
useFoo39(a0);
useFoo116(a0);
useFoo23(a0);

}
while (a0) {
useFoo64(a0);
useFoo92(a0);
useFoo69(a0);
useFoo100(a0);
useFoo86(a0);

}
useFoo69(a0);
useFoo143(a0);
useFoo118(a0);
useFoo84(a0);
useFoo92(a0);
while (a0) {
useFoo13(a0);
useFoo156(a0);
useFoo108(a0);
useFoo125(a0);
useFoo83(a0);

}
useFoo64(a0);
useFoo54(a0);
useFoo79(a0);
useFoo41(a0);
useFoo110(a0);

}

void useFoo159(boolean a0) {
useFoo42(a0);

}

void useFoo160(boolean a0) {
useFoo55(a0);
useFoo90(a0);
useFoo32(a0);
useFoo2(a0);
useFoo9(a0);
while (a0) {
useFoo118(a0);
useFoo137(a0);
useFoo103(a0);
useFoo30(a0);
useFoo70(a0);

}
if (a0) {
useFoo137(a0);
useFoo19(a0);
} else {
useFoo73(a0);
useFoo155(a0);

}
useFoo102(a0);
useFoo103(a0);
useFoo152(a0);
useFoo145(a0);
useFoo80(a0);
if (a0) {
useFoo156(a0);
useFoo96(a0);
} else {
useFoo143(a0);
useFoo65(a0);

}

}

void useFoo161(boolean a0) {
useFoo19(a0);
useFoo102(a0);
useFoo145(a0);
useFoo81(a0);
useFoo117(a0);
useFoo132(a0);
useFoo127(a0);
useFoo69(a0);
useFoo141(a0);
useFoo117(a0);
if (a0) {
useFoo16(a0);
useFoo51(a0);
} else {
useFoo67(a0);
useFoo12(a0);

}
useFoo137(a0);
useFoo132(a0);
useFoo51(a0);
useFoo134(a0);
useFoo83(a0);
useFoo85(a0);
useFoo100(a0);
useFoo148(a0);
useFoo67(a0);
useFoo119(a0);

}

void useFoo162(boolean a0) {
useFoo128(a0);
useFoo11(a0);
useFoo59(a0);
useFoo58(a0);
useFoo7(a0);
useFoo155(a0);
useFoo60(a0);
useFoo128(a0);
useFoo31(a0);
useFoo54(a0);
useFoo24(a0);
useFoo92(a0);
useFoo69(a0);
useFoo156(a0);
useFoo28(a0);
if (a0) {
useFoo120(a0);
useFoo104(a0);
} else {
useFoo113(a0);
useFoo5(a0);

}
if (a0) {
useFoo60(a0);
useFoo135(a0);
} else {
useFoo61(a0);
useFoo146(a0);

}

}

void useFoo163(boolean a0) {
useFoo117(a0);
useFoo121(a0);
useFoo71(a0);
useFoo139(a0);
useFoo32(a0);
useFoo149(a0);
useFoo71(a0);
useFoo146(a0);
useFoo116(a0);
useFoo76(a0);
useFoo64(a0);
useFoo153(a0);
useFoo125(a0);
useFoo143(a0);
useFoo19(a0);
useFoo72(a0);
useFoo158(a0);
useFoo1(a0);
useFoo146(a0);
useFoo70(a0);
useFoo26(a0);
useFoo90(a0);
useFoo121(a0);
useFoo54(a0);
useFoo50(a0);

}

void useFoo164(boolean a0) {
useFoo130(a0);

}

void useFoo165(boolean a0) {
while (a0) {
useFoo163(a0);
useFoo155(a0);
useFoo7(a0);
useFoo113(a0);
useFoo74(a0);

}
if (a0) {
useFoo83(a0);
useFoo141(a0);
} else {
useFoo83(a0);
useFoo90(a0);

}
while (a0) {
useFoo88(a0);
useFoo30(a0);
useFoo90(a0);
useFoo144(a0);
useFoo114(a0);

}
useFoo72(a0);
useFoo148(a0);
useFoo14(a0);
useFoo27(a0);
useFoo50(a0);
useFoo13(a0);
useFoo83(a0);
useFoo155(a0);
useFoo110(a0);
useFoo1(a0);

}

void useFoo166(boolean a0) {
if (a0) {
useFoo23(a0);
useFoo83(a0);
} else {
useFoo19(a0);
useFoo80(a0);

}
useFoo107(a0);
useFoo40(a0);
useFoo138(a0);
useFoo3(a0);
useFoo102(a0);
if (a0) {
useFoo68(a0);
useFoo118(a0);
} else {
useFoo119(a0);
useFoo141(a0);

}
useFoo50(a0);
useFoo78(a0);
useFoo158(a0);
useFoo37(a0);
useFoo156(a0);
useFoo84(a0);
useFoo12(a0);
useFoo65(a0);
useFoo141(a0);
useFoo71(a0);

}

void useFoo167(boolean a0) {
while (a0) {
useFoo152(a0);
useFoo142(a0);
useFoo12(a0);
useFoo118(a0);
useFoo0(a0);

}
useFoo11(a0);
useFoo31(a0);
useFoo137(a0);
useFoo67(a0);
useFoo53(a0);
useFoo163(a0);
useFoo100(a0);
useFoo155(a0);
useFoo74(a0);
useFoo54(a0);
useFoo110(a0);
useFoo100(a0);
useFoo79(a0);
useFoo137(a0);
useFoo30(a0);
useFoo44(a0);
useFoo84(a0);
useFoo51(a0);
useFoo116(a0);
useFoo98(a0);

}

void useFoo168(boolean a0) {
useFoo7(a0);
useFoo141(a0);
useFoo73(a0);
useFoo135(a0);
useFoo124(a0);
while (a0) {
useFoo102(a0);
useFoo30(a0);
useFoo138(a0);
useFoo139(a0);
useFoo60(a0);

}
if (a0) {
useFoo54(a0);
useFoo140(a0);
} else {
useFoo105(a0);
useFoo13(a0);

}
useFoo114(a0);
useFoo53(a0);
useFoo31(a0);
useFoo13(a0);
useFoo141(a0);
if (a0) {
useFoo10(a0);
useFoo135(a0);
} else {
useFoo124(a0);
useFoo137(a0);

}

}

void useFoo169(boolean a0) {
while (a0) {
useFoo4(a0);
useFoo50(a0);
useFoo12(a0);
useFoo143(a0);
useFoo14(a0);

}
if (a0) {
useFoo53(a0);
useFoo128(a0);
} else {
useFoo67(a0);
useFoo28(a0);

}
useFoo60(a0);
useFoo3(a0);
useFoo10(a0);
useFoo23(a0);
useFoo152(a0);
useFoo0(a0);
useFoo35(a0);
useFoo142(a0);
useFoo105(a0);
useFoo165(a0);
if (a0) {
useFoo59(a0);
useFoo161(a0);
} else {
useFoo155(a0);
useFoo149(a0);

}

}

void useFoo170(boolean a0) {
while (a0) {
useFoo20(a0);

}

}

void useFoo171(boolean a0) {
while (a0) {
useFoo44(a0);
useFoo114(a0);
useFoo19(a0);
useFoo80(a0);
useFoo156(a0);

}
useFoo141(a0);
useFoo40(a0);
useFoo84(a0);
useFoo68(a0);
useFoo128(a0);
while (a0) {
useFoo156(a0);
useFoo124(a0);
useFoo85(a0);
useFoo59(a0);
useFoo138(a0);

}
useFoo55(a0);
useFoo12(a0);
useFoo69(a0);
useFoo148(a0);
useFoo167(a0);
useFoo65(a0);
useFoo137(a0);
useFoo25(a0);
useFoo51(a0);
useFoo91(a0);

}

void useFoo172(boolean a0) {
if (a0) {
useFoo121(a0);
useFoo0(a0);
} else {
useFoo27(a0);
useFoo110(a0);

}
if (a0) {
useFoo125(a0);
useFoo14(a0);
} else {
useFoo61(a0);
useFoo114(a0);

}
useFoo107(a0);
useFoo53(a0);
useFoo151(a0);
useFoo69(a0);
useFoo118(a0);
useFoo30(a0);
useFoo19(a0);
useFoo143(a0);
useFoo82(a0);
useFoo125(a0);
while (a0) {
useFoo125(a0);
useFoo92(a0);
useFoo135(a0);
useFoo71(a0);
useFoo117(a0);

}

}

void useFoo173(boolean a0) {
useFoo134(a0);
useFoo11(a0);
useFoo118(a0);
useFoo31(a0);
useFoo145(a0);
if (a0) {
useFoo127(a0);
useFoo148(a0);
} else {
useFoo55(a0);
useFoo54(a0);

}
if (a0) {
useFoo85(a0);
useFoo103(a0);
} else {
useFoo5(a0);
useFoo83(a0);

}
useFoo65(a0);
useFoo154(a0);
useFoo60(a0);
useFoo90(a0);
useFoo123(a0);
useFoo135(a0);
useFoo7(a0);
useFoo64(a0);
useFoo11(a0);
useFoo163(a0);

}

void useFoo174(boolean a0) {
if (a0) {
useFoo3(a0);
useFoo55(a0);
} else {
useFoo65(a0);
useFoo171(a0);

}
if (a0) {
useFoo163(a0);
useFoo84(a0);
} else {
useFoo59(a0);
useFoo36(a0);

}
useFoo152(a0);
useFoo41(a0);
useFoo153(a0);
useFoo167(a0);
useFoo74(a0);
useFoo98(a0);
useFoo11(a0);
useFoo171(a0);
useFoo26(a0);
useFoo0(a0);
useFoo165(a0);
useFoo113(a0);
useFoo19(a0);
useFoo6(a0);
useFoo31(a0);

}

void useFoo175(boolean a0) {
useFoo66(a0);
useFoo125(a0);
useFoo118(a0);
useFoo67(a0);
useFoo140(a0);
useFoo16(a0);
useFoo26(a0);
useFoo127(a0);
useFoo90(a0);
useFoo52(a0);
useFoo12(a0);
useFoo71(a0);
useFoo125(a0);
useFoo148(a0);
useFoo30(a0);
useFoo25(a0);
useFoo24(a0);
useFoo155(a0);
useFoo60(a0);
useFoo118(a0);
useFoo92(a0);
useFoo155(a0);
useFoo168(a0);
useFoo167(a0);
useFoo161(a0);

}

void useFoo176(boolean a0) {
if (a0) {
useFoo7(a0);
useFoo92(a0);
} else {
useFoo172(a0);
useFoo124(a0);

}
useFoo113(a0);
useFoo105(a0);
useFoo69(a0);
useFoo71(a0);
useFoo59(a0);
while (a0) {
useFoo0(a0);
useFoo124(a0);
useFoo40(a0);
useFoo118(a0);
useFoo80(a0);

}
useFoo172(a0);
useFoo128(a0);
useFoo98(a0);
useFoo117(a0);
useFoo121(a0);
useFoo135(a0);
useFoo53(a0);
useFoo57(a0);
useFoo64(a0);
useFoo58(a0);

}

void useFoo177(boolean a0) {
while (a0) {
useFoo123(a0);
useFoo14(a0);
useFoo7(a0);
useFoo165(a0);
useFoo118(a0);

}
if (a0) {
useFoo152(a0);
useFoo19(a0);
} else {
useFoo102(a0);
useFoo171(a0);

}
useFoo58(a0);
useFoo120(a0);
useFoo29(a0);
useFoo128(a0);
useFoo24(a0);
useFoo98(a0);
useFoo134(a0);
useFoo143(a0);
useFoo16(a0);
useFoo114(a0);
useFoo173(a0);
useFoo166(a0);
useFoo60(a0);
useFoo14(a0);
useFoo163(a0);

}

void useFoo178(boolean a0) {
if (a0) {
useFoo44(a0);
useFoo146(a0);
} else {
useFoo163(a0);
useFoo61(a0);

}
useFoo163(a0);
useFoo76(a0);
useFoo111(a0);
useFoo128(a0);
useFoo141(a0);
if (a0) {
useFoo64(a0);
useFoo58(a0);
} else {
useFoo140(a0);
useFoo100(a0);

}
useFoo153(a0);
useFoo148(a0);
useFoo157(a0);
useFoo163(a0);
useFoo29(a0);
useFoo154(a0);
useFoo59(a0);
useFoo139(a0);
useFoo49(a0);
useFoo86(a0);

}

void useFoo179(boolean a0) {
useFoo173(a0);
useFoo155(a0);
useFoo92(a0);
useFoo12(a0);
useFoo148(a0);
useFoo113(a0);
useFoo86(a0);
useFoo110(a0);
useFoo80(a0);
useFoo31(a0);
useFoo127(a0);
useFoo148(a0);
useFoo138(a0);
useFoo117(a0);
useFoo120(a0);
useFoo140(a0);
useFoo59(a0);
useFoo161(a0);
useFoo163(a0);
useFoo98(a0);
if (a0) {
useFoo71(a0);
useFoo5(a0);
} else {
useFoo11(a0);
useFoo137(a0);

}

}

void useFoo180(boolean a0) {
useFoo2(a0);
useFoo95(a0);
useFoo3(a0);
useFoo32(a0);
useFoo60(a0);
while (a0) {
useFoo31(a0);
useFoo136(a0);
useFoo124(a0);
useFoo18(a0);
useFoo158(a0);

}
useFoo5(a0);
useFoo70(a0);
useFoo178(a0);
useFoo91(a0);
useFoo152(a0);
while (a0) {
useFoo171(a0);
useFoo76(a0);
useFoo24(a0);
useFoo66(a0);
useFoo67(a0);

}
while (a0) {
useFoo49(a0);
useFoo73(a0);
useFoo60(a0);
useFoo154(a0);
useFoo100(a0);

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
Foo foo4 = new Foo();
foo4.init();
Foo foo5 = new Foo();
foo5.init();
Foo foo6 = new Foo();
foo6.init();
Foo foo7 = new Foo();
foo7.init();
Foo foo8 = new Foo();
foo8.init();
Foo foo9 = new Foo();
foo9.init();

useFoo180(a0);

}

}
