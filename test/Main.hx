import twny.Tween;
import twny.easing.*;

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
                    t0 = new Tween(d, false)
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
                                it("should update object correctly", o.x.should.be(600));

                                describe("then update to", {
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
                    beforeEach({t0.autodispose = true; t0.start();});

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
                            t1 = o.tween(d).to(Linear.easeNone, o.x = 300)
                        )
                        .reuse()
                        .repeat();

                    t2 = o.tween(d)
                        .to(Linear.easeNone, o.y = -100)
                        .then(
                            t3 = o.tween(d).to(Linear.easeNone, o.y = -300)
                        )
                        .reuse()
                        .repeat();
                });

                describe("then start", {
                    beforeEach(t0.start());
                    beforeEach(t2.start());
                    it("should create target store", {
                        @:privateAccess Twny.targets.get(o).should.not.be(null);
                    });

                    describe("then update to 1st half", {
                        beforeEach(Twny.update(d / 2));
                        it("should have correct value", o.x.should.be(50));
                        it("should have correct value", o.y.should.be(-50));

                        describe("then update to 2nd half", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", o.x.should.be(200));
                            it("should have correct value", o.y.should.be(-200));

                            describe("then update with overhead to 1st end", {
                                beforeEach(Twny.update(d + d / 2));
                                it("should have correct value", o.x.should.be(100));
                                it("should have correct value", o.y.should.be(-100));
                            });
                        });

                        describe("then target pause", {
                            beforeEach(o.pause());

                            describe("then update to 2nd half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(50));
                                it("should have correct value", o.y.should.be(-50));
                            });

                            describe("then target resume", {
                                beforeEach(o.resume());

                                describe("then update to 2nd half", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", o.x.should.be(200));
                                    it("should have correct value", o.y.should.be(-200));
                                });
                            });
                        });

                        describe("then target stop", {
                            beforeEach(o.stop());

                            describe("then update to 2nd half", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(50));
                                it("should have correct value", o.y.should.be(-50));
                            });

                            describe("then target start", {
                                beforeEach(o.start());
    
                                describe("then update to 1st half", {
                                    beforeEach(Twny.update(d / 2));
                                    it("should have correct value", o.x.should.be(75));
                                    it("should have correct value", o.y.should.be(-75));
                                });
                            });
                        });

                        describe("then target stop and complete", {
                            beforeEach(o.stop(true));
                            it("should have correct value", o.x.should.be(300));
                            it("should have correct value", o.y.should.be(-300));

                            describe("then update", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(300));
                                it("should have correct value", o.y.should.be(-300));
                            });

                            describe("then target start", {
                                beforeEach(o.start());

                                describe("then update to 1st half", {
                                    beforeEach(Twny.update(d / 2));
                                    it("should have correct value", o.x.should.be(200));
                                    it("should have correct value", o.y.should.be(-200));
                                });
                            });
                        });

                        describe("then target dispose", {
                            beforeEach(o.dispose());
                            it("should remove target store", {
                                @:privateAccess Twny.targets.get(o).should.be(null);
                            });
                            it("should be disposed", @:privateAccess {
                                t0.head.should.be(null);
                                t1.head.should.be(null);
                                t2.head.should.be(null);
                                t3.head.should.be(null);
                                t0.running.should.be(false);
                                t1.running.should.be(false);
                                t2.running.should.be(false);
                                t3.running.should.be(false);
                            });

                            describe("then update", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", o.x.should.be(50));
                                it("should have correct value", o.y.should.be(-50));
                            });

                            describe("then target start", {
                                beforeEach(o.start());
    
                                describe("then update", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", o.x.should.be(50));
                                    it("should have correct value", o.y.should.be(-50));
                                });
                            });
                        });
                    });
                });
            });

            describe("when init tree tween", {
                var d = 10, o, t0, t1, t2, t3, t4;
                beforeEach({
                    o = {
                        a: 0.,
                        b: 0.,
                        x: 0.,
                        y: 0.
                    };

                    t0 = o.tween(0)
                        .then(
                            t1 = o.tween(d).to(Linear.easeNone, o.a = 100)
                                .then(
                                    t2 = o.tween(d).to(Linear.easeNone, o.x = 100)
                                )
                                .then(
                                    t3 = o.tween(d * 2).to(Linear.easeNone, o.y = 100)
                                        .then(
                                            t4 = o.tween(d).to(Linear.easeNone, {
                                                o.a = 0;
                                                o.b = 0;
                                                o.x = 0;
                                                o.y = 0;
                                            })
                                        )
                                )
                        )
                        .then(
                            o.tween(d * 2).to(Linear.easeNone, o.b = 100)
                        )
                        .reuse()
                        .repeat();
                });

                describe("then start", {
                    beforeEach(t0.start());

                    describe("then update to 1st", {
                        beforeEach(Twny.update(d));
                        it("should have correct value", {
                            o.a.should.be(100);
                            o.b.should.be(50);
                            o.x.should.be(0);
                            o.y.should.be(0);
                        });

                        describe("then update to 2nd", {
                            beforeEach(Twny.update(d));
                            it("should have correct value", {
                                o.a.should.be(100);
                                o.b.should.be(100);
                                o.x.should.be(100);
                                o.y.should.be(50);
                            });

                            describe("then update to 3rd", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", {
                                    o.a.should.be(100);
                                    o.b.should.be(100);
                                    o.x.should.be(100);
                                    o.y.should.be(100);
                                });

                                describe("then update to 4th half", {
                                    beforeEach(Twny.update(d / 2));
                                    it("should have correct value", {
                                        o.a.should.be(50);
                                        o.b.should.be(50);
                                        o.x.should.be(50);
                                        o.y.should.be(50);
                                    });

                                    describe("then update with overhead to 1st half", {
                                        beforeEach(Twny.update(d));
                                        it("should have correct value", {
                                            o.a.should.be(50);
                                            o.b.should.be(25);
                                            o.x.should.be(0);
                                            o.y.should.be(0);
                                        });
                                    });
                                });
                            });
                        });

                        describe("then target pause", {
                            beforeEach(o.pause());

                            describe("then update to 2nd", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", {
                                    o.a.should.be(100);
                                    o.b.should.be(50);
                                    o.x.should.be(0);
                                    o.y.should.be(0);
                                });
                            });

                            describe("then target resume", {
                                beforeEach(o.resume());

                                describe("then update to 2nd", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", {
                                        o.a.should.be(100);
                                        o.b.should.be(100);
                                        o.x.should.be(100);
                                        o.y.should.be(50);
                                    });
                                });
                            });
                        });

                        describe("then target stop", {
                            beforeEach(o.stop());

                            describe("then update to 2nd", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", {
                                    o.a.should.be(100);
                                    o.b.should.be(50);
                                    o.x.should.be(0);
                                    o.y.should.be(0);
                                });
                            });

                            describe("then target start", {
                                beforeEach(o.start());
    
                                describe("then update to 1st", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", {
                                        o.a.should.be(100);
                                        o.b.should.be(75);
                                        o.x.should.be(0);
                                        o.y.should.be(0);
                                    });
                                });
                            });
                        });

                        // describe("then target stop and complete", {
                        //     beforeEach(o.stop(true));
                        //     it("should have correct value", {
                        //         o.a.should.be(0);
                        //         o.b.should.be(0);
                        //         o.x.should.be(0);
                        //         o.y.should.be(0);
                        //     });

                        //     describe("then update", {
                        //         beforeEach(Twny.update(d));
                        //         it("should have correct value", {
                        //             o.a.should.be(0);
                        //             o.b.should.be(0);
                        //             o.x.should.be(0);
                        //             o.y.should.be(0);
                        //         });
                        //     });

                        //     describe("then target start", {
                        //         beforeEach(o.start());

                        //         describe("then update to 1st", {
                        //             beforeEach(Twny.update(d));
                        //             it("should have correct value", {
                        //                 o.a.should.be(100);
                        //                 o.b.should.be(50);
                        //                 o.x.should.be(0);
                        //                 o.y.should.be(0);
                        //             });
                        //         });
                        //     });
                        // });

                        describe("then target dispose", {
                            beforeEach(o.dispose());
                            it("should remove target store", {
                                @:privateAccess Twny.targets.get(o).should.be(null);
                            });
                            it("should be disposed", @:privateAccess {
                                t0.head.should.be(null);
                                t1.head.should.be(null);
                                t2.head.should.be(null);
                                t3.head.should.be(null);
                                t4.head.should.be(null);
                                t0.running.should.be(false);
                                t1.running.should.be(false);
                                t2.running.should.be(false);
                                t3.running.should.be(false);
                                t4.running.should.be(false);
                            });

                            describe("then update", {
                                beforeEach(Twny.update(d));
                                it("should have correct value", {
                                    o.a.should.be(100);
                                    o.b.should.be(50);
                                    o.x.should.be(0);
                                    o.y.should.be(0);
                                });
                            });

                            describe("then target start", {
                                beforeEach(o.start());
    
                                describe("then update", {
                                    beforeEach(Twny.update(d));
                                    it("should have correct value", {
                                        o.a.should.be(100);
                                        o.b.should.be(50);
                                        o.x.should.be(0);
                                        o.y.should.be(0);
                                    });
                                });
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
