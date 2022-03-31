import twny.Tween;
import hxease.Linear;

using buddy.Should;

class Main extends buddy.SingleSuite {
    public function new() {
        describe("Test", {

            var o;
            var t;

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

                t = new Tween(10.0, true)
                    .to(Linear.easeNone, {
                        o.x = 100;
                        o.y = 200;
                        o.z = 0;
                    })
                    .then(
                        new Tween(10.0)
                            .to(Linear.easeNone, o.x = -100)
                            .to(Linear.easeNone, () -> o.y = 300)
                            .to(Linear.easeNone, () -> { o.z = 10000; })
                            .to(Linear.easeNone, { 
                                o.n.a = 1.0;
                                o.n.n.b = o.z;
                            })
                    )
                    .start();
            });

            describe("when update x0.5", {
                beforeEach(t.update(5));
                it("should update x correctly", o.x.should.be(50));
                it("should update y correctly", o.y.should.be(100));
                it("should update z correctly", o.z.should.be(50));
                it("should update n.a correctly", o.n.a.should.be(0));
                it("should update n.n.b correctly", o.n.n.b.should.be(0));
            });

            describe("when update x1.0", {
                beforeEach(t.update(10));
                it("should update x correctly", o.x.should.be(100));
                it("should update y correctly", o.y.should.be(200));
                it("should update z correctly", o.z.should.be(0));
                it("should update n.a correctly", o.n.a.should.be(0));
                it("should update n.n.b correctly", o.n.n.b.should.be(0));
            });

            describe("when update x1.0 + x1.0", {
                beforeEach(t.update(20));
                it("should update x correctly", o.x.should.be(-100));
                it("should update y correctly", o.y.should.be(300));
                it("should update z correctly", o.z.should.be(10000));
                it("should update n.a correctly", o.n.a.should.be(1.0));
                it("should update n.n.b correctly", o.n.n.b.should.be(100));
            });

        });
    }
}
