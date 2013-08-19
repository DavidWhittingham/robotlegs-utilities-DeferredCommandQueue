package robotlegs.bender.utilities.deferredCommandQueue.tests.support {
	
	public class SampleCommandB {
		public function execute():void
		{
			throw(new TracerBulletErrorB());
		}
	}
}