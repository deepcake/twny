import twny.Tween;
import hxease.Linear;

using buddy.Should;
using twny.Twny;

class Main extends buddy.SingleSuite {
    public function new() {
        describe("test", {
            beforeEach(Twny.reset());

            describe("when init 1st tween with then 2nd with then 3rd", {
                var d = 10, o, t0, t1, t2;
                beforeEach({
                    o = {
                        x: 0.
                    };
                    t0 = new Tween(d)
                        .to(Linear.easeNone, o.x = 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x = 300)
                                .then(
                                    t2 = new Tween(d)
                                        .to(Linear.easeNone, o.x = 600)
                                )
                        );
                });

                describe("then start", {
                    beforeEach(t0.start());

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(200));

                            describe("then update to 3rd half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(450));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(Twny.update(d + d));
                                    it("should have correct value", o.x.should.be(600));
                                });
                            });

                            describe("then pause", {
                                beforeEach(t0.pause());

                                describe("then update to 3rd half", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", o.x.should.be(200));
                                });

                                describe("then resume", {
                                    beforeEach(t0.resume());

                                    describe("then update to 3rd half", {
                                        beforeEach(Twny.update(d));
                                        it("should update object correctly", o.x.should.be(450));
                                    });
                                });
                            });

                            describe("then stop", {
                                beforeEach(t0.stop());

                                describe("then update to 3rd half", {
                                    beforeEach(Twny.update(d));
                                    it("should update object correctly", o.x.should.be(200));
                                });

                                describe("then start", {
                                    beforeEach(t0.start());

                                    describe("then update to 1st half", {
                                        beforeEach(Twny.update(d / 2));
                                        it("should have correct value", o.x.should.be(150));
                                    });
                                });
                            });

                            describe("then stop and complete", {
                                beforeEach(t0.stop(true));

                                describe("then update to 3rd half", {
                                    beforeEach(Twny.update(d));
                                    it("should update object correctly", o.x.should.be(600));
                                });

                                describe("then start", {
                                    beforeEach(t0.start());

                                    describe("then update to 1st half", {
                                        beforeEach(Twny.update(d / 2));
                                        it("should have correct value", o.x.should.be(350));
                                    });
                                });
                            });
                        });
                    });
                });

                describe("then make tween repeat and start", {
                    beforeEach(t0.repeat().start());

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(200));

                            describe("then update to 3rd half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(450));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(Twny.update(d + d));
                                    it("should have correct value", o.x.should.be(200));
                                });
                            });
                        });
                    });
                });

                describe("then make tween once and start", {
                    beforeEach(t0.once().start());

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(200));

                            describe("then update to 3rd half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(450));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(Twny.update(d + d));
                                    it("should have correct value", o.x.should.be(600));
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

            describe("when init relative transition", {
                var d = 10, o, t0, t1;
                beforeEach({
                    o = {
                        x: 0.
                    };
                    t0 = new Tween(d)
                        .to(Linear.easeNone, o.x += 100)
                        .then(
                            t1 = new Tween(d)
                                .to(Linear.easeNone, o.x *= 2)
                        )
                        .repeat();
                });

                describe("then start", {
                    beforeEach(t0.start());

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(150));

                            describe("then update with overhead to 1st half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(250));

                                describe("then update with overhead to 2nd half", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", o.x.should.be(450));
                                });
                            });
                        });
                    });
                });
            });

            describe("when init target tween", {
                var d = 10, o, t0, t1, t2, t3;
                beforeEach({
                    o = {
                        x: 0.,
                        y: 0.
                    };

                    t0 = o.tween(d)
                        .to(Linear.easeNone, o.x = 100)
                        .then(
                            t1 = o.tween(d).to(Linear.easeNone, o.x = 200)
                        )
                        .repeat();

                    t2 = o.tween(d)
                        .to(Linear.easeNone, o.y = -100)
                        .then(
                            t3 = o.tween(d).to(Linear.easeNone, o.y = -200)
                        )
                        .repeat();
                });

                describe("then start", {
                    beforeEach(t0.start());
                    beforeEach(t2.start());

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));
                        it("should have correct value", o.y.should.be(-50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(150));
                            it("should have correct value", o.y.should.be(-150));
                        });

                        describe("then target stop", {
                            beforeEach(o.stop());

                            describe("then update with overhead to 1st half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(50));
                                it("should have correct value", o.y.should.be(-50));
                            });
                        });
                    });
                });
            });

            describe("when init transition in different ways", {
                var o, t;
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
                        } 
                    };
                    t = new Tween(10.0)
                        .to(Linear.easeNone, o.x = -100)
                        .to(Linear.easeNone, () -> o.y = 300)
                        .to(Linear.easeNone, () -> { o.z = 500; })
                        .to(Linear.easeNone, { 
                            o.n.a = 1.0;
                            o.n.n.b = 1.0;
                        })
                        .start();
                });

                describe("then update to 1st half", {
                    beforeEach(t.update(5));
                    it("should update object correctly", {
                        o.x.should.be(-50);
                        o.y.should.be(150);
                        o.z.should.be(300);
                        o.n.a.should.be(0.5);
                        o.n.n.b.should.be(0.5);
                    });
                });
            });
        });
    }
}
