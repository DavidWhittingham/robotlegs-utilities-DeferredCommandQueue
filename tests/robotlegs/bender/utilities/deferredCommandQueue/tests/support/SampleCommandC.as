package robotlegs.bender.utilities.deferredCommandQueue.tests.support
{

    public class SampleCommandC
    {

        [Inject]
        public var injectedError:TracerBulletErrorC;

        public function execute():void
        {
            throw(injectedError);
        }
    }
}
