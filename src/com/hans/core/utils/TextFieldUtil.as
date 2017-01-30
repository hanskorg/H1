package com.hans.core.utils
{
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flash.text.TextField;

	/**
	 * 
	 * @author hans
	 * 
	 */
    public class TextFieldUtil 
    {
		/**
		 *  
		 * @param textField
		 * @param text
		 * 
		 */		
        public static function setTextAndScaleToFit(textField:TextField, text:String):void
        {
            var rectangle:Rectangle = textField.getRect(((textField.parent) ? textField.parent : textField));
            var textFormat:TextFormat = textField.defaultTextFormat;
            switch (textFormat.align)
            {
                case TextFormatAlign.LEFT:
                    textField.autoSize = TextFieldAutoSize.LEFT;
                    break;
                case TextFormatAlign.RIGHT:
                    textField.autoSize = TextFieldAutoSize.RIGHT;
                    break;
                case TextFormatAlign.CENTER:
                case TextFormatAlign.JUSTIFY:
                    textField.autoSize = TextFieldAutoSize.CENTER;
                    break;
                default:
                    textField.autoSize = TextFieldAutoSize.LEFT;
            };
            textField.text = text;
            if (textField.width > rectangle.width)
            {
                textField.scaleX = (textField.scaleX * (rectangle.width / textField.width));
                textField.scaleY = textField.scaleX;
                textField.x = rectangle.x;
            };
        }

        public static function setVCenteredMultilineText(textField:TextField, text:String):void
        {
            var rectangle:Number = (textField.y + (textField.height / 2));
            textField.multiline = true;
            textField.text = text;
            textField.y = (rectangle - (textField.height / 2));
        }


    }
}
