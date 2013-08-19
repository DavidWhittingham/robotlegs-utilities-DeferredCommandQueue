package robotlegs.bender.utilities.deferredCommandQueue.tests
{
    import flexunit.framework.Assert;
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.impl.RobotlegsInjector;
    import robotlegs.bender.utilities.deferredCommandQueue.api.IDeferredCommandQueue;
    import robotlegs.bender.utilities.deferredCommandQueue.impl.DeferredCommandQueue;
    import robotlegs.bender.utilities.deferredCommandQueue.impl.RunNextDeferredCommand;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandA;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandB;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandC;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.TracerBulletErrorA;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.TracerBulletErrorB;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.TracerBulletErrorC;

    public class RunNextDeferredCommandTest
    {
        private var _injector:IInjector;

        private var _instance:RunNextDeferredCommand;

        [Before]
        public function setUp():void
        {
            this.createInjector();

            this._instance = this._injector.getInstance(RunNextDeferredCommand);
        }

        [After]
        public function tearDown():void
        {
            this._instance = null;
            this._injector = null;
        }

        [Test]
        public function testExecute():void
        {
            Assert.assertTrue(this.threwError(TracerBulletErrorA, this._instance.execute));
            Assert.assertTrue(this.threwError(TracerBulletErrorB, this._instance.execute));
            Assert.assertTrue(this.threwError(TracerBulletErrorC, this._instance.execute));
            Assert.assertFalse(
                "No unexpected errors were thrown if there's no command to execute",
                threwError(Error, this._instance.execute));
        }

        [Test]
        public function testRunNextDeferredCommand():void
        {
            Assert.assertTrue(this._instance is RunNextDeferredCommand);
        }

        private function createInjector():void
        {
            this._injector = new RobotlegsInjector();

            this._injector.map(IInjector).toValue(this._injector);
            this._injector.map(TracerBulletErrorC).toSingleton(TracerBulletErrorC);
            this._injector.map(IDeferredCommandQueue).toValue(this.getDeferredCommandQueue());
            this._injector.map(RunNextDeferredCommand).toType(RunNextDeferredCommand);
            this._injector.map(SampleCommandA).toType(SampleCommandA);
            this._injector.map(SampleCommandB).toType(SampleCommandB);
            this._injector.map(SampleCommandC).toType(SampleCommandC);
        }

        private function getDeferredCommandQueue():DeferredCommandQueue
        {
            var queue:DeferredCommandQueue = new DeferredCommandQueue();

            queue.addCommandToQueue(SampleCommandA);
            queue.addCommandToQueue(SampleCommandB);
            queue.addCommandToQueue(SampleCommandC);

            return queue;
        }

        private function threwError(errorClass:Class, func:Function)
        {
            var errThrown:Boolean = false;

            try
            {
                func.call();
            }
            catch (e:Error)
            {
                if (e is errorClass)
                {
                    errThrown = true;
                }
            }

            return errThrown;
        }
    }
}


