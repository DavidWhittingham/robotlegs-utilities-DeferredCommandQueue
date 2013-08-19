package robotlegs.bender.utilities.deferredCommandQueue.tests.support
{

    public class SampleCommandA
    {

        public function execute():void
        {
            throw(new TracerBulletErrorA());
        }
    }
}
