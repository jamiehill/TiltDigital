package com.tiltdigital.swiz.beans.audio.controllers.adjustments
{
	import com.tiltdigital.tools.MathsTools;
	import flash.media.SoundChannel;
	import mx.effects.easing.*;
	import com.tiltdigital.swiz.beans.audio.controllers.adjustments.*;
	
	public class RightPeak extends AdjustmentBase
	{
		/**
		 * Constructor --
		 * 
		 * The RightPeak IAdjustment represents an adjustment applied to a Sounds SoundChannel object.
		 * 
		 * @param finish		The value you want to finish the IAdjustment at
		 * @param duration 		The duration of the IAdjustment ( use seconds )
		 * @param begin			[optional] The value you want to start the IAdjustment from
		 * @param ease			[optional] Easing function 
		 */
		public function RightPeak( finish:Number, duration:Number = 0, begin:Number = -1, ease:Function = null )
		{
			var finishValue:int, easing:Function;
			
			finishValue	= MathsTools.clamp( finish, 0, 1 );
			easing		= ( ease != null ) ? ease : Linear.easeNone;
			
			super( "rightPeak", finishValue, duration, begin, easing );
		}
	}
}