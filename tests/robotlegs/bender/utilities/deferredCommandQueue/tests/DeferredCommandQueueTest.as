package robotlegs.bender.utilities.deferredCommandQueue.tests
{
    import flash.errors.IllegalOperationError;
    import flexunit.framework.Assert;
    import robotlegs.bender.utilities.deferredCommandQueue.api.IDeferredCommandQueue;
    import robotlegs.bender.utilities.deferredCommandQueue.impl.DeferredCommandQueue;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandA;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandB;
    import robotlegs.bender.utilities.deferredCommandQueue.tests.support.SampleCommandC;

    public class DeferredCommandQueueTest
    {
        private var _instance:IDeferredCommandQueue;

        [Before]
        public function setUp():void
        {
            this._instance = new DeferredCommandQueue();
        }

        [After]
        public function tearDown():void
        {
            this._instance = null;
        }

        [Test]
        public function testAddCommandToQueue():void
        {
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandA));
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandB));
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandC));
        }

        [Test]
        public function testAddCommandToQueueWithRepeat():void
        {
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandA));
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandA, true));
        }

        [Test]
        public function testAddCommandToQueueWithoutRepeat():void
        {
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandA));
            Assert.assertFalse(this._instance.addCommandToQueue(SampleCommandA));
        }

        [Test]
        public function testDeferredCommandQueue():void
        {
            Assert.assertTrue(this._instance is DeferredCommandQueue);
        }

        [Test]
        public function testGetNextCommand():void
        {
            Assert.assertNull("Command queue is not empty", this._instance.getNextCommand());

            this._instance.addCommandToQueue(SampleCommandA);
            this._instance.addCommandToQueue(SampleCommandB);
            this._instance.addCommandToQueue(SampleCommandC);

            Assert.assertEquals(SampleCommandA, this._instance.getNextCommand());
            Assert.assertEquals(SampleCommandB, this._instance.getNextCommand());
            Assert.assertEquals(SampleCommandC, this._instance.getNextCommand());
        }

        [Test]
        public function testGetNextCommandWithRepeatWhilstInHistory():void
        {
            this._instance.addCommandToQueue(SampleCommandA);
            this._instance.addCommandToQueue(SampleCommandB);

            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertEquals("SampleCommandB was not retrieved from the queue", SampleCommandB, this._instance.getNextCommand());

            this._instance.addCommandToQueue(SampleCommandA, true);

            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertNull("Next command was not null", this._instance.getNextCommand());
        }

        [Test]
        public function testGetNextCommandWithRepeatWhilstStillOnQueue():void
        {
            this._instance.addCommandToQueue(SampleCommandA);
            this._instance.addCommandToQueue(SampleCommandB);
            this._instance.addCommandToQueue(SampleCommandA, true);

            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertEquals("SampleCommandB was not retrieved from the queue", SampleCommandB, this._instance.getNextCommand());
            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertNull("Next command was not null", this._instance.getNextCommand());
        }

        [Test]
        public function testGetNextCommandWithoutRepeatWhilstInHistory():void
        {
            this._instance.addCommandToQueue(SampleCommandA);
            this._instance.addCommandToQueue(SampleCommandB);

            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertEquals("SampleCommandB was not retrieved from the queue", SampleCommandB, this._instance.getNextCommand());

            this._instance.addCommandToQueue(SampleCommandA);

            Assert.assertNull("Next command was not null", this._instance.getNextCommand());
        }

        [Test]
        public function testGetNextCommandWithoutRepeatWhilstStillOnQueue():void
        {
            this._instance.addCommandToQueue(SampleCommandA);
            this._instance.addCommandToQueue(SampleCommandB);
            this._instance.addCommandToQueue(SampleCommandA);

            Assert.assertEquals("SampleCommandA was not retrieved from the queue", SampleCommandA, this._instance.getNextCommand());
            Assert.assertEquals("SampleCommandB was not retrieved from the queue", SampleCommandB, this._instance.getNextCommand());
            Assert.assertNull("Next command was not null", this._instance.getNextCommand());
        }

        [Test]
        public function testGet_hasNextCommand():void
        {
            Assert.assertFalse("Command queue is not empty", this._instance.hasNextCommand);

            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandA));
            Assert.assertTrue(this._instance.addCommandToQueue(SampleCommandB));
            Assert.assertTrue("Command queue is empty, SampleCommandA should be next", this._instance.hasNextCommand);

            Assert.assertEquals(SampleCommandA, this._instance.getNextCommand());
            Assert.assertTrue("Command queue is empty, SampleCommandB should be next", this._instance.hasNextCommand);

            Assert.assertEquals(SampleCommandB, this._instance.getNextCommand());
            Assert.assertFalse("Command queue is not empty", this._instance.hasNextCommand);
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testThrowsErrorIfClassPassedIsNotCommand():void
        {
			this._instance.addCommandToQueue(String);
        }
    }
}
