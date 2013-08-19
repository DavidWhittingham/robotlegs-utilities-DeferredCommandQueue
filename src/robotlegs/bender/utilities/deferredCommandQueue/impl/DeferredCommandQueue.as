package robotlegs.bender.utilities.deferredCommandQueue.impl
{
    import flash.errors.IllegalOperationError;
    import flash.utils.describeType;
    import robotlegs.bender.utilities.deferredCommandQueue.api.IDeferredCommandQueue;
    import robotlegs.bender.utilities.deferredCommandQueue.api.IDeferredCommandQueue;

    public class DeferredCommandQueue implements IDeferredCommandQueue
    {

        private var _commands:Vector.<Class>;

        private var _commandsHistory:Vector.<Class>;

        /**
         * @inheritDoc
         */
        public function addCommandToQueue(commandClass:Class, isRepeated:Boolean = false):Boolean
        {
            if (!this.isACommand(commandClass))
            {
                throw(new IllegalOperationError('The class you passed as a Command does not implement the required execute method.'));
            }

            if (!isRepeated)
            {
                if (this.isInQueue(commandClass) || this.isInHistory(commandClass))
                {
                    return false;
                }
            }

            this.commands.push(commandClass);

            return true;
        }

        /**
         * @inheritDoc
         */
        public function getNextCommand():Class
        {
            if (this.commands.length > 0)
            {
                var nextCommand:Class = this.commands.shift();
                this.commandsHistory.push(nextCommand);
                return nextCommand;
            }
            return null;
        }

        public function get hasNextCommand():Boolean
        {
            return (this.commands.length > 0);
        }

        private function get commands():Vector.<Class>
        {
            return this._commands || (this._commands = new Vector.<Class>());
        }

        private function get commandsHistory():Vector.<Class>
        {
            return this._commandsHistory || (this._commandsHistory = new Vector.<Class>());
        }

        private function isACommand(commandClass:Class):Boolean
        {
            if (describeType(commandClass).factory.method.(@name == "execute").length() > 0)
            {
                return true;
            }

            return false;
        }

        private function isInHistory(commandClass:Class):Boolean
        {
            return (this.commandsHistory.indexOf(commandClass) != -1)
        }

        private function isInQueue(commandClass:Class):Boolean
        {
            return (this.commands.indexOf(commandClass) != -1)
        }
    }
}