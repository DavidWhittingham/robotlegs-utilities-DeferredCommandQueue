package robotlegs.bender.utilities.deferredCommandQueue.api
{

	public interface IDeferredCommandQueue
	{

		/**
		 * Adds a command class to the queue - throws an error if the class doesn't implement 'execute'
		 * If isRepeated is <code>false</code> then the command is only added if it's not already queued or in history
		 * as having been executed
		 *
		 * @return <code>true</code> if this is a new command, <code>false</code> if it's not (and was not added) */
		function addCommandToQueue(commandClass:Class, isRepeated:Boolean=false):Boolean;

		/**
		 * Gets the next command in the queue
		 *
		 * @return the next command or null if there's nothing left
		 */
		function getNextCommand():Class;

		function get hasNextCommand():Boolean;
	}
}
