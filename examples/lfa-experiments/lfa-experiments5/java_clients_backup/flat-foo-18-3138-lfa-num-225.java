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
void foo19() {}
void foo20() {}
void foo21() {}
void foo22() {}
void foo23() {}
void foo24() {}
void foo25() {}
void foo26() {}
void foo27() {}
void foo28() {}
void foo29() {}
void foo30() {}
void foo31() {}
void foo32() {}
void foo33() {}
void foo34() {}
void foo35() {}
void foo36() {}
void foo37() {}
void foo38() {}
void foo39() {}
void foo40() {}
}
class Test {

            void useFoo0(Foo foo, boolean a2, boolean a1, boolean a0) {
foo.foo12();
foo.foo15();
foo.foo3();
foo.foo17();
foo.foo8();
foo.foo10();
foo.foo14();
foo.foo6();
foo.foo1();
foo.foo11();

if (a1) {
foo.foo2();
foo.foo12();
foo.foo5();
foo.foo17();
} else {
foo.foo4();
foo.foo5();
foo.foo14();
foo.foo3();
foo.foo17();
foo.foo6();
foo.foo0();
foo.foo12();
foo.foo12();

}

if (a1) {
foo.foo2();
foo.foo17();
foo.foo5();
} else {
foo.foo14();
foo.foo17();
foo.foo6();
foo.foo1();
foo.foo2();
foo.foo6();
foo.foo2();
foo.foo4();
foo.foo6();
foo.foo5();

}

foo.foo11();
foo.foo2();
foo.foo2();
foo.foo12();
foo.foo4();
foo.foo0();
foo.foo2();
foo.foo0();
foo.foo17();
foo.foo5();

if (a1) {
foo.foo12();
foo.foo14();
foo.foo14();
foo.foo0();
foo.foo6();
foo.foo1();
foo.foo14();
foo.foo12();
foo.foo0();
} else {
foo.foo1();
foo.foo15();
foo.foo8();
foo.foo4();
foo.foo15();
foo.foo2();
foo.foo0();
foo.foo13();
foo.foo12();

}

if (a1) {
foo.foo6();
foo.foo14();
foo.foo1();
foo.foo6();
foo.foo4();
foo.foo11();
foo.foo15();
foo.foo2();
foo.foo6();
} else {
foo.foo0();
foo.foo11();
foo.foo4();

}

if (a1) {
foo.foo11();
foo.foo4();
foo.foo14();
foo.foo15();
foo.foo11();
foo.foo14();
} else {
foo.foo2();
foo.foo17();
foo.foo1();
foo.foo0();
foo.foo6();

}
}

void useFoo1(Foo foo, boolean a2, boolean a1, boolean a0) {
useFoo0(foo, a0, a1, a2);
}
void Test(boolean a2, boolean a1, boolean a0){
Foo foo = Foo.getFoo();
foo.init();
useFoo1(foo, a0, a1, a2);
}
}