package robotlegs.bender.utilities.deferredCommandQueue.impl 
{
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.utilities.deferredCommandQueue.api.IDeferredCommandQueue;
	
	public class RunNextDeferredCommand
	{
	
		[Inject]
		public var deferredCommandQueue:IDeferredCommandQueue;
		
		[Inject]
		public var injector:IInjector;
		
		public function execute():void 
		{
			if(!this.deferredCommandQueue.hasNextCommand)
			{
			   return;
			}
			
			var commandClass:Class = this.deferredCommandQueue.getNextCommand();
			var command:Object = this.injector.getInstance(commandClass);
			
			command.execute();
		} 
	}
}
