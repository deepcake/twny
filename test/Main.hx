import twny.Tween;
import twny.easing.*;
import twny.TweenerTools.instance as tweener;

using buddy.Should;

class Main extends buddy.SingleSuite {
    public function new() {
        describe("test", {
            beforeEach(tweener.reset());

            describe("when init 1st, 2nd, 3rd tween", {
                var d = 10, o, t0, t1, t2;
                beforeEach({
                    o = {
                        x: 0.,
                        y: 0.
                    };
                    t0 = new Tween(d, false)
                        .to(Linear.easeNone, o.x = 100)
                        .from(Linear.easeNone, o.y = 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x = 300)
                                .from(Linear.easeNone, o.y = 300)
                                .then(
                                    t2 = new Tween(d)
                                        .to(Linear.easeNone, o.x = 600)
                                        .from(Linear.easeNone, o.y = 600)
                                )
                        );
                });

                describe("then start", {
                    beforeEach(t0.start());

                    describe("then update to 1st half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(200));

                            describe("then update to 3rd half", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(450));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(tweener.update(d + d));
                                    it("should update", o.x.should.be(600));
                                });
                            });

                            describe("then pause", {
                                beforeEach(t0.pause());

                                describe("then update to 3rd half", {
                                    beforeEach(tweener.update(d));
                                    it("should not update", o.x.should.be(200));

                                    describe("then update with overhead to 2nd half", {
                                        beforeEach(tweener.update(d + d));
                                        it("should not update", o.x.should.be(200));
                                    });
                                });

                                describe("then resume", {
                                    beforeEach(t0.resume());

                                    describe("then update to 3rd half", {
                                        beforeEach(tweener.update(d));
                                        it("should update", o.x.should.be(450));

                                        describe("then update with overhead to 2nd half", {
                                            beforeEach(tweener.update(d + d));
                                            it("should update", o.x.should.be(600));
                                        });
                                    });
                                });
                            });

                            describe("then stop", {
                                beforeEach(t0.stop());

                                describe("then update to 3rd half", {
                                    beforeEach(tweener.update(d));
                                    it("should not update", o.x.should.be(200));

                                    describe("then update with overhead to 2nd half", {
                                        beforeEach(tweener.update(d + d));
                                        it("should not update", o.x.should.be(200));
                                    });
                                });

                                describe("then start", {
                                    beforeEach(t0.start());

                                    describe("then update to 1st half", {
                                        beforeEach(tweener.update(d / 2));
                                        it("should update", o.x.should.be(150));
                                    });
                                });
                            });

                            describe("then stop and complete", {
                                beforeEach(t0.stop(true));
                                it("should update", o.x.should.be(600));

                                describe("then update", {
                                    beforeEach(tweener.update(d));
                                    it("should not update", o.x.should.be(600));

                                    describe("then update with overhead", {
                                        beforeEach(tweener.update(d + d));
                                        it("should not update", o.x.should.be(600));
                                    });
                                });

                                describe("then start", {
                                    beforeEach(t0.start());

                                    describe("then update to 1st half", {
                                        beforeEach(tweener.update(d / 2));
                                        it("should update", o.x.should.be(350));
                                    });
                                });
                            });
                        });
                    });
                });

                describe("then make repeatable and start", {
                    beforeEach(t0.repeat().start());

                    describe("then update to 1st half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(50));
                        it("should update", o.y.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(200));
                            it("should update", o.y.should.be(150));

                            describe("then update to 3rd half", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(450));
                                it("should update", o.y.should.be(300));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(tweener.update(d + d));
                                    it("should update", o.x.should.be(200));
                                    it("should update", o.y.should.be(150));
                                });
                            });
                        });
                    });
                });

                describe("then make once and start", {
                    beforeEach({t0.autodispose = true; t0.start();});

                    describe("then update to 1st half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(200));

                            describe("then update to 3rd half", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(450));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(tweener.update(d + d));
                                    it("should update", o.x.should.be(600));
                                    it("should be disposed", @:privateAccess {
                                        t0.head.should.be(null);
                                        t1.head.should.be(null);
                                        t2.head.should.be(null);
                                        t0.running.should.be(false);
                                        t1.running.should.be(false);
                                        t2.running.should.be(false);
                                    });
                                });
                            });
                        });
                    });
                });
            });

            describe("when init 1st, 2nd, 3rd tween with relative transitions", {
                var d = 10, o, t0, t1, t2;
                beforeEach({
                    o = {
                        x: 0.,
                        y: 0.
                    };
                    t0 = new Tween(d, false)
                        .to(Linear.easeNone, o.x += 100)
                        .from(Linear.easeNone, o.y += 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x += 300)
                                .from(Linear.easeNone, o.y += 300)
                                .then(
                                    t2 = new Tween(d)
                                        .to(Linear.easeNone, o.x += 600)
                                        .from(Linear.easeNone, o.y += 600)
                                )
                        );
                });

                describe("then make repeatable and start", {
                    beforeEach(t0.repeat().start());

                    describe("then update to 1st half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(100 / 2));
                        it("should update", o.y.should.be(100 / 2));

                        describe("then update to 2nd half", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(100 + 300 / 2));
                            it("should update", o.y.should.be(300 / 2));

                            describe("then update to 3rd half", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(400 + 600 / 2));
                                it("should update", o.y.should.be(600 / 2));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(tweener.update(d + d));
                                    it("should update", o.x.should.be(1000 + 100 + 300 / 2));
                                    it("should update", o.y.should.be(300 / 2));
                                });
                            });
                        });
                    });
                });
            });

            describe("when init 1st, 2nd, 3rd tween with fixed transitions", {
                var d = 10, o, t0, t1, t2;
                beforeEach({
                    o = {
                        x: 0.,
                        y: 0.
                    };
                    t0 = new Tween(d, false)
                        .to(Linear.easeNone, o.x == 100)
                        .from(Linear.easeNone, o.y == 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x == 300)
                                .from(Linear.easeNone, o.y == 300)
                                .then(
                                    t2 = new Tween(d)
                                        .to(Linear.easeNone, o.x == 600)
                                        .from(Linear.easeNone, o.y == 600)
                                )
                        );
                });

                describe("then make repeatable and start", {
                    beforeEach(t0.repeat().start());

                    describe("then update to 1st half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(100 / 2));
                        it("should update", o.y.should.be(100 / 2));

                        describe("then update to 2nd half", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(300 / 2));
                            it("should update", o.y.should.be(300 / 2));

                            describe("then update to 3rd half", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(600 / 2));
                                it("should update", o.y.should.be(600 / 2));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(tweener.update(d + d));
                                    it("should update", o.x.should.be(300 / 2));
                                    it("should update", o.y.should.be(300 / 2));
                                });
                            });
                        });
                    });
                });
            });


            describe("when init tree", {
                var d = 10, o, t0, t1, t2, t3, t4;
                beforeEach({
                    o = {
                        x: 0.,
                        y: 0.
                    };
                    t0 = new Tween(d, false)
                        .to(Linear.easeNone, o.x = 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x = 300)
                                .then(
                                    t2 = new Tween(d)
                                        .to(Linear.easeNone, o.x = 600)
                                )
                        )
                        .then(
                            t3 = new Tween(d / 2)
                                .to(Linear.easeNone, o.y = -200)
                                .then(
                                    t4 = new Tween(d * 2)
                                        .to(Linear.easeNone, o.y = -500)
                                )
                        );
                });

                describe("then make repeatable and start", {
                    beforeEach(t0.repeat().start());

                    describe("then update to half", {
                        beforeEach(tweener.update(d / 2));
                        it("should update", o.x.should.be(100 / 2));
                        it("should update", o.y.should.be(0));

                        describe("then update to full", {
                            beforeEach(tweener.update(d));
                            it("should update", o.x.should.be(100 + (300 - 100) / 2));
                            it("should update", o.y.should.be(-200));

                            describe("then update to full", {
                                beforeEach(tweener.update(d));
                                it("should update", o.x.should.be(300 + (600 - 300) / 2));
                                it("should update", o.y.should.be(-350));

                                describe("then update to full", {
                                    beforeEach(tweener.update(d));
                                    it("should update", o.x.should.be(600));
                                    it("should update", o.y.should.be(-500));

                                    describe("then update to full", {
                                        beforeEach(tweener.update(d));
                                        it("should update", o.x.should.be(100));
                                        it("should update", o.y.should.be(-500));
                                    });
                                });
                            });
                        });
                    });
                });
            });


            describe("when init transitions in different ways", {
                var o, f, t;
                beforeEach({
                    o = {
                        x: .0,
                        y: .0,
                        z: 100.,
                        n: {
                            a: .0,
                            n: {
                                b: .0
                            }
                        },
                        w: .0,
                    };

                    f = function() return o;

                    t = new Tween(10.0)
                        .to(Linear.easeNone, o.x = -100)
                        .to(Linear.easeNone, () -> o.y = 300)
                        .to(Linear.easeNone, () -> { o.z = 500; })
                        .to(Linear.easeNone, {
                            o.n.a = 1.0;
                            o.n.n.b = 1.0;
                        })
                        .to(Linear.easeNone, f().w = 100)
                        .start();
                });

                describe("then update to 1st half", {
                    beforeEach(t.update(5));
                    it("should update", {
                        o.x.should.be(-50);
                        o.y.should.be(150);
                        o.z.should.be(300);
                        o.n.a.should.be(0.5);
                        o.n.n.b.should.be(0.5);
                        o.w = 50;
                    });
                });
            });

            describe("when add callbacks", {
                var r, t;

                beforeEach({
                    r = "";
                    t = new Tween(10)
                        .repeat()
                        .on(0, () -> r += "0")
                        .on(10, () -> r += "F")
                        .onStart(() -> r += "S")
                        .onComplete(() -> r += "C")
                        .on(5, () -> r += "H");
                });

                describe("then start", {
                    beforeEach(t.start());

                    it("should be correctly emitted", {
                        r.should.be("0S");
                    });

                    describe("then update to 4.9", {
                        beforeEach(tweener.update(4.9));

                        it("should be correctly emitted", {
                            r.should.be("0S");
                        });

                        describe("then update to 5.0", {
                            beforeEach(tweener.update(0.1));

                            it("should be correctly emitted", {
                                r.should.be("0SH");
                            });

                            describe("then update to 5.1", {
                                beforeEach(tweener.update(0.1));

                                it("should be correctly emitted", {
                                    r.should.be("0SH");
                                });

                                describe("then update to 10.0", {
                                    beforeEach(tweener.update(5.0));

                                    it("should be correctly emitted", {
                                        r.should.be("0SHFC0S");
                                    });

                                    describe("then update to 11.0", {
                                        beforeEach(tweener.update(1.0));

                                        it("should be correctly emitted", {
                                            r.should.be("0SHFC0S");
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
    }
}
