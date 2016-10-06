package br.com.casasbahia.casadobahianinho.cadastro
{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.URLRequest;

    public class UploadImagem extends Sprite {
        private var uploadURL:URLRequest;
        private var file:FileReference;
        private var params:Object;

        public function UploadImagem(info:Object) {
        	params = info;
            uploadURL = new URLRequest();
            uploadURL.url = params.urlServer;
            file = new FileReference();
            configureListeners(file);
        }
		public function browse():void {
			file.browse(getTypes());
		}
		public function upload():void {
			file.upload(uploadURL);
		}
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);
            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
        }

        private function getTypes():Array {
            var allTypes:Array = new Array(getImageTypeFilter());
            return allTypes;
        }

        private function getImageTypeFilter():FileFilter {
            return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
        }

        private function cancelHandler(event:Event):void {
            params.onCancel != null ? params.onCancel.apply(null, [event]) : 0;
        }

        private function completeHandler(event:Event):void {
           params.onComplete != null ? params.onComplete.apply(null, [event]) : 0;
        }

        private function uploadCompleteDataHandler(event:DataEvent):void {
        	trace("uploadCompleteDataHandler: " + event);
            params.onUploadComplete != null ? params.onUploadComplete.apply(null, [event]) : 0;
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            params.onHttpStatus != null ? params.onHttpStatus.apply(null, [event]) : 0;
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
            params.onIoError != null ? params.onIoError.apply(null, [event]) : 0;
        }

        private function openHandler(event:Event):void {
            params.onOpen != null ? params.onOpen.apply(null, [event]) : 0;
        }

        private function progressHandler(event:ProgressEvent):void {
            var file:FileReference = FileReference(event.target);
            trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            params.onProgress != null ? params.onProgress.apply(null, [event]) : 0;
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            params.onSecurityError != null ? params.onSecurityError.apply(null, [event]) : 0;
        }

        private function selectHandler(event:Event):void {
            var file:FileReference = FileReference(event.target);
            trace("selectHandler: name=" + file.name + " URL=" + uploadURL.url);
            params.onSelect != null ? params.onSelect.apply(null, [file]) : 0;
        }
    }
}